# 11 — OT and SCADA: registers, units, and what actually moved

A control system does not publish "the tank is at 1200 litres". It publishes an integer in a
register, at a scale, in a unit, from a device that may be held or stale — and above that sit an
HMI, an API, a report and a historian, each re-stating the number in its own vocabulary. Most OT
findings are a mistake in that translation chain.

## 1. What this class of bug is

Every layer between the sensor and the screen is an interpretation. A register needs a scale and
a word order; a status word needs a bit map; a command needs an execution and an observation; a
report needs a provenance link to the execution it describes. When one of those interpretations
is wrong, the system confidently states something false about the plant: a setpoint presented as
a level, "ready" presented as "permitted", an accepted command presented as a completed transfer,
or yesterday's pass presented as today's test.

Precisely: **an OT-facing integration reports or acts on a value that is not the measured process
state** — intent rather than measurement (setpoint), a packed vector read as a scalar (status
word), a queued request read as an effect (`202`), or evidence detached from the execution it
claims to describe (report). The impact is a wrong physical decision: a transfer authorised with
an interlock set, a volume that never existed, or a green light covering a rejected test.

## 2. Why it exists

Six assumptions, all of them reasonable in a web app and all of them false next to a plant.

| The developer assumes | Why it is false |
|---|---|
| **"A number is a number."** `requested_volume_l` and `observed_volume_l` are both litres, so either can fill the "current level" slot. | One is an operator wish, the other is a sensor reading after scaling and unit conversion. Only the second describes water. A UI that paints intent as state lies smoothly, cycle after cycle. |
| **"The integer is the value."** `status_word` is compared with `1` for ready, or shown as one lamp. | The word is a vector of independent booleans. `5` is not five and not "ready"; it is `0b0101`. Whole-word comparison misreads every combination the author did not enumerate. |
| **"Accepted means done."** `202 Accepted` (or `200 OK`) on a transfer command means the water moved. | Three states exist and fail separately: *requested* (well-formed, queued), *applied* (the controller acted), *observed* (the instrument measured it). A hold, an interlock, a fault or a cancelled batch breaks the chain after acceptance. |
| **"The report is the evidence."** The dashboard says green, so the test passed. | A report is derived. If its join is "last successful attempt for this device" rather than "the attempt correlated to this request", a truthful older result is laundered onto a newer rejected one. |
| **"The folder is the origin."** A diagnostic filed under customer A was written for customer A. | Filing is a human decision made years ago; family is a property of the code. Asset count, indexing, units, thresholds and the expected-output vector identify the real origin. |
| **"One source is enough."** The HMI value is the plant value. | The HMI is one view of one register. Mode, command owner, field-data quality, permissives, OPC UA identity and historian series are separate facts that can disagree, and the disagreement is the finding. |

The unifying error: the model's verbs were collapsed into the plant's verbs. *Requested*,
*accepted*, *reported* and *displayed* are not *moved*, *held* or *measured*. Once they share one
column, no amount of correct arithmetic recovers the truth.

## 3. How to spot it

- Field names mixing intent and state with no suffix: `level`, `volume`, `value`, `flow`,
  `position`, `result` beside `requested`, `setpoint`, `target`, `command`, `observed`,
  `measured`, `actual`, `process`.
- A bare integer status with no published bit map, or a doc that gives bit meanings but no
  per-bit rendering. `status_word`, `state`, `flags`, `alarm_word`, `device_status`.
- Human-facing words that hide a permissive: "ready", "available", "healthy", "auto".
- HTTP `202`, `queued`, `job_id`, `accepted_at` on anything that moves a physical thing.
- Report fields like `display_result`, `result`, `pass`, `green`, plus `attempt_id`,
  `request_id`, `source_request_id`, `batch_reference`, `terminal`.
- Registers with scale hints (`×0.1`, `raw`, `word_order`, `float32`, `int16`), unit fields
  (`L`, `m3`, `m3/s`, `%`, `bar`), and engineering references that map a physical instrument to
  an IEC variable, an OPC UA `NodeId`, a historian series and a unit.
