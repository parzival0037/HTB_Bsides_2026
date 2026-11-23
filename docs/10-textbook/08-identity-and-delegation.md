# 08 — Identity and delegation: who is acting for whom

Every modern token answers four questions at once: **who** (`sub`), **who vouches** (`iss`),
**who may accept it** (`aud`), and **for how long** (`exp`). Kerberos splits the same idea
across two tickets: a TGT for the realm's ticket-granting service, and a service ticket bound
to one SPN (`HTTP/host@REALM`). A credential cache (`ccache`) holds both. Delegation is the
act of a service obtaining a ticket *on a user's behalf* so it can call a second service as
that user.

## 1. What this class of bug is

Precisely: a delegated credential is an **authorisation decision, materialised as a bearer
token**. The decision has inputs — caller, subject, target service, scope, lifetime — and the
token records only some of them. Bugs appear when the decision is made on the wrong input
(the audience string in the URL, any SPN the caller names) or when the materialised token is
handed back to the requester instead of being used in-process. A token that leaves the service
that minted it is no longer a decision; it is a transferable credential.

## 2. Why it exists

The root assumption is: **"if the token verifies, the bearer is entitled to what it asks
for."** Verification proves integrity and origin. It says nothing about whether *this* caller
should receive *that* audience, subject, or object. Four variants recur:

- **Audience treated as a routing label.** A token exchange reads the requested audience from
  the path (`/token-exchange/<audience>`) and mints the corresponding role for any valid
  caller. The developer's mental model is "the URL selects which service to talk to". In OIDC
  terms, `aud` is a *restriction* the resource server must enforce, not a menu.
- **Delegation treated as internal plumbing.** A service that can request tickets for users
  assumes the ticket never leaves the process. Returning `ccache_base64` in JSON turns a
  server-side act into a portable credential: replayable, copyable, and valid until expiry.
- **"The worker is the only caller."** Object-level checks (`job.owner == caller`) are omitted
  from machine-to-machine APIs because the only expected caller is the worker, which owns
  everything by definition. As soon as a human can obtain that audience, the missing check is
  the vulnerability.
- **"Constrained delegation is safe."** An SPN allow-list limits *which* target a service may
  reach. It does not limit *whose* authority is used, or who ends up holding the ticket. A
  constrained delegation endpoint that returns the ticket is still a ticket factory for every
  SPN on the list.

Kerberos makes the last point concrete. `S4U2Self` lets a service obtain a ticket to *itself*
on the user's behalf; `S4U2Proxy` lets it forward that to an allow-listed target; unconstrained
delegation lets it request any SPN. These are three different amounts of authority, and the
response shape — a ccache — is identical in all three.

## 3. How to spot it

- `WWW-Authenticate: Negotiate`, `--negotiate`, `SPNEGO`, or a `401` that a browser silently
  satisfies. That is Kerberos, and there is a realm behind it.
- SPN strings in docs, configs, or error bodies: `HTTP/staff.example.test@EXAMPLE.TEST`. The
  service name, host and realm are all authorisation-relevant.
- Endpoint families: `/delegation/probe`, `/impersonate`, `/token-exchange/{audience}`,
  `/act-as`, `/s4u`, `/on-behalf-of`. A route that takes an identity as a parameter is a
  delegation surface.
- Response fields: `ccache_base64`, `ticket`, `credentials`, `access_token`, `subject`,
  `role`, `audience`, `role_record`, `expires_in`. A credential in a JSON body is a finding
  even when the endpoint is "read-only".
- JWTs: three base64url segments. Decode the middle one; look at `aud`, `iss`, `sub`, `exp`,
  `scope`, `roles`, and `act` (the actor chain). A token whose `aud` is a service other than
  the one you are calling is being passed through.
- A `role-<audience>` ConfigMap, a `trust-<workload>` object, or a client reference that maps
  audience → role → service account. That document is the delegation graph in plain text.
- Error strings that reveal the boundary: `ticket_request_failed` (no such SPN / not allowed),
  `k3s_rbac_denied` (authenticated, not authorised), `channel_identity_denied` (wrong issuer
  domain). Each tells you which layer said no.
- Sequential ids (`EXP-2841`, `SCHED-2841`) next to an audience-scoped API: route authz will
  pass, so the only remaining question is object ownership.

## 4. How to test it

Decode before you request. Most of the model is visible offline.

```bash
# What does this JWT claim, and for whom?
cut -d. -f2 token.jwt | tr '_-' '/+' | base64 -d 2>/dev/null | jq .
# aud, iss, sub, exp, act, scope -> write them down before making any request.

# What is in my Kerberos cache?
klist -e
KRB5CCNAME=FILE:/tmp/test.ccache klist      # inspect a cache without touching the default
```

