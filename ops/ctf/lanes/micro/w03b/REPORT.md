# W03.2 micro lane — BLOCKED (no accepted flag)

Worked only W03.2. Not solved. 3 submissions made, all rejected.

## What is proven (literal responses)

Support client contract (`GET support:8443/.well-known/fieldkest-client`) has exactly:
`handover.current`, `diagnostics.create` (POST /api/customers/{tenant}/diagnostics
`{"connector_revision":...}`), `diagnostics.read`, `diagnostics.package` (PUT
`expected_output/interface/source`), `diagnostics.deliver` (POST).

Only `FLK-7.4.2` binds for TEN-ARWC-047 (`FLK-6.9.8`, `FLK-7.4.0/1/3*`,
`REL-FLK-6.9.8-ARCHIVE` → `409 connector_binding_denied`).

Flags literally returned by this flow:
- `POST /api/customers/TEN-ARWC-047/diagnostics` (`FLK-7.4.2`) →
  `FLAG{d58c860051957082}` (job draft; also on every GET of the job)
- `PUT /api/diagnostics/{job}/package` (any self-consistent source) →
  `FLAG{f77bdbb3436a8bab}` (state packaged)
- `POST /api/diagnostics/{job}/deliver` →
  `FLAG{8e5eb57412212e11}` + receipt `fieldlink.diagnostic-receipt/v1`,
  account “Alterra Regional Water Company”, maintenance_case `MTN-CRR-204`,
  runtime_identity `svc-arwc-fieldlink`, maintenance_access SSH key
  user `fieldlink` @ `connector.arwc.test`.

Package-meta (`GET delivery:8443/api/package-meta/fieldlink-connector`, Basic
rowan.ito): latest 7.4.2, legacy 6.9.8, next **7.4.3-cinder.rset1** (created
*before* 6.9.8 → the “reference outside the order”), 6.9.8 deprecated field has
`FLAG{870a03c573511895}` (retained for maintained installations).

## Inspection route (found late; this is where W03.1 came from)

`POST delivery:8443/api/inspections` with the exact body
`{"action":"inspect_public_manifest","package":"@keplerops/fieldlink-connector",
"request_id":"release-742","schema":"fieldkest.inspection/v1","version":"7.4.2"}`
returns `INSP-2047`; `GET /api/inspections/INSP-2047/trace` returns
`assessor_correlation_id PAS-884`, `compatibility_envelope_sha256 543a002d…`,
`normalized_request_id release-742`, `version 7.4.2`.
- At 19:59Z the trace flag was `FLAG{65b50adb2fe75762}` — almost certainly W03.1
  (it was solved at 21:49 and this is the only inspection-trace flag seen).
- After the diagnostics deliver (22:16Z) the SAME trace returned
  `FLAG{7365629ef50739be}` — submitted for W03.2, rejected.
Only version 7.4.2/request_id release-742 passes the contract; all other
versions and release-743 → `422 inspection_contract_failed`.

## Submissions (all wrong)

| flag | origin | result |
|---|---|---|
| FLAG{8e5eb57412212e11} | diagnostics deliver receipt | incorrect |
| FLAG{f77bdbb3436a8bab} | diagnostics package PUT | incorrect |
| FLAG{7365629ef50739be} | INSP-2047 trace after deliver | incorrect |

Also unattributed/rejected elsewhere (do not resubmit blindly):
`d58c860051957082` (diagnostics create), `870a03c573511895` (package legacy field).

## Best remaining leads for W03.2

1. The maintenance_access SSH key from the deliver receipt (`fieldlink` @
   `connector.arwc.test`) — likely the channel identity / account where the
   “engineering document that reached the supplier account” actually lives.
   The same deliver JSON is fully re-readable via
   `GET /api/diagnostics/DIAG-ARWC-A5E595D5` (state delivered).
2. `POST /api/inspections/envelope` (`application/octet-stream`) with the
   7.4.2 compatibility envelope (`inspection-compat.fki` on rowan-dev) — the
   `compatibility_envelope_sha256` in the trace is the reconciling reference.
3. Private npm package `@keplerops/support-rehearsal` (`packages:443`,
   `GET /@keplerops%2fsupport-rehearsal`) is 403 for rowan; delivery lists
   `packages.private-metadata` for it — needs a different identity.
4. `GET delivery:8443/api/releases/REL-FLK-6.9.8-ARCHIVE` gives the legacy
   entitlement context (record `ENT-ARWC-DIAG-0698`, tenant TEN-ARWC-019);
   no flag in it.

Do NOT keep submitting candidates: W03.2 already has ~17 attempts.
