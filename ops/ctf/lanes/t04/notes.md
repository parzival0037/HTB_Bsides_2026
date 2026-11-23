# T04 notes — outlet / SCADA desk

Target: 10.77.40.50:8080 (state.training), server `CinderTraining/1.0 Python/3.12.11`.
Only 8080 responded to the common-port sweep; no SSH/Modbus/s7/OPC ports.

## Endpoint map
- `/` — markdown index (desk)
- `/field-guide.md` — Document TD-04 rev 1, controller family TR-1
- `/captures/volume.json` — VC-017 volume capture (CT-01)
- `/captures/volume-sealed.enc`
- `/captures/status.json` — SC-018 controller capture (CT-01)
- `/captures/status-sealed.enc`
- `/replay/report.json` — issued outlet report OR-042 (RT-02)
- `/replay/report-sealed.enc`
- `/replay/requests.json` — RQ-041/RQ-042
- `/replay/observations.csv` — AT-041/AT-042 observations
- `/practice` — live practice tank PT-01 UI
- `GET /api/practice/state|requests|observations`
- `POST /api/practice/hold` JSON `{"request_id","active"}`
- `POST /api/practice/transfer` JSON `{"request_id","quantity_l"}`

## Key facts from field guide
- `observed_volume_l` is the true measured value; `requested_volume_l` is only a setting.
- TR-1 status bits (LSB=bit0): 0 ready, 1 outlet_open, 2 service_hold, 3 transfer_active.
- Sealed passphrase = sha256(`<finding>:<record ID>`), lowercase hex;
  `openssl enc -d -aes-256-cbc -pbkdf2 -nosalt -pass pass:<pass> -in <file>`.
- PT-01: 1500 L capacity, initial 1200 L, outlet closed, ready+service_hold asserted.
  Bounded transfer 1..200 L, 20 L/s, >=200 L must remain, hold blocks new transfer.

## Findings / flags
- T04.1 VC-017: observed 1200.0 L (requested 1000.0 L is not the measurement).
  pass sha256("1200.0:VC-017") -> FLAG{35b940a34aeaa0f0}
- T04.2 SC-018: status_word 5 = 0b0101 = ready(bit0)+service_hold(bit2);
  request rejected, outlet closed. Blocking condition = service_hold.
  pass sha256("service_hold:SC-018") -> FLAG{5cdc1c2fcc92fb42}
- T04.3: clear hold (t04-hold-clear-1, status 5->1), transfer 200 L
  (t04-xfer-200-1 accepted 17:15:21.735208Z). Observed 1200 -> 1000 L in 20 L/s
  steps; terminal sample PT-OBS-000011 at 17:15:31.735437Z, terminal=true,
  status 1, closed, batch_reference FLAG{03993cc3de147e23}.
- T04.4 OR-042: report says green/200 L, but AT-042 request RQ-042 was rejected
  with service_hold at 10:00:00 and observations show 1000.0 L at 09:59:59 and
  10:00:01 (no movement). Report's source is RQ-041/AT-041 at 09:00:00, the
  earlier successful test (1200->1100->1000 L). The green result belongs to
  yesterday's RQ-041 and was stamped onto the rejected AT-042.
  pass sha256("green:OR-042") -> FLAG{51b9f00459e54f0b}

All four submitted correctly (T04.4 on attempt 2; a prior wrong attempt was burned
before this lane's work).

## State left behind
PT-01 now 1000.0 L, hold cleared, outlet closed; request/observation registers
retain t04-hold-clear-1 and t04-xfer-200-1 (11 observations). Recorded captures
VC-017/SC-018/OR-042 do not change with tank operation.