Then test one axis at a time:

```bash
# 1. Call the exchange for the audience you are documented to use.
curl -sS -X POST -H "Authorization: Bearer $SA_JWT" \
  https://cloud-api.example.test/api/token-exchange/my-service | jq '{sub,aud,role,exp}'

# 2. Call it once for a sibling audience named in the client reference.
curl -sS -X POST -H "Authorization: Bearer $SA_JWT" \
  https://cloud-api.example.test/api/token-exchange/other-service | jq '{sub,aud,role}'
```

If step 2 returns a token whose `sub` is a service account that is not yours, the exchange
authorises on the path. That is the bug, and the response body is the proof. Do not spray
audiences: one sibling request is enough to establish the pattern, and each exchange is logged.

```bash
# 3. Use the token where it should not reach, once.
curl -sS -H "Authorization: Bearer $OTHER_JWT" \
  https://cloud-api.example.test/api/exports/EXP-0001 | jq '{state,created_by}'
# 200 + someone else's record = missing object-level authz. 403 = the control works.

# 4. Kerberos: ask for the documented SPN, then one target outside the list.
curl -sS --cert me.crt --key me.key -H 'Content-Type: application/json' \
  -d '{"spn":"HTTP/staff.example.test@EXAMPLE.TEST"}' \
  https://staff.example.test/api/delegation/probe | jq 'keys'
```

`{"ccache_base64": ...}` means the server materialised the delegation and handed it over.
Decode to a file with mode `600`, run `klist`, then `kdestroy` or delete it. A ccache is a
live bearer credential: never paste it into a ticket, a chat, or a shared shell history, and
never present it to a host outside the engagement scope.

## 5. Case study from this range

**K19.3 — the probe that returns the ticket.** K19.1's enrollment endpoint mints a
`clientAuth` certificate for any `@keplerops.test` UPN. That certificate buys exactly one
thing at the archive: an authenticated subject. The delegation probe converts it into a
Kerberos identity:

```bash
curl -sS -k --cert subject.crt --key subject.key \
  -H 'Content-Type: application/json' \
  -d '{"spn":"HTTP/staff.keplerops.test@KEPLEROPS.TEST"}' \
  https://staff.keplerops.test/api/archive/delegation/probe
```

The response carries `spn`, `ccache_base64`, and a flag. Materialising it is ordinary
Kerberos tooling:

```bash
jq -r .ccache_base64 probe.json | base64 -d > /tmp/subject.ccache
KRB5CCNAME=FILE:/tmp/subject.ccache klist
# principal <subject>@KEPLEROPS.TEST
# krbtgt/KEPLEROPS.TEST
# HTTP/staff.keplerops.test@KEPLEROPS.TEST
```

That is a TGT plus one service ticket — a delegated authentication context for the staff
service. The boundary is equally instructive: asking for `HTTP/connector.arwc.test`,
`HTTP/cloud-api.keplerops.test`, or `HTTP/workloads.keplerops.test` returns
`{"error":"ticket_request_failed"}`. Only the staff SPN exists, so the realm has an allow-list.
Presenting the ccache with `--negotiate` to the customer-side connector returns
`403 channel_identity_denied`: the ARWC ingress wants a customer-issued channel identity, not
a KeplerOps staff principal.

So delegation was *constrained* and still produced a transferable credential. The bug is not
"any SPN"; it is that the service used its own realm identity to request a ticket for the
caller and then serialised the result. A correct delegation endpoint uses the ticket
in-process and returns only the outcome. See [K19.3](../writeups/K19.3.md).

**K13.4 → K14.2 → K15.1 — audience is not ownership.** A workspace token is exchanged at
`POST /api/workspaces/current/token-exchange` for a Kubernetes service-account token
(`svc-fieldlink-workload` in the [K13.4](../writeups/K13.4.md) evidence; that write-up's
request bodies are reconstructed). A second exchange route ([K14.2](../writeups/K14.2.md))
takes the audience in the path:

```bash
curl -sS -X POST -H "Authorization: Bearer ${SA_JWT}" \
  https://cloud-api.keplerops.test/api/token-exchange/fieldkest-export-access
```

The response names a different consumer's identity — `subject:
system:serviceaccount:fieldlink:svc-fieldlink-export`, `role:
role/support-export-editor`, `audience: fieldkest-export-access` — and a working `token`.
[K14.2](../writeups/K14.2.md)'s response shape is reconstructed; the identity triple and the
route are recorded. The
enabling document is a ConfigMap, `fieldlink/role-export-access`, mapping audience → role →
service account: the delegation graph readable by the workload it describes.

That token then reads a job it did not create:

```bash
curl -sS -H "Authorization: Bearer ${EXPORT_JWT}" \
  https://cloud-api.keplerops.test/api/exports/EXP-2841 | jq
