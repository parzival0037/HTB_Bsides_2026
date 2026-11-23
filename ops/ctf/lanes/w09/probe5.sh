#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080 -k -sS -m 20"
T=fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo
for u in \
 "https://source-tools.keplerops.test:8443/.well-known/fieldkest-client" \
 "https://review.keplerops.test/.well-known/fieldkest-client" \
 "https://source-tools.keplerops.test:8443/" \
 "https://review.keplerops.test/" ; do
 echo "===== $u"; curl $P "$u" -w '\n[%{http_code}]\n' | head -c 2500; echo
done
echo "===== connector parametrized scan"
BASE=https://connector.arwc.test
for p in \
 /exports/EXP-2841 /export/EXP-2841 /api/exports/EXP-2841 /api/export/EXP-2841 \
 /download/EXP-2841 /api/download/EXP-2841 /export/EXP-2841/PART-ARWC-01 \
 /api/exports/EXP-2841/PART-ARWC-01 /partitions/PART-ARWC-01 \
 /api/partitions/PART-ARWC-01 /customers/TEN-ARWC-047 /api/customers/TEN-ARWC-047 \
 /customer/TEN-ARWC-047 /relay /relay/exports /api/relay/exports \
 /exports/EXP-2841/current /exports/current/EXP-2841 \
 /healthz /api/status /relay/status ; do
 code=$(curl $P -o /tmp/z.txt -w '%{http_code}' "$BASE$p"); sz=$(wc -c </tmp/z.txt)
 echo "$code $sz $p"; [ "$code" != "404" ] && head -c 500 /tmp/z.txt && echo
done
echo "===== root with query"
curl $P "https://connector.arwc.test/?export=EXP-2841" -w '\n[%{http_code}]\n'
echo "===== other vhosts on 10.77.60.20"
for u in "https://10.77.60.20/" "https://10.77.60.20:8443/" "http://10.77.60.20/"; do
 echo "-- $u"; curl $P -k "$u" -w '\n[%{http_code}]\n' | head -c 400; echo
done
