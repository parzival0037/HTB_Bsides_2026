# ARWC ingress — what is proven, what is dead (2026-11-20 20:57Z)

## Proven working: staff client certificates (this unlocked K19.1/2/3)

```bash
# enroll any @keplerops.test identity; response contains certificate_pem AND private_key_pem
curl -sS -k -X POST \
  -H 'Authorization: Bearer fk_cert_enrollment_Um9U1sNZQ5b_Cb08iirD4H-BKfz8aMF9' \
  -H 'Content-Type: application/json' \
  -d '{"upn":"evan.calderoux@keplerops.test"}' \
  https://staff.keplerops.test/api/enrollment/StaffArchiveUser/requests
```
- Non-`@keplerops.test` subjects → `422 {"error":"invalid_upn"}`.
- Response also carries a `flag` — that is **K19.1** (`FLAG{d4fd346be0ffce16}`) — and the same
  flag comes back for every UPN, so do not resubmit it per identity.
- Use the cert as mTLS: `curl --cacert ca.crt --cert X.crt --key X.key`.
  * `GET /api/archive/handovers/<upn>` → evan.calderoux returns the archive record with
    **K19.2** flag; maya/talia → `handover_not_found`.
  * `POST /api/archive/delegation/probe` with `{"spn":"HTTP/staff.keplerops.test@KEPLEROPS.TEST"}`
    returns a base64 **Kerberos ccache** + **K19.3** flag. Decode to a file, use
    `KRB5CCNAME=FILE:/tmp/evan.ccache klist` — it holds a service ticket for staff only.

## Dead ends (do not repeat)
- `connector.arwc.test` (10.77.60.20) rejects **everything** without a channel identity:
  staff mTLS certs (evan/maya) → `403 channel_identity_denied`;
  SPNEGO with the delegated ccache → `403 channel_identity_denied`.
- Only these relay routes exist: `POST /api/fieldlink/packages/poll`,
  `POST /api/fieldlink/packages/{version}/activate`,
  `GET /api/fieldlink/packages/{version}/receipt`,
  `POST /api/fieldlink/rehearsals/rollback`, `GET|POST /api/fieldlink/diagnostics`
  — all 403 without the channel identity.
- Kerberos tickets exist **only** for `HTTP/staff.keplerops.test`; asking the delegation
  probe for `HTTP/connector.arwc.test`, `HTTP/cloud-api.keplerops.test`,
  `HTTP/workloads.keplerops.test` → `{"error":"ticket_request_failed"}`.
- ARWC has exactly one reachable host (10.77.60.20:22,443). No other 10.77.60–70 hosts.
- `psql service=fieldlink` (rowan_data) can only read `export.partition_bindings`;
  `support.customer_records` and `support.customer_migration_history` are
  `permission denied for schema support` (owned by fieldlink_admin / fieldlink_data_owner).

## Still the most promising leads
1. `fieldlink-admin`-owned data: find a credential for `fieldlink_admin` or
   `fieldlink_data_owner` (k8s secret? Gitea? Jenkins credential store?).
2. The relay's channel identity is probably an **ARWC-issued** certificate/token, not a
   KeplerOps staff identity — look in the customer handover / support attachments.
3. `cert.keplerops.test` exposes only `/health`; `ca.keplerops.test` is the step-ca
   (health 200). The enrollment token is **not** a step JWS, so `step ca certificate
   --token` fails; the staff `/requests` endpoint is the intended path.

## UPDATE — the working ARWC ingress is NOT the relay (proven by W01/W02/W03 flags)

Use these instead of banging on `connector.arwc.test`:

- `https://delivery.keplerops.test:8443/api/inspections`
- `https://delivery.keplerops.test:8443/api/package-meta/fieldlink-connector`
- `https://support.keplerops.test:8443/api/handovers/current`
- `https://support.keplerops.test:8443/api/customers/{tenant}/diagnostics`
- `https://support.keplerops.test:8443/api/diagnostics/{job}`
- `https://support.keplerops.test:8443/api/diagnostics/{job}/package`
- `https://support.keplerops.test:8443/api/diagnostics/{job}/deliver`
- `https://cloud-api.keplerops.test/api/workspaces/current/token-exchange`
- `https://cloud-api.keplerops.test/api/schedules/{schedule_id}`
- `https://indexer.keplerops.test/.well-known/fieldkest-client`
- `https://cloud-api.keplerops.test/.well-known/fieldkest-client`
- npm scope `@keplerops/support-rehearsal` on `packages.keplerops.test`

Bearer for the support client: `fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b`.
Tenants seen: `TEN-ARWC-047` (CRR-OG2), `TEN-RILL-022` (RILL-PUMP-442).
W01 flags came from the retained customer handover route; W02/W03 from inspections/package-meta.

## COMPLETE ROUTE MAP (from the .well-known client references — use these paths)

delivery.keplerops.test:8443  (FieldLink inspection/, entitlement, release, delivery)
  GET  /api/package-meta/fieldlink-connector        -> pending_release 7.4.3-cinder.rset1;
                                                       channels.arwc-stable.rollback_slot 7.4.2
  PUT  /api/packages/@keplerops%2ffieldlink-connector
  GET  /api/releases/{release_id}
  POST /api/releases/{release_id}/approval
  POST /api/inspections                             (and /api/inspections/{id}/trace, /envelope)
  POST /api/consumer-checks
  POST /api/reconcile/tenant-package
  POST /api/compatibility/entitlements/check
support.keplerops.test:8443
  GET  /api/handovers/current
  POST /api/customers/{tenant}/diagnostics          (body: connector_revision)
  GET  /api/diagnostics/{job}
  PUT  /api/diagnostics/{job}/package               (body: interface fieldkest.connector/v3,
                                                      source = CommonJS exporting diagnostic_summary,
                                                      expected_output = exact return value)
  POST /api/diagnostics/{job}/deliver
review.keplerops.test  POST /api/jobs, GET /api/jobs/{job}, POST /api/rehearsals/connector,
                       GET /api/runs/{run_id}[/log|/artifacts/{name}], POST /api/review-jobs
source-tools.keplerops.test:8443  POST /api/policy-compilers/fieldkest-policyc/{evaluations,nonces},
                       POST /api/exercises/connector-archive/run