```

`EXP-2841` belongs to a support principal working case `SUP-2841`; the record is returned
with `state: "in progress"` and a flag (`FLAG{6b4342f2b090f8d2}` is lane-recorded). The
dataset and revision values were not preserved, so do not invent them. The scope is real,
too: `/api/exports/EXP-2841/runs` answers `k3s_rbac_denied`, and the definition route is
[K15.2](../writeups/K15.2.md) (object-level IDOR, covered in chapter 02). Route authz passed
because the role is co-extensive with the export worker; object authz never existed because
the worker was assumed to be the only caller. See [K15.1](../writeups/K15.1.md).

## 6. Variations and near-misses

- **Unconstrained vs constrained vs RBCD.** Unconstrained: any SPN. Constrained
  (`S4U2Self` + `S4U2Proxy`): an allow-list. RBCD: one target plus an explicit ACL. The
  response can look identical; the severity differs by *whose* authority and *which* target.
- **Missing `act` claim.** RFC 8693 distinguishes impersonation from delegation with an actor
  chain. Without `act`, the downstream service cannot tell "the user called me" from "a
  service is calling me for the user", so audit and policy both lie.
- **Token passthrough / confused deputy.** Service A accepts a token minted for service B and
  forwards it. The resource server sees a valid `aud` for itself, but the caller was never
  authorised for the operation.
- **Audience arrays and wildcards.** `aud` may be a list; `"aud": "*"` or an unvalidated `aud`
  is the same bug in a different field. Always check membership, not presence.
- **Downscoping that upscopes.** An exchange advertised as "narrow this token" returns a role
  with *more* rights than the caller had, because it copies the target role instead of
  intersecting it with the caller's maximum.
- **A service-account token used as an app token.** Kubernetes SA JWTs carry
  `aud: https://kubernetes.default.svc`; an application that accepts them without checking
  `aud` accepts cluster credentials.
- **Not the bug:** a ccache used server-side and never returned; an exchange that returns a
  token whose `sub` is the caller and whose rights are a subset of the caller's; a
  `403 k3s_rbac_denied`; an expired token rejected. Those are controls doing their job.
- **Not the same bug:** `alg: none` or signature confusion is a token-*verification* flaw.
  It belongs to chapter 07's family, and the fix is signature policy, not delegation policy.

## 7. How to fix it

- **Resolve authority from the caller, not the request.** The exchange looks up the caller's
  service account, reads its allowed audiences from its trust record, rejects anything not
  listed, and caps the issued role at the intersection with the caller's own maximum.
- **Never return a ticket or ccache.** Use it in-process, against an SPN allow-list, and
  return the result. If downstream needs the user's identity, send a signed assertion with an
  `act`/`obo` claim, not a replayable cache.
- **Enforce `aud` and `iss` at every resource server**, then do object-level authorisation:
  `job.owner == sub` or an explicit grant. Route-level roles are not object-level permissions.
- **Disable unconstrained delegation** where it is not required; clear
  `TRUSTED_TO_AUTH_FOR_DELEGATION`; prefer short-lived, audience-bound tokens and rotate on
  any suspicion of disclosure.
- **Keep the delegation graph out of readable config.** Audience → role → service-account
  mappings belong in the control plane, not in a ConfigMap the federated workload can read.
- **Log the whole chain**: caller subject → requested audience → issued subject → resource
  access, with the `act` chain. One exchange followed by cross-owner reads is the signal.

## 8. Exercises

1. **Build a toy exchange.** Two Flask services with HMAC JWTs. `/exchange/<aud>` signs a
   token for whatever audience is in the path, using the caller's `sub`. Show that a token
   for service A reads service B's private record. Then add an audience allow-list, an `act`
   claim, and an `owner == sub` check; show each request failing for the right reason.
2. **Decode and reason.** Given a payload `{"iss":"https://id.example.test","sub":"svc-a",
   "aud":["https://api.example.test","fieldkest-export-access"],"role":
   "support-export-editor","exp":1790000000}`, answer: who is the caller, which services may
   accept it, what can it reach that `svc-a` should not, and what single claim would make the
   delegation auditable. Then name two checks the resource server must still perform.
3. **Kerberos and audience boundaries.** You hold a ccache with `krbtgt/EXAMPLE.TEST` and
   `HTTP/staff.example.test`. List three things it lets you do and two it does not; explain
   why `ticket_request_failed` for a second SPN is an allow-list working while returning the
   ccache was still the vulnerability. Then predict what an export-audience token with
   `role/support-export-editor` returns from `/api/exports/EXP-2841` and from
   `/api/exports/EXP-2841/runs`, and why the two differ.
