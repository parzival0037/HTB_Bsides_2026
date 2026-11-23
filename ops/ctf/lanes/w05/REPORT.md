# W05 — A starter pack left open / The activation roster / Temporary, with the wrong rights

Lane W05, ARWC chapter (category "3. ARWC"). Workdir `/home/kali/ctf/lanes/w05/`.
Status: **in progress, no W05 flag yet**.

## Assigned
- W05.1 (50p) Recover Mira Vale's exposed starting arrangements → identify the temporary
  account and approved work assignment.
- W05.2 (50p) Find Mira Vale in the activation roster → native identity + approved assignment.
- W05.3 (100p) Complete the temporary employee's first sign-in → directory authority that
  exceeds the approved account scope.

## Access recap (all works from range box)
- SOCKS pivot: `curl -sS --socks5-hostname 127.0.0.1:1080 -k https://<host>`
  (pivot alive; `ssh rowan-dev` from box with `-i ~/.ssh/keplerops-foothold -p 2222
  rowan@10.50.13.180` reaches 10.77.0.0/16 natively — much faster for scans).
- CA: `/home/kali/ctf/ca.crt` (or `-k`).

## Findings so far (W05 not solved; adjacent material found)

### ARWC side is a single host
- `connector.arwc.test` = 10.77.60.20, only ports 22 and 443. DNS: `arwc.test` has no
  zone records; only `connector.arwc.test` resolves (static). 10.77.60.0/24+61–64 scan
  → only 10.77.60.20:443.
- Relay banner `FieldKest-Customer-Relay/1.0` (custom Python http.server family).
  Host-header vhosting tried (hr/staff/identity/portal/onboarding/it/directory/people/
  sso/intranet.arwc.test) — identical behaviour, no vhosts.
- Route enumeration (43k-word raft + curated GET/POST, ~130k requests) found exactly
  these live routes (all others 404 `{"error":"route_not_found"}`):
  - `POST /api/fieldlink/packages/poll`             → 403 `channel_identity_denied`
  - `POST /api/fieldlink/packages/{version}/activate`→ 403 `channel_identity_denied`
  - `GET  /api/fieldlink/packages/{version}/receipt` → 403 `channel_identity_denied`
  - `POST /api/fieldlink/rehearsals/rollback`        → 403
  - `GET|POST /api/fieldlink/diagnostics`            → 403 `channel_identity_denied`
  No onboarding/HR/staff/roster/starter route exists on the relay (tried many).
  The relay needs a "channel identity" (mTLS client cert or ARWC account token).

