# What the CTF was made of

## Shape

240 challenges in three categories, plus a small flat network to explore. The
category names are the story:

| Category | Cards | Points available | Character |
|---|---|---|---|
| 1. Training | 16 | 1,000 | four desks, 4 cards each, teaching the mechanics |
| 2. KeplerOps | 104 | ~13,000 | a software company: source, CI, packages, cloud, identity |
| 3. ARWC | 120 | ~18,000 | a water utility: documents, OT/HMI, process data, entitlements |

Each desk/chapter is a numbered chain (`T01.1`, `K07.3`, `W22.4`). Within a
chapter the cards escalate: the first is almost always a 50-point easy
reconnaissance step, the last is 400–800 points of chaining. Chapters are
mostly self-contained, so progress is breadth-first rather than strictly linear.

**Our result: 91/240, 10,700 points.**

## Difficulty and points curve

| Difficulty | Cards | Typical points | Solved by us |
|---|---|---|---|
| easy | 60 | 50 | 42 |
| medium | 94 | 100 | 34 |
| hard | 52 | 200 | 8 |
| expert | 34 | 400–800 | 7 |

Points track difficulty, with an occasional 800-point expert capstone
(`K12.4`, `W23.3`). Because hint penalties are subtracted from the award, a
50-point card answered with two hints pays noticeably less — visible in our own
results (`K02.1` paid 20 instead of 50).

## Scoring and attempt model

- `FLAG{16 hex}` format, submitted per card via `POST /api/v1/ctf/challenges/{id}/submit/`.
- `attempt_limit_mode: lockout` — wrong flags trigger a cooldown (300s), not a
  permanent ban, but guesses burn time and pollute the submission log.
- Hints are priced 10/20/30 and **permanently reduce that card's award**.
- Scoreboard public; live notifications for `challenge_released`, `first_blood`,
  `position_changed`, `range_ready`, `messages`.

## The three acts

### Act 1 — Training (16 cards, all solved)

Four single-purpose Python services on `10.77.40.0/24`, each a tiny web app with a
deliberate flaw:

1. **Workbench** — a handover git repo whose "blank replacement" commit sits on top
   of real history, plus a diagnostics renderer that takes a `view` path and can be
   walked out of its directory.
2. **Accounts** — an identity desk: recovery lookup that answers differently for
   live/dead/unknown handles, a staff-directory API that ignores the UI's visibility
   filter, a recovery flow that issues a session, and an assignment service with no
   object-level authorisation.
3. **Developer artifacts** — a checkout whose deleted fixture lives in history, a
   package whose install hook does more than it advertises, and a formatter you must
   build to the consumer's documented contract.
4. **Outlet desk (SCADA)** — tank observations where the measured volume differs from
   the requested setpoint, a controller status word that must be decoded bit by bit,
   a live practice tank where you must move a bounded quantity and verify it from
   observations, and a report whose "green" result belongs to an earlier attempt.

Act 1 is where the event teaches its own conventions: flags are usually a field in a
JSON response, sealed records are decrypted with a `sha256(...)` passphrase derived
from values you must first get right, and the desk remembers state you change.

### Act 2 — KeplerOps (104 cards, 64 solved)

A fictional software vendor with a real enterprise surface: Gitea, Jenkins, an
isolated report worker, a package registry, object storage, PostgreSQL, Kubernetes,
Keycloak, a step-ca, Kerberos, AnythingLLM and Kanboard. The chapters map onto
functions: source control (K01–K03), packaging (K04–K06), delivery/inspection
(K07–K08), CI runners (K09), previews (K10), policy compiler (K11), review
pipeline (K12), export/handover (K13–K16), support (K17), assistant/AI (K21–K24),
customer onboarding (K25–K27), connectors (K28), supply chain/signing (K29),
backups and maintenance (K30–K31).

The recurring pattern: **a scoped credential plus a service that trusts it too much**.
Workspace tokens exchange for job tokens, service accounts read other tenants'
objects, a support reviewer's delegation can be re-pointed at a different reviewer,
and a certificate whose subject you choose is enough to cross an archive boundary.

### Act 3 — ARWC (120 cards, 11 solved)

The customer side, and the hardest wall in the event. 120 cards for 11 solves —
the only category where we had no expert/hard solves at all. Everything is about an
OT water utility ("Cairn Reach" reservoir, outlets A/B, PLC over OPC UA, a FUXA HMI,
a process historian) that you can only touch after establishing an ARWC-issued
**channel identity** at the connector relay:

```
POST /api/fieldlink/packages/poll              → 403 channel_identity_denied
POST /api/fieldlink/packages/{v}/activate      → 403 channel_identity_denied
GET  /api/fieldlink/packages/{v}/receipt       → 403 channel_identity_denied
POST /api/fieldlink/rehearsals/rollback        → 403 channel_identity_denied
GET|POST /api/fieldlink/diagnostics            → 403 channel_identity_denied
```

Staff certificates, staff Kerberos tickets and KeplerOps service tokens are all
rejected there. The ARWC cards that *were* solvable from the KeplerOps side came
through ordinary documents (handovers, inspections, package metadata) rather than
through the relay — which is the intended lesson, but also why the category's
completion rate stayed in single digits.

## What made it good

- The **client reference documents** (`.well-known/fieldkest-client`) publish every
  route with request bodies. Once found, they replace hours of guessing with reading.
- Chapters are independent, so a team can parallelise hard.
- The story is consistent: the same asset IDs, ticket numbers and revisions recur
  across source, CI, support and documents, so correlation is a real technique
  rather than a lucky string match.
- The ARWC wall is honest about what it is testing: credentials and delegation, not
  exploitation.
