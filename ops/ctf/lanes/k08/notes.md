# K08 running notes

## Current state
- K08.1 candidate is certain from the archived connector's successful diagnostic run:
  `FLAG{f7802e39cb9fd438}`. Output also identifies route
  `/internal/fieldlink/legacy-diagnostics/CRR-OG2` and note `ENG-FLK-LEGACY-42`.
- K08.2 / K08.3 unresolved. Delivery endpoint is identified and record was retrieved.
- No hints unlocked. No flags submitted yet at time this note was first written.

## Source artifacts
Gitea creds (also accepted by delivery):
`rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo`.

Repos visible:
- `fieldkest/connector-archive`
- `fieldkest/fieldlink-connector`
- `fieldkest/policy-compiler`
- `fieldkest/release-signer-history`

`connector-archive` contains:
- `bin/fieldlink-connector` FLK 6.9.8 ELF x86-64, unstripped.
- GNU build-ID raw bytes: `698d42c6a1776e9fc002b91ef68431ad775e0c28`.
- `maps/fieldlink-connector-6.9.8.map`.
- `config/diagnostic.conf`, `config/ordinary.conf`.
- `internal/fieldlink/legacy-diagnostics/CRR-OG2/ENT-ARWC-DIAG-0698.json`.
- `notes/retained-diagnostic.md`.

Binary copied on range box to `/var/tmp/fc` and run:
```
cd /tmp/k08
/var/tmp/fc --config config/diagnostic.conf --input examples/fieldkest.bin
```
Output:
```
{"flag":"FLAG{f7802e39cb9fd438}","interface":"fieldkest.connector/v2","mode":"diagnostic","route":"/internal/fieldlink/legacy-diagnostics/CRR-OG2","note_id":"ENG-FLK-LEGACY-42","output_sha256":"cbc033367122b892508cfe0a23cf5abf1432adf1c0845151f400e1106fcfd8cd"}
```
`/tmp` on range box is noexec; `/var/tmp` works.

Config signature scheme from disassembly:
HMAC-SHA256 with 32-byte key at rodata 0xd84c0
`dc560f9ef65a1ea203255f0ddd2a9211cc2a2c1464326ed80a0c77a1d970324d`
over `diagnostic-loader=true`; signature
`beb32390dc01c529e0cd656b935c9f62c9156d098e0ce6e0aad27f011f8e4a5a`.

Embedded FKDG layout:
- magic `FKDG`
- nonce `FKDG-698-v1!`
- BE u32 length 73, ciphertext, 16-byte GCM tag
- key = HKDF-SHA256(IKM raw 20-byte build ID,
  salt `fieldkest-fkdiag-v1`, info `fieldlink-connector/6.9.8`, L=32)
- AAD = **build-ID hex**, not config signature (tested successfully).
Decrypted bytecode:
`01 5a 02 03 03 04 ./internal/fieldlink/legacy-diagnostics/CRR-OG2 04 11 ENG-FLK-LEGACY-42 ff`.

## Entitlement record (retrieved from both Gitea and delivery)
Delivery:
`GET https://delivery.keplerops.test:8443/api/compatibility/entitlements/ENT-ARWC-DIAG-0698`
Basic auth as above. Record:
```json
{
  "cipher":"AES-256-GCM",
  "ciphertext_base64":"UcSjQere8JW9BEDZrwUan4XW4jRW/k36mPtLIUVSrcp6HBVy1QILC3I/73YYxMIR6Ixs8RpRSI7otvX1Cr02gdTJuiOPlde91Y5U8dnkPpiKR3XwbPGf16SbDOCPKwkbV95r0QloWKWgRxxtHzsQahtNbsr8Op3f7BCImM2mz927WlefwSSuGbqOZdSHrIbOQn+zfNAz8uaxSQYLHjrF3IFC/ctkw/nSLwKnWeoUJYNg6aCNLmRGBrAECSeN8ZhGB8KtYeI0O6NFL2GjA4qfTUGL/mTfYDnbkKf1vqsXEozT8NtAdiqz5L7XzONz2rBLyspyfeb/71i8sVtt/5hP59mK6tlBDDlq0gHGeUA=",
  "customer_id":"TEN-ARWC-019",
  "feature_id":"diagnostic-loader",
  "grammar":"fieldkest-entitlement/v1 canonical JSON; UTF-8 NFC strings; lexicographically sorted keys",
  "key_id":"fk-entitlement-legacy-2026-08",
  "nonce_hex":"454e542d303639382d563121",
  "package_revision":"FLK-6.9.8",
  "record_id":"ENT-ARWC-DIAG-0698",
  "revision":4,
  "schema":"fieldkest.entitlement-record/v1",
  "tag_base64":"IUvC8saIDcdgH/ACOtSrMQ=="
}
```
Nonce bytes = `ENT-0698-V1!`; ciphertext length 269, tag length 16.
Check endpoint: `POST /api/compatibility/entitlements/check`, fields
`checker`, `record`, `context`. Untested/malformed always returns HTTP 422
`{"error":"entitlement_validation_failed"}`.

