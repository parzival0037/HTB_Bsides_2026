# K08 — FieldKest legacy entitlements

## Flags
- K08.1 recovered by running the archived FLK 6.9.8 connector's signed diagnostic
  loader: `FLAG{f7802e39cb9fd438}`. See exact command/output in `notes.md`.
- K08.2: unresolved.
- K08.3: unresolved.

## Services / endpoints
- Gitea `https://source.keplerops.test`: `fieldkest/connector-archive` holds
  `bin/fieldlink-connector`, its map, signed configs and
  `ENT-ARWC-DIAG-0698.json`.
- Delivery `https://delivery.keplerops.test:8443` (Basic
  `rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo`):
  - `GET /api/compatibility/entitlements/ENT-ARWC-DIAG-0698` returns protected record.
  - `POST /api/compatibility/entitlements/check` accepts `{checker,record,context}`;
    invalid inputs return `entitlement_validation_failed`.
  - `GET /api/releases/{release_id}` exists; IDs tested so far returned 404.
  - `GET /api/package-meta/fieldlink-connector` exposes npm metadata; 6.9.8 points
    to maintenance record `MTN-6.9.8`.
- Cloud API `https://cloud-api.keplerops.test`: build/role token exchange flow
  documented in `notes.md` (not yet useful to K08).

## Techniques that worked
- Reverse-engineered embedded FKDG module. Key is HKDF-SHA256 over raw GNU build ID,
  salt `fieldkest-fkdiag-v1`, info `fieldlink-connector/6.9.8`; AAD is build-ID hex.
  Decryption yields route `/internal/fieldlink/legacy-diagnostics/CRR-OG2` and note
  `ENG-FLK-LEGACY-42`. Running diagnostic config emits the K08.1 flag.
- Retrieved same protected AES-256-GCM entitlement record from Gitea and delivery.

## Dead ends / cautions
- Large set of obvious direct SHA-256/HKDF-SHA256 key derivations and AAD variants did
  not decrypt `ENT-ARWC-DIAG-0698`; the true derivation context must be recovered.
- `~/work/registry/k08-{2,3}-entitlement.enc` are nested-base64 OpenSSL `Salted__`
  ciphertexts. Obvious password/KDF attempts failed; do not submit decrypted-looking
  garbage. Exact decoded bytes are in `notes.md`.
- Delivery role JWT from `release-reader` exchange is rejected; use Basic developer
  credentials for delivery endpoints.
- No hints unlocked. No flag was submitted before this report was written.

See `notes.md` for exact ciphertexts, commands, derivation details and next steps.
