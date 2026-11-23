#!/bin/bash
set +e
P="--socks5-hostname 127.0.0.1:1080 -k -sS -m 20"
C="Cookie: KB_SID=61073ebaedb1d2e9986fea5cac5f50cd"
echo "=== directory no cookie"; curl $P -i "https://staff.keplerops.test/api/service-directory" | head -40
echo "=== directory cookie"; curl $P -H "$C" -i "https://staff.keplerops.test/api/service-directory" | head -60
echo "=== notes RPT-CRR-DP3-R7"; curl $P -H "$C" -i "https://staff.keplerops.test/api/notes/RPT-CRR-DP3-R7" | head -30
echo "=== archive arwc"; curl $P -H "$C" -i "https://staff.keplerops.test/api/archive/handovers/arwc" | head -30
echo "=== archive cairn"; curl $P -H "$C" -i "https://staff.keplerops.test/api/archive/handovers/cairn" | head -30
echo "=== login page"; curl $P -i "https://staff.keplerops.test/login" | head -40
echo DONE_R10
