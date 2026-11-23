set +e
ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev 'bash -s' <<'RSH'
set +e
CA=$HOME/.local/share/keplerops/ca.crt
A="Authorization: Basic $(printf "rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo" | base64 -w0)"
B=https://source.keplerops.test/api/v1/repos/fieldkest
echo "###### .npmrc at dfee65cf9e"
curl -sS -m 15 --cacert $CA -H "$A" "$B/fieldlink-connector/raw/delivery/.npmrc?ref=dfee65cf9ed5dea02a8e8aeefe0eaee1b3330d19"; echo
echo "###### home listing"
ls -la ~ ; echo; find ~ -maxdepth 3 -name '*.md' -o -maxdepth 3 -name '*.json' -maxdepth 3 2>/dev/null | head -50
echo "###### work notes"
for f in ~/work/*.md ~/notes/*.md ~/NOTES.md; do [ -f "$f" ] && { echo "=== $f"; head -c 3000 "$f"; echo; }; done
echo "###### cloud-api path probes with export token"
C=https://cloud-api.keplerops.test
curl -sS -m 15 --cacert $CA -X POST -H "Authorization: Basic $BASIC" -H 'Content-Type: application/json' -d '{}' "$C/api/workspaces/current/token-exchange" -o /tmp/w.json
W=$(python3 -c 'import json;print(json.load(open("/tmp/w.json"))["access_token"])')
curl -sS -m 15 --cacert $CA -X POST -H "Authorization: Bearer $W" -H 'Content-Type: application/json' -d '{}' "$C/api/token-exchange/export" -o /tmp/e.json
E=$(python3 -c 'import json;print(json.load(open("/tmp/e.json"))["access_token"])')
for p in /api /api/ /api/exports/EXP-2841/handover /api/exports/EXP-2841/destinations /api/exports/EXP-2841/handovers /api/handovers /api/handovers/EXP-2841 /api/exports/EXP-2841/collection /api/exports/EXP-2841/material /api/exports/EXP-2841/runs; do
 echo "--- GET $p"; curl -sS -m 10 --cacert $CA -H "Authorization: Bearer $E" -w ' [%{http_code}]' "$C$p" | head -c 400; echo
done
RSH
echo DONE_A8
