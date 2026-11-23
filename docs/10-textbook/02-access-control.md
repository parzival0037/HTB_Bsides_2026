# 02 — Access control: authentication is not authorization

## 1. What this class of bug is

A request arrives with a valid session. The service checks the session, decides the caller is
`rhea.moss`, and then does what the URL says: returns assignment `ASG-317`. The session check
passed. The object check never existed. That is the whole bug class.

Precise definition: **missing or mis-scoped authorization** — the service authenticates the
principal (or accepts a token that names one), then performs an action on an object or within
a tenant without verifying that *this* principal may act on *this* object, in *this* role, of
*this* tenant. Variants share one shape: the authorization decision is made from something
the caller supplies (an id, a role name, an audience, a tenant, a mutable `is_current` flag)
rather than from the caller's identity. Where the object is identified in the request and the
check is absent, the older name is **IDOR** (insecure direct object reference).

Authentication answers *who are you*. Authorization answers *may you do this, to that*. A
service can have excellent authentication and no authorization at all, and that is the normal
state of a hand-written API on its second sprint.

## 2. Why it exists

Four assumptions, in the order you will meet them in code:

- **"Only authenticated users reach this route, so the data is safe."** Frameworks make
  route-level checks trivial (`@login_required`, an auth middleware, an ingress rule) and
  object-level checks manual. So the first is everywhere and the second is missing. The
  server classifies routes as *public* or *authenticated* and never asks
  `may(subject, "read", object)`.
- **"The UI only shows the user their own objects."** The list endpoint is honestly scoped —
  `WHERE owner = session.subject` — and the detail endpoint does a primary-key lookup. The
  scoping is a *filter*, not a check, and the id in the URL is the authorization decision.
  Front-end filtering is a display setting.
- **"The token says what I may do."** A token exchange that takes the audience or role from
  the request path and mints it for any valid caller authorizes on the caller's *request*
  instead of the caller's *trust record*. Same mistake in JWT form: a `role` claim trusted
  from the token or from a header, or a service-account token whose subject (`svc-export`)
  erases the human it acts for.
- **"One record is current, so it is the truth."** Tenant isolation is authorization over a
  key. When the tenant comes from the path or body, and "which tenant is mine / which is
  current" is answered by a mutable `is_current` flag or a local replica, isolation degrades
  into a data-quality problem. Two stores disagreeing is not an edge case; it is the design.

The recurring tell in all four: **the code knows the right answer and does not compare it.**
The T02.4 response returns `"owner": "dax.hale"` to a session belonging to `rhea.moss`: it
had the owner in hand and never compared.

## 3. How to spot it

- Identifiers in paths and bodies: `/api/assignments/ASG-317/brief`,
  `/api/exports/EXP-2841/definition`, `?account=`, `{"tenant": "..."}`. If the id is in the
  request, ask where the ownership predicate is.
- **Sequential or patterned ids** (`ASG-204`, `ASG-317`, `EXP-2841`) — guessing is not even
  required, and neighbours are usually other users' objects.
- Your own object advertises someone else's (`paired_assignment_id`, `parent_id`,
  `delegated_to`), and a correctly scoped list sits next to a detail route that is not.
  Test the pair, always; the extra id is reconnaissance handed to you.
- A response that states `owner`, `created_by`, `tenant`, `subject` — and the value is not
  you. The mismatch is the proof, not the status code.
- Role/audience names in the request: `POST /api/token-exchange/<audience>`, `role=admin`,
  `X-Tenant-Id`, `?as=`, `on_behalf_of`. Accepted from the caller, each is role or tenant
  confusion. The same goes for readable delegation metadata: a `ConfigMap` mapping audience
  → role → service account, a role record in an exchange response, a permission matrix in a
  client bundle.
- Sub-resources "written for a trusted worker": `/definition`, `/runs`, `/export`, `/raw`,
  `/download`, `/internal`. The worker needs them for every job, so the role is shared, so
  the object check was skipped.

## 4. How to test it

Do this with **two identities you are entitled to use** (your own and one issued for
testing). Never modify another principal's data; read one record, prove the boundary, stop.

```bash
H=https://target:8080
curl -sS -c /tmp/a.jar -H 'Content-Type: application/json' -d '{"user":"alice","pass":"..."}' \
     "$H/api/login"
curl -sS -b /tmp/a.jar "$H/api/assignments" | jq .
```

Record your own object (`ASG-204`, owner `alice`, `paired_assignment_id: ASG-317`), then
run the control case — your own detail route — and the test in one pass:

