# T02 identity desk — notes

Host: accounts.training = 10.77.40.30, port 8080 (Python http.server-ish, CinderTraining/1.0)

## Front page /
Markdown index:
- /candidates.md
- /directory/
- POST /api/recovery/lookup  {"account":"exact.handle"}
- POST /api/recovery/redeem  {"account","case_fragment","staff_detail"}
- GET /api/handover (session)
- GET /api/assignments (session)
Auth: CINDER_REHEARSAL_SESSION cookie or bearer.

## /candidates.md
Three handles: mina.cho (departure paperwork), rhea.moss (Bay 4 rehearsal),
owen.pike (spelling from unsigned note). "exact handle, one at a time".

## /directory/
HTML + module app.js:
- loadPublicDirectory() -> GET /api/directory/staff
- loadCoordinatorAssignment(staffId) -> GET /api/directory/staff/{id}/assignment
Page renders only display_name + team; note "Coordinator assignments are not shown to visitors."

## /api/directory/staff  (rev 12)
STF-204 Rhea Moss / Receiving
STF-317 Dax Hale / Dispatch
(query params revision/include/all/etc ignored)

## Lookup results (POST /api/recovery/lookup)
- mina.cho -> 410 {"state":"inactive"}
- rhea.moss -> 200 {"account":"rhea.moss","case_fragment":"CASE-7Q4M","flag":"FLAG{7502f8e82360c288}","state":"active"}  <-- T02.1
- owen.pike -> 404 {"state":"unknown"}
- random -> 404 {"state":"unknown"}

## /api/directory/staff/STF-204/assignment
200 {"account":"rhea.moss","assignment_id":"ASG-204","flag":"FLAG{9e9612ddd489395c}",
     "rehearsal":"Bay 4 receiving","staff_detail":"Blue cabinet 17",
     "staff_id":"STF-204","staff_record_revision":8}   <-- candidate T02.2
STF-317/assignment -> 403 {"error":"directory_detail_denied"}

Recovery inputs: rhea.moss / CASE-7Q4M / Blue cabinet 17

## Results (all submitted correct)
- T02.1 FLAG{7502f8e82360c288}  (lookup rhea.moss, case_fragment CASE-7Q4M)
- T02.2 FLAG{9e9612ddd489395c}  (GET /api/directory/staff/STF-204/assignment; staff_detail "Blue cabinet 17")
- T02.3 FLAG{0efa33511b93dccd}  (POST /api/recovery/redeem with rhea.moss/CASE-7Q4M/Blue cabinet 17)
- T02.4 FLAG{50676f831e62140a}  (IDOR: GET /api/assignments/ASG-317/brief as rhea.moss)

Session: CINDER_REHEARSAL_SESSION=VfVypNdOCy9v3nxKTpivD0xJWsyKfkEfWE2o3uOdC-c
(subject rhea.moss, still accepted)
