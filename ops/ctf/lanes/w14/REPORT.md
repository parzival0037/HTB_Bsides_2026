# W14 — ARWC field export / service pivot (in progress)

## Status
Started 2026-11-20 ~19:3xZ. No flags yet.

## Assigned
- W14.1 The field bag (50p) — recover the inspection's field export from the contractor workspace.
- W14.2 The service that replaced it (100p) — obsolete field-service ref vs active process-data service; identify current read contract.
- W14.3 A fresh reading from the field (100p) — adapt contractor's retained field client to current read interface; recover fresh outlet observations under inspection's correct asset scope.

## Known context (from NETMAP/other lanes)
- Pivot: SOCKS5 127.0.0.1:1080 on range box -> rowan-dev -> KeplerOps net.
- rowan-dev: ssh rowan port 2222, Gitea dev token fk_developer_YUWTKSqrc16y3K5_5DfQ7qacft9b-9xo (rowan.ito).
- ARWC side host: connector.arwc.test = 10.77.60.20.
- W17/W18/W25 reference "Cairn Reach" controllers/HMI/historian; W14 likely chains to that outlet/process-data service.

## TODO
- Enumerate connector.arwc.test + Gitea repos mentioning arwc/inspection/field.
