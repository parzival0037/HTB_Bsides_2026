# T02 — Identity desk (accounts.training) — FINAL REPORT

Status: **4/4 challenges solved and submitted correct.**
Score delta 220 points (50+20+50+100), rank moved 54 -> 43.

## Flags submitted
| Challenge | Flag | Where it came from |
|---|---|---|
| T02.1 An account by any other response | `FLAG{7502f8e82360c288}` | `POST /api/recovery/lookup` body for `rhea.moss` (also returned `case_fragment: CASE-7Q4M`) |
| T02.2 Hidden on the page | `FLAG{9e9612ddd489395c}` | `GET /api/directory/staff/STF-204/assignment` (unauthenticated; returns `assignment_id ASG-204`, `account rhea.moss`, `rehearsal "Bay 4 receiving"`, `staff_detail "Blue cabinet 17"`) |
| T02.3 Recovery is another way in | `FLAG{0efa33511b93dccd}` | `POST /api/recovery/redeem` with `{"account":"rhea.moss","case_fragment":"CASE-7Q4M","staff_detail":"Blue cabinet 17"}` (201 Created, sets session) |
| T02.4 Someone else's assignment | `FLAG{50676f831e62140a}` | IDOR: `GET /api/assignments/ASG-317/brief` using rhea.moss's session (owner is `dax.hale`; own brief is ASG-204) |

All four were accepted as `correct:true` on the first submission by this lane
(T02.1 attempt 3, T02.2 attempt 4, T02.3 attempt 2, T02.4 attempt 3 globally).

## Service / endpoint map (10.77.40.30, accounts.training:8080)
Server header: `CinderTraining/1.0 Python/3.12.11`; custom HTTP handler, no OPTIONS (501).
JSON errors are `{"error":"..."}`; unknown paths -> 404 `{"error":"not_found"}`.

- `GET /` — markdown index. Advertises: `/candidates.md`, `/directory/`,
  `POST /api/recovery/lookup`, `POST /api/recovery/redeem`,
  `GET /api/handover`, `GET /api/assignments`.
  Auth via `CINDER_REHEARSAL_SESSION` cookie or bearer value.
- `GET /candidates.md` — three handles to review: `mina.cho`, `rhea.moss`, `owen.pike`.
  States lookups are exact-match, one at a time.
- `GET /directory/` — HTML staff directory. Loads module `./app.js`.
- `GET /directory/app.js` — exports:
  - `loadPublicDirectory()` -> `GET /api/directory/staff`
  - `loadCoordinatorAssignment(staffId)` -> `GET /api/directory/staff/{staffId}/assignment`
- `GET /api/directory/staff` — public directory JSON, `revision: 12`,
  staff: `STF-204` Rhea Moss / Receiving, `STF-317` Dax Hale / Dispatch.
  Query params (`revision`, `include`, `all`, `team`, `limit`, ...) are ignored.
- `GET /api/directory/staff/{id}/assignment` — the un-filtered "private" endpoint.
  - STF-204 -> 200 with the assignment + staff detail + T02.2 flag.
  - STF-317 -> 403 `{"error":"directory_detail_denied"}` (authz present for the other staff).
  - Other IDs -> 404 `{"error":"staff_not_found"}`. Only STF-204 and STF-317 exist
    (enumerated STF-100..STF-400).
- `POST /api/recovery/lookup` — `{"account":"exact.handle"}`:
  - `rhea.moss` -> 200 `{account, case_fragment:"CASE-7Q4M", flag, state:"active"}`
  - `mina.cho` -> 410 `{"state":"inactive"}` (gone)
  - `owen.pike` and random handles -> 404 `{"state":"unknown"}`
- `POST /api/recovery/redeem` — exactly
  `{"account","case_fragment","staff_detail"}`. Success 201, body
  `{flag, session, subject}` + `Set-Cookie: CINDER_REHEARSAL_SESSION=...; HttpOnly; SameSite=Strict`.