```bash
curl -sS -b /tmp/a.jar -o /tmp/own  -w 'own  %{http_code} %{size_download}\n' \
     "$H/api/assignments/ASG-204/brief"
curl -sS -b /tmp/a.jar -o /tmp/other -w 'other %{http_code} %{size_download}\n' \
     "$H/api/assignments/ASG-317/brief"
diff -u /tmp/own /tmp/other | head -20
```

Change **one** variable: the id. Session, headers and method stay fixed. Then classify:

| Result | Reading |
|---|---|
| `200`, body is another owner's object | object-level authorization absent — the finding |
| `403` / `404` | a check fired; correct behaviour, note it and move on |
| `200` with your own object echoed | the id was ignored or rewritten server-side; try a nested or array form |

Three bypass shapes, one request each, because filters are often applied to the first id only:

```bash
curl -sS -b /tmp/a.jar "$H/api/assignments?ids=ASG-204,ASG-317"     # batch, first id only?
curl -sS -b /tmp/a.jar "$H/api/assignments/ASG-204/../ASG-317/brief" # normalisation
```

For role/tenant surfaces the shape is the same: hold the token fixed, change the
role/audience/tenant to one that is not yours, and check whether the response is *your* data
or *theirs*, and whether the header/body field is used at all.

```bash
curl -sS -X POST -H "Authorization: Bearer $SA_JWT" \
     "$H/api/token-exchange/other-team-role" | jq '{audience,role,subject}'
```

If `subject` is not the identity you started with, the exchange authorized on the path. Do
not write with such a token; read one object, record caller → audience → role, stop.

## 5. Case study from this range

### T02.4 — the brief belongs to someone else

A valid `rhea.moss` session, a correctly scoped list, and a detail route with no ownership
predicate:

```text
GET /api/assignments  (cookie: rhea.moss)
{"assignments":[{"assignment_id":"ASG-204","owner":"rhea.moss",
                 "paired_assignment_id":"ASG-317","revision":3}]}
GET /api/assignments/ASG-204/brief  -> "Receive three sealed parcels from CR-17 ..."
GET /api/assignments/ASG-317/brief  -> {"assignment_id":"ASG-317","owner":"dax.hale",
  "brief":"Release DL-204 only after the Bay 4 courier and seal values agree.",
  "flag":"FLAG{50676f831e62140a}"}
```

The reasoning is in the third response, not the flag: the server printed `owner: dax.hale`
while serving `rhea.moss`, so it had the ownership data and performed no comparison. The
list route filtered honestly; the bug was assuming a route that requires a session is
therefore scoped to it — and `paired_assignment_id` named the neighbour to ask for. [`../writeups/T02.4.md`](../writeups/T02.4.md)

### K15.2 — the definition route is not stricter than the record route

An export job `EXP-2841` belongs to a support principal. A developer identity exchanged a
workload token for the *export service's* audience and read both routes:

```text
GET /api/exports/EXP-2841             -> the job record        (K15.1)
GET /api/exports/EXP-2841/definition  -> dataset, selection, revision pin, handover
                                         destination + FLAG{bd60dc9d170bc2c7}
```

Three layers each assumed another did the check: a valid JWT with the right audience
(authentication), a role that includes `exports:read` (route authorization — true, the worker
needs it for every job), and then nothing. Object-level authorization was never implemented
because the endpoint was written for one trusted machine caller for whom the answer is always
yes; once a non-worker can obtain that role, the role is a skeleton key. The definition is
the sensitive half: a record tells you an export exists, a definition tells you *what it
selects* and *where the output goes*. [`../writeups/K15.2.md`](../writeups/K15.2.md)

### K14.2 — the cause: authorization on the path parameter

The export token above came from `POST /api/token-exchange/fieldkest-export-access` using a
general workload JWT: the exchange authenticated the caller, then minted the audience named
in the URL, returning `subject: system:serviceaccount:fieldlink:svc-fieldlink-export` and
`role/support-export-editor` — a role built for a different consumer. A correct exchange
resolves the caller's service account, consults *its* trust record, rejects audiences not
listed there, and caps the issued role at the caller's own maximum (response shape
reconstructed). [`../writeups/K14.2.md`](../writeups/K14.2.md)

### K25.2 — open case: which tenant record is authoritative

This card was **not solved** at the time of writing, which makes it a clean example of the
tenant-isolation failure mode. Two stores in the same estate disagree about the same export:

```text
export.partition_bindings        (readable by the developer DB role rowan_data)
  EXP-2841 | TEN-ARWC-019  | PART-ARWC-01 | FLK-7.4.2 | rev 6 | is_current = t
  EXP-2841 | TEN-OTHER-001 | PART-ARWC-02 | FLK-7.3.1 | rev 5 | is_current = f
support.customer_migration_history  (retained company-history dump)
  ARWC FieldLink legacy | TEN-ARWC-019 | FLK-6.9.8 -> TEN-ARWC-047 | FLK-7.4.2 | 2026-02-17
support.customer_records
  CUSTREC-047-R6 | TEN-ARWC-047 | FLK-7.4.2 | asset CRR-OG2 | case SUP-2841
```

The local binding table marks the *legacy* tenant current, with the new connector revision
pinned onto it; the authoritative support record says the customer is `TEN-ARWC-047`. The
card's question is an authorization question wearing a data question's clothes: *which
record is allowed to decide who the caller's tenant is?* The published reconcile route
answered with a server-side binding check:

```text
POST /api/reconcile/tenant-package {"tenant":"TEN-ARWC-047","connector_revision":"FLK-7.4.2"}
  -> 422 {"error":"record_binding_mismatch"}      (also for {"record_id":"CUSTREC-047-R6",...})
```

That `422` is evidence of a check, not a bypass: the interface validates a binding the
developer identity is not being shown. The lesson stands without a flag — a tenant key
accepted from the request, validated against a replica, with a mutable `is_current` flag as
the tiebreaker, is tenant isolation implemented as bookkeeping.

## 6. Variations and near misses

- **The check exists but on the wrong key.** `/orders/1/lines/2` checks order 1 and never
  line 2; batch routes check the first id; `?ids=` arrays check the container, not members.
- **Tenant from the header, owner from the token.** `X-Tenant-Id` is accepted and used for
  the query while the session supplies only the user. Changing the header is the whole test.
- **Role confusion, not IDOR.** An `admin` claim trusted from the token or from a
  client-supplied role param; a service token whose subject hides the human (`act`/`obo`
  claim absent). The object may be yours and still be the wrong privilege.
- **Soft 403s that leak existence.** `403` for objects that exist and `404` for ones that
  do not is an enumeration oracle (chapter 01), not an access-control break; report it
  separately. Likewise a `200 {}` for a read that returned no fields is not proof the
  boundary failed.
- **Not a bug: a genuine grant, or sequential ids.** A shared assignment, an explicitly
  delegated record and a public catalogue are intended reads; guessability makes an existing
  bug exploitable but does not create one, and a `403` with a valid session is a working
  control. "I could read it" is not the finding; "I should not have been able to" is.

## 7. How to fix it

- **Authorize the object, in the data layer, on every route.** Prefer a query that cannot
  return the wrong row: `WHERE id = ? AND owner = ?` (or an explicit grant join). A central
  `authorize(subject, action, object)` called by the repository is harder to forget than a
  decorator per handler.
- **Derive tenant, role and audience from the authenticated principal**, never from the path
  or body. If a caller must name a tenant, intersect the named value with the set the
  principal is entitled to.
- **Token exchange:** per-service-account audience allow-list, role capped at the
  intersection with the caller's maximum, short TTL, and an audit event recording caller →
  audience → issued subject.
- **Deny by default and return `404`** for objects the caller may not see, so the response
  does not double as an existence oracle. Test with a second user's session: every object
  route must fail for both ids you do not own.
- **Make one store authoritative for tenant/current state** and have replicas carry a
  revision, not their own `is_current` flag; validate requests against the authority.
- **Log and alert on `object.owner != session.subject`** for replies that returned `200`, and
  on one token reading objects across many `created_by` values. There is no payload to
  signature-match; the log line is the detection.

## 8. Exercises

1. **Build the archetype.** A 40-line Flask app with `/login`, `/notes` (scoped list) and
   `/notes/<id>` (unscoped detail), two users, two notes each. Prove the IDOR with two
   `curl`s, then add the owner predicate and show the second request becomes `404`, not `403`.
2. **Spot the missing comparison.** Given a handler that loads the object, checks
   `if not session: abort(401)` and returns `jsonify(obj)`, write the two lines that fix it.
   Then list every route in a three-route API that needs the same two lines.
3. **Predict the four responses.** A list route is scoped, a detail route is not, ids are
   sequential, unknown ids are `404`. Predict status and body for your own id, a neighbour's
   id, a random id, and a neighbour's id with a trailing `/../`. Say which you would report.
