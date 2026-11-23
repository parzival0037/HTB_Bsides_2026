# T04 — outlet / SCADA desk: FINAL REPORT

**Status: 4/4 solved.** All flags were derived from evidence and accepted on
submission.

| Challenge | Flag | How solved |
|---|---|---|
| T04.1 Which value is real | `FLAG{35b940a34aeaa0f0}` | VC-017: measured `observed_volume_l` = 1200.0 L, not the `requested_volume_l` 1000.0 L. Decrypted `captures/volume-sealed.enc` with passphrase sha256(`"1200.0:VC-017"`). |
| T04.2 The light behind the number | `FLAG{5cdc1c2fcc92fb42}` | SC-018 `status_word` = 5 = binary 0101 → bit0 `ready` + bit2 `service_hold`. `service_hold` is what blocks the transfer (outlet closed, request `rejected`). Decrypted `captures/status-sealed.enc` with sha256(`"service_hold:SC-018"`). |
| T04.3 A request is not a movement | `FLAG{03993cc3de147e23}` | Cleared the hold, requested exactly 200 L via API, then verified the transfer from observations. Flag was `batch_reference` on the terminal observation (PT-OBS-000011, `terminal:true`). |
| T04.4 Yesterday's green light | `FLAG{51b9f00459e54f0b}` | Report OR-042's `display_result` is `green`, but the source evidence shows AT-042/RQ-042 was rejected by `service_hold` and nothing moved; the green result actually belonged to the earlier successful AT-041/RQ-041. Decrypted `replay/report-sealed.enc` with sha256(`"green:OR-042"`). |

Submission results (from `submit.py`): T04.1 correct (50), T04.2 correct (50),
T04.3 correct (100), T04.4 correct (100, attempt 2). Team score after: 590.

## Service / endpoint map

Host `state.training` = **10.77.40.50**. Port sweep of 22/80/443/8080-8085/9090/
502/102/4840/47808/44818/20000 found **only 8080 open**. All traffic was run from
the range box. Server banner: `CinderTraining/1.0 Python/3.12.11`.

- `GET /` — markdown desk index (two instrument captures + one outlet-test review + practice tank)
- `GET /field-guide.md` — Document TD-04 rev 1 (TR-1 controller legend, sealed-record passphrase scheme, practice-tank operating rules, API contract)
- `GET /captures/volume.json` + `/captures/volume-sealed.enc` — volume capture VC-017
- `GET /captures/status.json` + `/captures/status-sealed.enc` — controller capture SC-018
- `GET /replay/report.json` + `/replay/report-sealed.enc` — issued report OR-042
- `GET /replay/requests.json` — request register RQ-041, RQ-042
- `GET /replay/observations.csv` — independent observations for AT-041/AT-042
- `GET /practice` — live practice-tank HTML/JS view
- `GET /api/practice/state` — live PT-01 state
- `GET /api/practice/requests` — retained request receipts/register
- `GET /api/practice/observations` — retained observations
- `POST /api/practice/hold` — JSON `{"request_id","active":bool}`
- `POST /api/practice/transfer` — JSON `{"request_id","quantity_l":int}`

`/robots.txt`, `/sitemap.xml`, unknown paths → 404 JSON; `OPTIONS` → 501.
No authentication or credentials are required on this desk; request IDs are
caller-chosen (1–64 chars `[A-Za-z0-9_-]`).

## Data recovered

**VC-017 (tank CT-01, sample VS-017, 2026-06-18T08:00:00Z):**
`requested_volume_l=1000.0`, `observed_volume_l=1200.0`, unit L, quality good.
The measurement (1200.0 L) is the real content; 1000.0 is only the requested
setting.

**SC-018 (tank CT-01, sample SS-018, 2026-06-18T08:00:01Z):**
`controller_revision=TR-1`, `status_word=5`, `outlet_position=closed`,
`request_id=CR-018`, `request_result=rejected`.
TR-1 legend: bit0 ready, bit1 outlet_open, bit2 service_hold, bit3
transfer_active. 5 = 0b0101 → ready + **service_hold**; the hold is the
condition preventing movement (`ready` is not an acknowledgement).