- `GET /api/handover` — authenticated. Returns markdown private handover for the
  subject (rhea.moss): own assignment ASG-204 paired with dispatch ASG-317,
  and points at `GET /api/assignments/{id}/brief`.
- `GET /api/assignments` — authenticated. List of own assignments:
  `ASG-204`, owner rhea.moss, `paired_assignment_id: ASG-317`, revision 3, "Bay 4 receiving".
- `GET /api/assignments/{id}/brief` — authenticated but **no object-level ownership check**.
  - ASG-204 -> own brief (receiving): "Receive three sealed parcels from CR-17 and retain the manifest audit."
  - ASG-317 -> **dax.hale's** sealed dispatch brief + T02.4 flag:
    "Release DL-204 only after the Bay 4 courier and seal values agree."

## Credentials / secrets obtained
- Recovered account: `rhea.moss` (active rehearsal account).
- Recovery evidence: `case_fragment = CASE-7Q4M`, `staff_detail = Blue cabinet 17`.
- Session token issued by redeem (still valid at time of writing):
  `CINDER_REHEARSAL_SESSION=VfVypNdOCy9v3nxKTpivD0xJWsyKfkEfWE2o3uOdC-c`
  (subject `rhea.moss`). Reuse it as cookie or bearer against accounts.training:8080.
- Other account referenced: `dax.hale` (owner of dispatch assignment ASG-317).
- Handles with no useful session: `mina.cho` inactive, `owen.pike` unknown.

## Technique that worked
1. Read the markdown front page instead of guessing: it documented every API.
2. Candidate list gave exact handles; lookup responses differ by status/body:
   200 active (with case_fragment + flag), 410 inactive, 404 unknown. rhea.moss was
   the only active one -> T02.1.
3. Read `/directory/app.js`; it exposed a `loadCoordinatorAssignment()` call the page
   never uses. Hitting `/api/directory/staff/STF-204/assignment` directly returned the
   hidden assignment + `staff_detail` -> T02.2, and supplied the missing recovery input.
4. Chained T02.1 `case_fragment` + T02.2 `staff_detail` into the documented
   `/api/recovery/redeem` to take over rhea.moss -> T02.3 flag and session.
5. Used the session on `/api/assignments` to learn the paired assignment ID, then
   replaced it in `/api/assignments/ASG-317/brief` (IDOR / missing ownership check)
   -> T02.4.

## Dead ends / non-issues
- `robots.txt` -> 404 (nothing hidden there).
- Directory query params (`?revision=`, `?include=`, `?all=`, `?team=`, `?limit=`,
  `?include_hidden=`, `?role=coordinator`, `?full=1`, `?staff_detail=1`) are ignored;
  revision fuzzing 0..20 returns the same two staff. The "extra" data comes from the
  assignment sub-resource, not the staff list.
- `/api/directory`, `/api/staff`, `/staff`, `/api/lookup`, `/api/v1/...`,
  `/api/directory/staff/all|hidden`, `/api/directory/rehearsals|assignments` all 404.
- `GET /api/directory/staff/STF-204` (no `/assignment`) -> 404; only the assignment
  sub-path is routed.
- STF-317/assignment stays 403 even with rhea's session (`directory_detail_denied`);
  not needed for any T02 flag.
- OPTIONS -> 501 (server is a bare custom handler); no CORS/method tricks needed.

## What later stages depend on / handoff notes
- The recovered rhea.moss session is the only authenticated handle into the identity
  desk; T02.4 was the last T02 gate, so this lane is complete.
- The stolen dispatch brief (ASG-317, dax.hale) mentions `DL-204`, a "Bay 4 courier",
  and matching "seal values" — likely a cross-desk reference into the workbench /
  courier (10.77.40.20 :8081/:8082) or downstream KeplerOps stages. Pass `ASG-204`/
  `ASG-317`, `DL-204`, `CR-17`, `CASE-7Q4M`, and `Blue cabinet 17` along as context.
- No changes were made to server state other than consuming the one-time recovery for
  rhea.moss (session created); lookups and directory reads are read-only. The session
  remains usable if another lane needs to re-read handover/assignments.
