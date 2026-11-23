# Flags — BSides CTF 2026 (team MoTM)

**50 / 240 solved · 3450 pts.** Registry rebuilt 2026-11-20 ~19:45Z.

Flag format: `FLAG{16 hex}`. The event site does not return submitted flag text, so
values below come from lane artifacts (`lanes/*/REPORT.md`, `notes.md`, captured
responses).

| # | Challenge | Flag | Source |
|---|---|---|---|
| 1 | T01.1 The copy nobody deleted | *(pre-existing solve)* | git history `04176f3:handover.md` → `FLAG{2e184cd91352e573}` (found by lane t01 recon) |
| 2 | T01.2 Off the menu | *(pre-existing solve)* | — |
| 3 | T01.3 A token with a job | *(pre-existing solve)* | — |
| 4 | T01.4 The helper has another job | `FLAG{3bf1d8651d39b64c}` | path traversal `8083 /api/diagnostics/render?view=public/../internal/DL-204.json` |
| 5 | T02.1 An account by any other response | `FLAG{7502f8e82360c288}` | `POST /api/recovery/lookup` `{"account":"rhea.moss"}` |
| 6 | T02.2 Hidden on the page | `FLAG{9e9612ddd489395c}` | `GET /api/directory/staff/STF-204/assignment` |
| 7 | T02.3 Recovery is another way in | `FLAG{0efa33511b93dccd}` | `POST /api/recovery/redeem` rhea.moss/CASE-7Q4M/Blue cabinet 17 |
| 8 | T02.4 Someone else's assignment | `FLAG{50676f831e62140a}` | IDOR `GET /api/assignments/ASG-317/brief` |
| 9 | T03.1 Deleted from the checkout | *pending lane report* | — |
| 10 | T03.2 Verbose enough to publish | *(pre-existing solve)* | — |
| 11 | T03.3 What installation really runs | *pending lane report* | — |
| 12 | T04.1 Which value is real | `FLAG{35b940a34aeaa0f0}` | VC-017 observed 1200.0 L, sealed record key sha256("1200.0:VC-017") |
| 13 | T04.2 The light behind the number | `FLAG{5cdc1c2fcc92fb42}` | SC-018 status 5 = ready+service_hold |
| 14 | T04.3 A request is not a movement | `FLAG{03993cc3de147e23}` | cleared hold, moved 200 L, terminal observation batch_reference |
| 15 | T04.4 Yesterday's green light | `FLAG{51b9f00459e54f0b}` | OR-042 green belonged to AT-041; RQ-042 rejected |
| 16 | K01.1 The developer left a way back | *pending lane report* | — |
| 17 | K01.2 The tab that survived | *pending lane report* | — |
| 18 | K09.x (CI runner) | `FLAG{66b86e03bcba0571}` / `FLAG{7db9f86b38c288ab}` / `FLAG{bf8dabff893031f3}` / `FLAG{ad920ac857c12cd3}` | lane k09 artifacts (token fields) |
| 19 | K13.x (listing/export) | `FLAG{6bb66074f2325405}` | lane k13 `TOK`/`WT` |
| 20 | K17.1 A support session left behind | `FLAG{408710d448134ab5}` | retained conversation, retention reference |
| 21 | K17.x (export handover) | `FLAG{a56dde25afcee8cb}` | support engineer export under ARWC account |

## Where flags physically live

- `lanes/<lane>/REPORT.md` — final report per lane: flag table + technique + endpoint map.
- `lanes/<lane>/notes.md`, `lanes/<lane>/*.out`, `/*.sh` — raw evidence, captured HTTP
  responses, and the exact requests that yielded each flag.
- `/home/kali/ctf/kanban.html` — live board; the **Exploited** column shows flag values.
- `/home/kali/ctf/challenges.json` — authoritative solved/unsolved state from the API.
- `/home/kali/ctf/submissions.json` — full submission history (correct/incorrect,
  points, attempt numbers, timestamps) — but **no flag text**.

## Unmapped values seen in artifacts (not yet attributed)

`FLAG{2e184cd91352e573}` (workbench git history) — belongs to one of T01.1/T01.2.

## Session 2026-11-20 19:00–19:30Z (opencode / lane OC)

All values below were accepted by the event API; `challenges.json` is authoritative.

| Challenge | Flag | Source / technique |
|---|---|---|
| K13.4 What the workload can do | `FLAG{10a79b42b8e652b2}` | ConfigMap `fieldlink/bld-1842` read with the workspace workload JWT (`POST /api/workspaces/current/token-exchange`) |
| K14.1 The trust document | `FLAG{418e19c3ed0c13ef}` | ConfigMap `fieldlink/trust-flx-04` / `/api/trust-records/TRUST-FLX-04` with the workload JWT |
| K14.2 Intended for someone else | `FLAG{f1aee508e418ac7c}` | ConfigMap `fieldlink/role-export-access` (role record) read with the export-role JWT from `POST /api/token-exchange/fieldkest-export-access` |
| K16.1 Tomorrow's job | `FLAG{25a027fe80e77ca0}` | `GET /api/schedules/SCHED-2841` and CronJob `sched-2841` annotation |
| K16.2 The next startup | `FLAG{ba92d77607f974b5}` | patched CronJob env `MARKER=cinder`, then `POST /api/schedules/SCHED-2841/runs` |

Also recovered but already solved elsewhere (do not resubmit): K15.1
`FLAG{6b4342f2b090f8d2}` (`/api/exports/EXP-2841`), K15.2
`FLAG{bd60dc9d170bc2c7}` (`/api/exports/EXP-2841/definition`).