- Engineering artefacts that describe a plant: outlet count, indexing base (0 or 1), threshold
  tables, asset model, expected output — in a diagnostic, a test fixture or an export.
- Captures that do not change when the live object is operated: frozen evidence, never proof.
- Three clocks: command time, controller time, historian sample time. A gap or skew between them
  is a correlation bug waiting to be read as a process event.

## 4. How to test it

Read first, act second, and never exceed a documented bound. Placeholders: `plant.example.test`,
`status_word`, `quantity_l`; the practice object in the case study is `PT-01`.

```bash
# 1. Read the state twice, a few seconds apart. Enumerate fields and units before trusting any.
curl -sS http://plant.example.test:8080/api/practice/state | jq .
sleep 5
curl -sS http://plant.example.test:8080/api/practice/state | jq .
```

Two reads tell you what changes on its own (a real measurement drifts) and what only changes when
commanded (a setpoint). A field that equals its own `requested_*` neighbour every cycle is intent.

```bash
# 2. Decode the status word with the documented map; do not guess bit meanings.
python3 - <<'PY'
w = 5
print(bin(w), [i for i in range(8) if w & (1 << i)])
PY
curl -sS http://plant.example.test:8080/api/practice/state | jq '{status_word, outlet, request}'
```

`0b101` says bits 0 and 2 are set. With the vendor map those are, for example, `ready` and
`service_hold` — capability and permission, both true, and the restrictive one wins. Test the
mask you intend to ship (`w & 0x04`) against `w`, not against the word's decimal value.

```bash
# 3. Write the bounds down before you touch anything: quantity, rate, reserve, hold rule.
curl -sS http://plant.example.test:8080/ | grep -iE 'transfer|hold|litre|reserve|rate'
# expected duration = quantity / rate; a 200 L step at 20 L/s takes ~10 s.
```

If the documented maximum is 200 L and 200 L must remain, then 200 L is the largest legal step
and the smallest number of commands. On a live plant you would use the smallest step, not the
largest; here the practice object makes the maximum acceptable and checkable.

```bash
# 4. Take a before observation, including time and status.
curl -sS http://plant.example.test:8080/api/practice/observations | jq '.[-1]'
# {"id":"OBS-1040","level_l":1200.0,"status_word":5,"outlet":"closed","ts":"...Z"}
```

The before sample is your baseline. Without it, any later number is unfalsifiable.

```bash
# 5. Act once, with your own correlation id, and record the response time.
curl -sS -X POST http://plant.example.test:8080/api/practice/hold \
  -H 'Content-Type: application/json' -d '{"request_id":"my-hold-1","active":false}' | jq .
curl -sS -X POST http://plant.example.test:8080/api/practice/transfer \
  -H 'Content-Type: application/json' -d '{"request_id":"my-xfer-1","quantity_l":200}' | tee accept.json | jq .
```

`200` on the hold means the word changed; verify `status_word 5 → 1` rather than trusting the
code. `202` on the transfer means queued. Neither is a movement.

```bash
# 6. Poll until the batch is terminal; verify delta, rate, reserve and timestamps.
curl -sS http://plant.example.test:8080/api/practice/observations \
  | jq '.[] | select(.terminal==true) | {id,level_l,status_word,outlet,ts}'
```

A legal 200 L transfer shows a ~200 L drop over ~10 s, ends with a terminal sample after the
flow, and leaves the reserve intact. No terminal sample, a wrong rate, or a level that never
moved means the request did not become a movement.

```bash
# 7. Only now reconcile the report: three ids, one window.
curl -sS http://plant.example.test:8080/api/reports/OR-000 | jq '{display_result,request_id,attempt_id,source_request_id,quantity_l}'
curl -sS http://plant.example.test:8080/api/practice/observations \
  | jq '.[] | select(.ts > "2026-01-01T09:59:00Z" and .ts < "2026-01-01T10:01:00Z")'
```

