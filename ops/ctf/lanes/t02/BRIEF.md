LANE: T02 — identity desk.
Target: http://accounts.training:8080/ (10.77.40.30) plus whatever it points to.

Challenges, in order (prerequisite chain):
- T02.1 "An account by any other response": identify the active rehearsal account and
  recover the account-bound case reference the identity desk exposes. The wording hints
  at response differences (status/length/headers) between valid and invalid accounts —
  enumerate accounts and compare responses precisely.
- T02.2 "Hidden on the page": the public directory UI hides rehearsal entries; the
  directory API does not apply the same filter. Fetch the API endpoint directly and
  find the rehearsal account missing from the rendered page, plus the staff detail.
- T02.3 "Recovery is another way in": use the identity evidence to take over the
  rehearsal account through its recovery workflow, then read its private handover.
- T02.4 "Someone else's assignment": from the recovered account, use the assignment
  service to obtain another operator's sealed rehearsal brief (object-level access
  control failure).

Method: read the front page and its source, linked JS, robots.txt, and enumerate API
paths. Two attempts have already been burned on T02.1/T02.2/T02.4 by an earlier
operator — be certain before submitting.
