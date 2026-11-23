#!/bin/bash
set +e
P="--socks5-hostname 127.0.0.1:1080 -k -sS -m 15"
B=https://cloud-api.keplerops.test
for p in /api/exports/EXP-2841 /api/exports/EXP-2841/definition /api/exports /api/maintenance /api/policies/current /api/workspaces/current/token-exchange /; do
 echo "=== GET $p"; curl $P -i "$B$p" | head -25
done
echo "=== with basic auth"
for p in /api/exports/EXP-2841 /api/exports/EXP-2841/definition; do echo "=== $p"; curl $P -u rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo -i "$B$p" | head -40; done
echo DONE_R15