If `source_request_id` names a different request than the one that produced the report, the green
belongs to somebody else. Confirm with the observation pair around the command window: zero
movement means zero transfer, whatever the report says.

## 5. Case study from this range

The training desk (`state.training:8080`) modelled a tank `PT-01` with a frozen capture set and a
live practice API. Only 8080 was open; the documented GET/POST interface was the whole surface.

**T04.1 — measurement vs setpoint.** Record `VC-017` reported `requested_volume_l = 1000.0` and
`observed_volume_l = 1200.0`. The round number is the one an operator recognises and the one a
request log echoes; the tank held 1200.0 L. The sealed capture was keyed on
`sha256("<value>:VC-017")`, so the reading became a test rather than an opinion: the right value
decrypts, the wrong one does not. That is the reusable trick — bind the record to one
interpretation and make the alternative fail loudly. See [T04.1](../writeups/T04.1.md).

**T04.2 — the light behind the number.** Capture `SC-018` showed `status_word = 5`,
`outlet = closed`, `request = rejected`. `5` is `0b0101`: bit 0 `ready` and bit 2 `service_hold`.
The plant was simultaneously ready to work and forbidden to move, and the hold was the blocking
condition. Naming the bit, not the decimal and not the friendly lamp, was the answer. The same
capture keyed on `service_hold:SC-018` confirms only a correct bit-map reading. See
[T04.2](../writeups/T04.2.md).

**T04.3 — a request is not a movement.** Clearing the hold with
`{"request_id":"t04-hold-clear-1","active":false}` moved the word `5 → 1`; the transfer
`{"request_id":"t04-xfer-200-1","quantity_l":200}` returned `202` at `17:15:21.735208Z`. The
proof came from the observation stream, not the response: level `1200.0 → 1000.0` in 20 L/s
steps, terminal sample `PT-OBS-000011` at `17:15:31.735437Z`, outlet closed again, and the
`batch_reference` on that terminal sample was the card's token. Ten seconds of flow at the
documented rate is the arithmetic that makes the claim checkable. See
[T04.3](../writeups/T04.3.md).

**T04.4 — yesterday's green light.** Report `OR-042` displayed `green` and a 200 L transfer for
the "latest outlet test". The registers said otherwise: `RQ-042`/`AT-042` at `10:00:00` was
rejected by `service_hold`, and observations at `09:59:59` and `10:00:01` both read `1000.0 L` —
zero movement across a window in which a legal transfer would have taken ~10 s. The green came
from the earlier successful `RQ-041`/`AT-041` at `09:00:00` and had been carried onto the rejected
attempt. A rejected request still creates an attempt row, so a naive join finds an attempt, finds
no observations, and falls back to the last batch with data. The sealed replay was keyed on the
report's displayed string, `green:OR-042`. See [T04.4](../writeups/T04.4.md).

**W19.1 — the diagnostic nobody retired.** The support API stores diagnostics as a job plus a
package: interface `fieldkest.connector/v3`, a CommonJS module exporting `diagnostic_summary`,
and an `expected_output` that is the exact accepted return value. A retained diagnostic was filed
under one customer's records while its embedded constants — outlet multiplicity, indexing,
thresholds, units — described another project family. The lesson is provenance: the customer
field records who filed the job, not who wrote the code, so behaviour gets explained by the wrong
plant model. This card is reconstructed from the retained record and route map rather than a
captured exchange; treat the mechanism as the lesson. See [W19.1](../writeups/W19.1.md).

**W17.x — the four-view reconciliation (card briefs, not solved in this range).** These cards
state the discipline the rest of this chapter builds: record the reservoir's measured state and
the controller's accepted settings, bound to one UTC observation time; identify controller mode,
command owner, field-data state and *both* outlet permissives at one instant; map a physical
instrument through its IEC variable, OPC UA `NodeId`, historian series and unit, and verify the
live point exists; then correlate one bounded outlet observation across FUXA, the OPC UA point
and PostgreSQL history so position and measured flow belong to the same interval and point.
The wording is the checklist: if two views disagree about *which* point or *which* instant, you
are not looking at one measurement.