**OR-042 review (tank RT-02), reconstructed timeline:**
- `08:59:59` AT-041/RQ-041: 1200.0 L, closed, status 1 (ready).
- `09:00:00` RQ-041 accepted (transfer 200 L, `status_before=1`).
- `09:00:05` AT-041: 1100.0 L, open, status 11 (ready+outlet_open+transfer_active).
- `09:00:10` AT-041: 1000.0 L, closed, status 1 → 200 L genuinely moved.
- `09:59:59` AT-042/RQ-042: 1000.0 L, closed, status 5 (ready+service_hold).
- `10:00:00` RQ-042 **rejected**, reason `service_hold`, `status_before=5`.
- `10:00:01` AT-042: still 1000.0 L, closed, status 5 → no movement.
- Report OR-042 (generated `10:00:03`) displays `green` / `reported_transfer_l=200`,
  but names `attempt_id=AT-042`, `request_id=RQ-042`, while
  `source_request_id=RQ-041` and `source_accepted_at=2026-06-18T09:00:00Z`.

Conclusion: the report's green light is **yesterday's/earlier success (RQ-041,
09:00) misattributed to the latest attempt (AT-042/RQ-042, 10:00)**. The latest
attempt was rejected by the operating hold, so the claimed 200 L transfer did
not happen; the tank remained at 1000.0 L. Both identifiers and observation
times expose the mismatch.

## Technique that worked

1. Read the markdown index + field guide; it defines the exact semantics, TR-1
   bit legend, and the sealed-record passphrase scheme.
2. For each sealed record, compute `sha256("<finding>:<record ID>")` and decrypt
   with `openssl enc -d -aes-256-cbc -pbkdf2 -nosalt -pass pass:<digest>`.
   Valid padding + `FLAG{...}` output confirms the finding. Findings used:
   `1200.0` / `service_hold` / `green`.
3. For T04.3, use the documented API to clear the hold and request a bounded
   200 L transfer with unique request IDs, then read `/api/practice/observations`.
   The terminal observation carries `batch_reference` = the challenge flag.
4. Correlate report `attempt_id` vs `request_id` vs `source_request_id` and
   observation timestamps/volumes/status words for T04.4.

Live T04.3 operation evidence:
- Before: status_word 5, 1200.0 L, closed.
- `POST /api/practice/hold {"request_id":"t04-hold-clear-1","active":false}` → 200,
  status_word 1.
- `POST /api/practice/transfer {"request_id":"t04-xfer-200-1","quantity_l":200}`
  → 202 accepted at `2026-11-20T17:15:21.735208Z`.
- Observations at 1 s intervals: 1200 → 1180 → … → 1020 (open, status 11), then
  terminal `PT-OBS-000011` at `17:15:31.735437Z`: 1000.0 L, closed, status 1,
  `terminal:true`, `batch_reference: FLAG{03993cc3de147e23}`. Exactly 200 L moved,
  1000 L remained (well above the 200 L minimum).

## Dead ends / notes

- No files were attached in the challenge metadata (`files: []`); all evidence is
  served by the desk itself.
- Port sweep found no extra protocols/services besides HTTP 8080; guessed paths
  (`/flag`, `/practice/sealed`, etc.) returned 404.
- `OPTIONS` on the API returns 501; use the documented GET/POST interface.
- T04.4 had one burned attempt before this lane's work; the correct flag came
  from the sealed OR-042 record with finding `green`, i.e. the value the report
  displays. Do not guess status/bit names here — `service_hold` is T04.2's finding,
  while T04.4's sealed finding is the report's displayed result string.
- The frozen captures (VC-017/SC-018/OR-042) do not change when PT-01 is operated.

## State left on the desk

Practice tank PT-01: **1000.0 L**, outlet **closed**, hold **cleared**,
status_word 1, quality good. Registers retain `t04-hold-clear-1` and
`t04-xfer-200-1` plus 11 observations. This lane needed no further state for
other challenges; no destructive or out-of-bounds action was taken.

## Dependencies / handoff

T04 is self-contained and unlocks nothing in the K-/W- stages; the pivot host
remains `rowan-dev` (10.50.13.180, ssh port 2222, key
`~/.ssh/keplerops-foothold`) per the playbook. PT-01 is left at 1000 L with the
hold cleared; if a later check expects the origin 1200 L state, note that the
desk cannot refill and records cannot be cleared, so only a desk reset would
restore it.
