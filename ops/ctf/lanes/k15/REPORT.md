# K15 REPORT — in progress

## Flags / status
- **K15.1 solved:** `FLAG{6b4342f2b090f8d2}` (export record EXP-2841; submission already accepted by the shared watcher).
- **K15.2 solved:** `FLAG{bd60dc9d170bc2c7}` (restricted definition; already accepted).
- **K15.3 unsolved:** need delegated handover redirection.
- **K15.4 unsolved:** need recover handed-over ARWC collection and resolve DB partition/revision records.

## Access / API map
- From range box, `ssh rowan-dev`; all KeplerOps calls run there with CA `/home/rowan/.local/share/keplerops/ca.crt`.
- Basic `rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo` -> `POST https://cloud-api.keplerops.test/api/workspaces/current/token-exchange` -> workload JWT -> `POST /api/token-exchange/export` -> export JWT.
- Export API: `/api/exports/EXP-2841`, `/api/exports/EXP-2841/definition`, `/api/schedules/SCHED-2841`, `/api/maintenance` work with export JWT. Collection endpoints `/api/exports` and `/api/schedules` require authentication not supplied by that token.
- EXP-2841: case CAS-MAYA-2841, dataset `support-case-history`, revision 6, destination `fieldkest-exports`, state unpublished.
- Definition owner maya.ranscombe; delegated destinations `fieldkest-exports/EXP-2841-rowan` (rowan.ito) and `fieldkest-exports/EXP-2841-maya` (maya.ranscombe). Definition current binding TEN-ARWC-047 / PART-ARWC-01 / FLK-7.4.2 / rev6.
- PostgreSQL `psql service=fieldlink` (credentials in rowan `.pg_service.conf`/`.pgpass`), only application table `export.partition_bindings`. Current DB row for EXP-2841 = **TEN-ARWC-019 / PART-ARWC-01 / FLK-7.4.2 / rev6 / current=true**; older non-current TEN-OTHER-001 / PART-ARWC-02 / FLK-7.3.1 / rev5.
- S3 endpoint `https://objects.keplerops.test`; profile in rowan `~/.aws`. Ordinary bucket `fieldlink-exports`; retained collections are not listable and require exact bucket/key/digest.
- Gitea repos: fieldlink-connector, connector-archive, policy-compiler, release-signer-history. fieldlink-connector also has `delivery-operations` branch.

## Likely next mechanism
K14.2 was solved from ConfigMap `fieldlink/role-export-access` and role JWT `POST /api/token-exchange/fieldkest-export-access`. Read that role record: it should describe delegated export/handover rights. Then set EXP-2841 handover to the existing delegated rowan destination (without changing owner/partition binding) and inspect resulting object material.

## Dead ends
- Guessed `destination`/`handover` JSON bodies on `/api/exports/EXP-2841/destination` did not yield a saved successful result.
- Gitea guessed review-export paths all 404; unrelated to immediate handover path.

Detailed evidence and commands: `notes.md`, `a1.sh`..`a9.sh`, earlier `r*.sh`.