## 6. Variations and near-misses

- **Register interpretation.** 32-bit value split across two 16-bit registers, either word order;
  scale `0.1` vs `1`; signed vs unsigned; `L` vs `m3`; `%` vs engineering units. Two plausible
  numbers, one truth, and the difference survives review.
- **Bit-level variants.** Active-low permissives (a set bit means *not* permitted); alarm words
  where any bit means stop; unknown bits treated as zero (fail-open); `status == 1` equality tests.
- **Command variants.** Queued behind a hold; accepted then superseded or cancelled; actuator
  faulted after acceptance; applied twice because the caller retried without an idempotency key.
- **Evidence variants.** Report falls back to the last success; cached result from a previous
  deployment; historian gap read as "no change"; clocks in different zones; a `quality: bad`
  sample still rendered; a frozen capture presented as live.
- **Provenance variants.** Diagnostic written for another asset family; expected-output vector
  pinned to an old release; test fixture reused as a production check.

What does **not** count: one sample where setpoint and measurement happen to be equal (a settled
tank is not a bug); a `rejected` request (that is the interlock working); a frozen capture that
does not change when you operate the live object (by design); a status word with bit 0 set (that
is capability, not permission); a report that is merely wrong once without being trusted for a
decision — it becomes a security finding when a system or a human acts on it; and never a guessed
token on a stateful desk, where a wrong submission costs an attempt.

## 7. How to fix it

- **Type the three states.** `setpoint_*` / `measured_*` / `calculated_*`, each with an explicit
  unit and scale; never one `value` column, never a setpoint in a "current" slot.
- **Decode words, not numbers.** Publish the full bit map, render each bit as its own indicator,
  test with masks and named constants, and include the raw word plus the failing bit in every
  rejection reason.
- **Model requested → applied → observed with correlation.** Return a batch/reference id at
  acceptance, close every batch with an immutable terminal observation, and alert when a batch has
  no terminal sample within its expected duration. Re-check hold, reserve and bounds at execution
  time, not only at submission.
- **Bind reports to one execution.** Report rows carry `attempt_id` and `batch_reference`; render
  `unknown` loudly rather than falling back to the previous success; never attach a result older
  than the request; treat rejection as a first-class outcome with a reason code.
- **Sign and scope engineering artefacts.** Record project, asset family and version at import;
  validate scope before running; quarantine mismatches; pin `expected_output` to the release.
- **Require one observation time and two independent sources** for any physical claim: HMI plus
  OPC UA plus historian, aligned to a single UTC instant, with data quality carried alongside the
  value rather than discarded.

## 8. Exercises

1. **Build the plant, then lie with it.** A Flask app with `GET /state` (requested and observed),
   a `status_word` with `ready` and `hold` bits, `POST /hold`, `POST /transfer` returning `202`,
   a tick loop that moves the level at a fixed rate, and `GET /observations` with a `terminal`
   sample. Write a client that refuses to report success without a terminal sample and a matching
   delta. Then break it by adding a report that falls back to the last successful batch; show that
   only the observation stream exposes the lie.
2. **Decode and predict.** With `bit0=ready, bit1=running, bit2=service_hold, bit3=sensor_fault`,
   name the blocking condition for `status_word = 13`, then predict `w == 1`, `w & 0x01` and
   `w & 0x04`. Which comparison should a client ship, and what should it do with unknown bits?
3. **Register arithmetic.** A 32-bit volume arrives as two 16-bit registers, `0x0001` and
   `0xE240`, scale `0.1 L`. Compute the value under both word orders, then say which single piece
   of evidence — engineering reference, historian series, or a known-good observation — settles
   it, and why a second plausible number is the dangerous case.