### KeplerOps services (all reached through pivot)
- `identity.keplerops.test` / `id.keplerops.test` → **Keycloak** (admin console at
  `/admin/`, realm **`keplerops`**; realms master+keplerops exist, no arwc/fieldkest realm).
  `/realms/keplerops/.well-known/openid-configuration` 200. Password grant with
  `client_id=admin-cli` works for `rowan.ito` / `fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo`
  (from other lanes' notes; token has only profile/email, no admin roles).
- `staff.keplerops.test` = "directory / note / archive / delegation / managed-identity" API.
  Auth: Bearer or Basic `rowan.ito:fk_developer_...` works.
  `GET /api/service-directory` →
  `{"archive_subject":"evan.calderoux@keplerops.test",
    "enrollment":"https://staff.keplerops.test/api/enrollment/StaffArchiveUser",
    "enrollment_worker":"fk_cert_enrollment_Um9U1sNZQ5b_Cb08iirD4H-BKfz8aMF9",
    "restricted_note":"NOTE-SUP-2841-7","support_registration":"OIDC-FIELDKEST-SUPPORT"}`
  `GET /api/notes/NOTE-SUP-2841-7` → restricted note + `FLAG{3177559b5e2a80d8}` (belongs to
  another card — K chapter staff-note; NOT submitted).
  `GET /api/enrollment/StaffArchiveUser` → `{"eku":"clientAuth",
    "provisioner":"fieldkest-enrollment","subject_format":"{subject}"}`.
  `GET /api/archive/handovers/{subject}` → 401 `client_cert_required`.
  `POST /api/managed-identities/{svc}/session` → Negotiate (Kerberos) required.
- `support.keplerops.test` osTicket works: staff login **maya.ranscombe /
  sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk** (worked with CSRF token
  `__CSRFToken__`, `do=signin`). Tickets: SUP-2841, SUP-2819, SUP-2834, SUP-2850, ESC-2841
  — no "Mira Vale"/starter/onboarding ticket.
- `support.keplerops.test:8443` (FieldKest support client, Bearer
  `fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b`):
  `GET /api/handovers/current` → `FLAG{12791115ad005ed7}` (already K02.3 — do not submit).
  Only `/api/handovers/current` exists; everything else 404.
- `workboard.keplerops.test` = **Kanboard**. Login `maya.ranscombe / sWQa31085...
  (POST /login/check, csrf_token)`. Boards: project 1 (Kanboard "KB" board), user id 3.
  Search for "Vale"/"starter"/onboarding returned "Nothing found".
- `objects.keplerops.test` S3: **anonymous listing of bucket `fieldkest-workspaces`**
  (`GET /fieldkest-workspaces?list-type=2`). Exactly two objects (publicly readable):
  - `exports/EXP-2841/handover.json` → `workspace_token: FLAG{adfbabdcdaca98ac}`
    (schema fieldkest.workspace-handover/v1, owner maya.ranscombe, job SCHED-2841)
  - `notebooks/deploy-2026-09.json` → `workspace_token: FLAG{6bb66074f2325405}`
    (fieldkest.workspace-notebook/v1)
  These are almost certainly other cards' flags (K13/K15 workspace token exchange);
  NOT submitted by this lane. Bucket `fieldlink-exports` not listable.
- Gitea `source.keplerops.test`: Basic auth `rowan.ito:fk_developer_...` works
  (`Authorization: token` header now 401). Only 4 private repos: fieldkest/connector-archive,
  fieldlink-connector, policy-compiler, release-signer-history — no onboarding/ARWC repo.
- npm `packages.keplerops.test`: search for arwc/starter/onboard returns 0 packages.
- Postgres (from rowan-dev, `psql service=fieldlink`) accessible DB = `fieldlink_data`
  with only: `export.partition_bindings`, `support.customer_migration_history`,
  `support.customer_records`. Server also hosts `fieldlink_identity` and
  `fieldlink_staff` DBs but rowan_data is denied there (pg_hba).
- Kubernetes: rowan SA `system:serviceaccount:fieldlink:rowan-workspace` cannot list
  cluster-wide resources (forbidden).

## Working hypothesis
W05 is an identity/onboarding chain and the most likely home is the Keycloak realm
`keplerops` (+ possibly staff enrollment / cert services), not the relay:
- starter pack = exposed onboarding doc with temp Keycloak account + assignment
- activation roster = Keycloak user list / enrollment roster containing Mira Vale
- first sign-in = Keycloak login with the temp credential
- directory authority = an admin/realm-management role that the temp account holds
Not yet located the "starter pack" document. Candidate remaining places:
`cert.keplerops.test`, `ca.keplerops.test`, Keycloak admin REST (needs admin creds),
indexer/preview/workload services, Kanboard project 1 task attachments (not searched
fully), npm private packages (auth), osTicket users/orgs.

## Dead ends
- Relay route brute force (only the 5 fieldlink routes above).
- connector vhost / DNS AXFR / ARWC subnet sweep (single host only).
- osTicket ticket search for Vale/starter (no such ticket).
- Kanboard search for Vale/starter (nothing).
- Gitea/npm for an ARWC onboarding repo/package.
- staff enrollment template guessing (only StaffArchiveUser exists).

## Flags submitted by this lane
(none yet)
