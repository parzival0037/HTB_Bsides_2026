# W25 lane report (in progress)

Lane W25 — ARWC chapter: Cairn Reach operating envelope, permissives, A30/B10
manual request, A20/B20 restoration. Workdir /home/kali/ctf/lanes/w25.

## Status
2026-11-20 ~20:20Z. No flags yet. Hunting the live Cairn Reach OT lab
(FUXA HMI + OpenPLC + OPC UA + PostgreSQL historian).

## Established facts
- Pivot works: `--socks5-hostname 127.0.0.1:1080` from the range box.
- Box = kali (10.50.13.181), dockered container; /etc/hosts maps rowan-dev.
- rowan-dev = 10.50.13.180:2222 (key ~/.ssh/keplerops-foothold), also a container:
  eth0 10.77.50.20/24, eth1 10.77.55.2/29, default gw 10.77.55.1.
- ARWC edge: connector.arwc.test = 10.77.60.20. Only 22/443 open. Its 443 replies
  `{"error":"route_not_found"}` for every host/path tried (connector., hmi., plc.,
  historian., arwc., all probe paths). Some paths (e.g. /health) hang instead.
- 10.77.50.11 is the KeplerOps "workload" cluster (nginx :443, :8443 integration
  token denied, postgres :5432). Unknown vhosts -> 404 nginx.
- rowan-dev DNS (10.77.50.10) does NOT resolve any *.arwc.test name (no zone).
  Cert for connector.arwc.test SAN list contains only connector.arwc.test from
  the ARWC domain; every other SAN is *.keplerops.test.
- Docker bridge gateway IPs 10.77.53.1 / 54.1 / 55.1 / 56.1 all expose
  OpenSSH_9.2p1 Debian on :22 and :2222 plus xrdp :3389 (same host fingerprint —
  these are bridge IPs of the docker host, not distinct workstations).
  `ssh rowan@10.77.53.1` -> Permission denied (publickey only).
- rowan-dev ~/ has no CairnReach dir; Chromium history only support.keplerops.test.
- Other chapters' unlocked hints (W17, team-wide) say the plant is FUXA at
  hmi.arwc.test, OPC UA opc.tcp://plc:4840/arwc ns urn:arwc:crr:tags, historian
  ot_history.process_samples / tag_catalog on the OT workstation, and records in
  ~/CairnReach/Records (sealed, passphrase = sha256 of canonical sorted JSON).
- W17 hint 0..2 and W17.2/W17.3 hints are already unlocked in the event API
  (team purchase). HINTS.md at lanes/ is stale; live API has the text.

## Needed
Access to the OT workstation / FUXA. Not yet found on 10.77.x (swept .40-.62,
10.50.13.0/24). Continuing with wider 10.77.0.0/16 sweep for 1881/4840/502 and
with ARWC credential discovery from the KeplerOps side.
