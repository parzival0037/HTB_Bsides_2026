set +e
echo "###### pivot check"
curl -sS -m 15 --socks5-hostname 127.0.0.1:1080 -k -o /dev/null -w 'gitea=%{http_code}\n' https://source.keplerops.test/
echo "###### ssh rowan-dev"
ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=10 rowan-dev 'bash -s' <<'RSH'
set +e
CA=$HOME/.local/share/keplerops/ca.crt
C=https://cloud-api.keplerops.test
BASIC=$(printf 'rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo' | base64 -w0)
echo "== workspace exchange"
curl -sS -m 15 --cacert $CA -X POST -H "Authorization: Basic $BASIC" -H "Content-Type: application/json" -d '{}' "$C/api/workspaces/current/token-exchange" -o /tmp/w.json -w '[%{http_code}]\n'
head -c 600 /tmp/w.json; echo
W=$(python3 -c 'import json;print(json.load(open("/tmp/w.json")).get("access_token",""))' 2>/dev/null)
echo "== export exchange"
curl -sS -m 15 --cacert $CA -X POST -H "Authorization: Bearer $W" -H "Content-Type: application/json" -d '{}' "$C/api/token-exchange/export" -o /tmp/e.json -w '[%{http_code}]\n'
head -c 800 /tmp/e.json; echo
E=$(python3 -c 'import json;print(json.load(open("/tmp/e.json")).get("access_token",""))' 2>/dev/null)
echo "E=${E:0:40}"
echo "== endpoints with export token"
for p in /api/exports /api/exports/EXP-2841 /api/exports/EXP-2841/definition /api/schedules /api/schedules/SCHED-2841 /api/maintenance /api/trust-records /api/customers; do
 echo "--- $p"
 curl -sS -m 15 --cacert $CA -H "Authorization: Bearer $E" -w '\n[%{http_code}]\n' "$C$p" | head -c 2000; echo
done
RSH
echo DONE_A1