## Workstation `.enc` files
On rowan-dev `~/work/registry/`:
- `k08-2-entitlement.enc`
- `k08-3-entitlement.enc`
These are base64(base64(OpenSSL `Salted__` AES-CBC-looking data)).
Decoded bytes:
- k08-2: `53616c7465645f5fa7797a9041b6f96949719ededd84e9897290305fcea4394e02b79b0e7df689fd04f3e1643c802da9`
  salt `a7797a9041b6f969`, 32 ciphertext bytes (likely two 16-byte flag padded blocks).
- k08-3: `53616c7465645f5f1613e22314be840151f20a584fc0260992de4f8964e0a977081a420ace502ea3b692502bbc47006a`
  salt `1613e22314be8401`, 32 ciphertext bytes.
Their base64 inner strings:
- k08-2: `U2FsdGVkX1+neXqQQbb5aUlxnt7dhOmJcpAwX86kOU4Ct5sOffaJ/QTz4WQ8gC2p`
- k08-3: `U2FsdGVkX18WE+IjoB6+AUHygK6VhTwKgCsnSd74iW0cIIcdEiQsqQUgJrSpOiXSBLvE`
(original exact contents can be re-read.)
Tried obvious OpenSSL AES-256-CBC password candidates (key/record/customer/feature,
build ID, revision, etc.) and legacy/sha256/PBKDF2 modes; no valid plaintext. Also
tried known flags as passphrases; no hit. These are likely final flags encrypted with
contexts as passwords (k08-2 context; k08-3 chosen entitlement), not primary path.

## Other service findings
- `packages.keplerops.test` npm metadata `@keplerops/fieldlink-connector`:
  dist-tags latest 7.4.2, legacy 6.9.8, next 7.4.3-cinder.rset1.
  6.9.8 `deprecated`: "The legacy v2 interface is retained for maintained
  installations. Maintenance record MTN-6.9.8. FLAG{870a03c573511895}" (likely K05).
- Delivery `GET /api/releases/{release_id}` tested many IDs:
  FLK-6.9.8, 6.9.8, MTN-6.9.8, BLD-REL-742, release-742, etc all 404 with developer auth.
- `cloud-api.keplerops.test` routes in `/.well-known/fieldkest-client`.
- Developer `GET /api/build-records/BLD-REL-742` works:
  `{"build_id":"BLD-REL-742","classification":"release-dossier",
    "exchange_handle":"fk_release_reader_rfz2ddxROKwT6q9s0YZnFieDd_N21gxs",
    "release_principal":"release-reader","schema":"fieldkest.build-record/v1","status":"retained"}`.
- Workspace token flow works:
  1. basic POST `/api/workspaces/current/token-exchange` body `{}` -> JWT for
     `svc-fieldlink-workload` (aud k3s).
  2. Bearer workspace JWT POST `/api/token-exchange/release-reader` with
     `{"exchange_handle":"fk_release_reader_rfz2ddxROKwT6q9s0YZnFieDd_N21gxs"}`
     -> role token principal `svc-fieldlink-export`, audience `release-reader`,
     role `role/support-export-editor`.
  3. That role JWT alone is rejected by delivery and cloud build endpoints (Basic
     developer required there); likely useful for K05 export routes, not K08 release lookup.
- Jenkins `fieldlink-report` #1842 console contains `FLAG{7db9f86b38c288ab}`
  after failed fixture test (probably another chapter, not K08).
- Gitea issue #1 has `FLAG{b4827df7ab6888be}` for fixture provenance (another chapter).
- K8s rowan service account cannot list workloads/secrets/etc.
- Postgres only `export.partition_bindings` readable; no entitlement context.
- Chromium history only support ticket SUP-2841.

## Next steps
1. Submit K08.1 diagnostic flag (certain).
2. Recover correct release ID/context. Focus on delivery release IDs and historical source
   refs/policy accept flow; delivery `/api/releases/*` is now known to require Basic.
3. Try structured context values based on records under rowan-dev / S3 and other services.
4. Brute-force record decryption only as validation, not flag guessing:
   broad HKDF-SHA256 combos around raw/hex build ID and obvious metadata + many AAD
   candidates already tried, no success.
