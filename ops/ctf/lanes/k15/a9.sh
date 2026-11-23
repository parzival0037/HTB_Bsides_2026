set +e
ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev 'bash -s' <<'RSH'
set +e
CA=$HOME/.local/share/keplerops/ca.crt
C=https://cloud-api.keplerops.test
BASIC=$(printf 'rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo' | base64 -w0)
curl -sS -m 15 --cacert $CA -X POST -H "Authorization: Basic $BASIC" -H 'Content-Type: application/json' -d '{}' "$C/api/workspaces/current/token-exchange" -o /tmp/w.json -w '[w %{http_code}]\n'
W=$(python3 -c 'import json;print(json.load(open("/tmp/w.json"))["access_token"])')
curl -sS -m 15 --cacert $CA -X POST -H "Authorization: Bearer $W" -H 'Content-Type: application/json' -d '{}' "$C/api/token-exchange/export" -o /tmp/e.json -w '[e %{http_code}]\n'
E=$(python3 -c 'import json;print(json.load(open("/tmp/e.json"))["access_token"])')
echo "$E" > /tmp/export.tok
echo "###### export token jwt payload"
python3 - <<PY
import base64,json
t="$E"; p=t.split('.')[1]; p+='='*(-len(p)%4)
print(json.dumps(json.loads(base64.urlsafe_b64decode(p)),indent=1))
PY
for p in /api/exports/EXP-2841/handover /api/exports/EXP-2841/destinations /api/exports/EXP-2841/collection /api/exports/EXP-2841/material /api/exports/EXP-2841/handovers; do
 echo "--- GET $p"; curl -sS -m 10 --cacert $CA -H "Authorization: Bearer $E" -w ' [%{http_code}]' "$C$p" | head -c 500; echo
done
for body in '{"destination":"fieldkest-exports/EXP-2841-rowan"}' '{"handover":"fieldkest-exports/EXP-2841-rowan"}' '{"destination":{"name":"fieldkest-exports/EXP-2841-rowan","owner":"rowan.ito"}}'; do
 echo "--- PATCH handover $body"; curl -sS -m 15 --cacert $CA -X PATCH -H "Authorization: Bearer $E" -H 'Content-Type: application/json' -d "$body" -w ' [%{http_code}]' "$C/api/exports/EXP-2841/handover" | head -c 700; echo
done
echo "--- export record post"; curl -sS -m 10 --cacert $CA -H "Authorization: Bearer $E" "$C/api/exports/EXP-2841" ; echo
echo "--- definition post"; curl -sS -m 10 --cacert $CA -H "Authorization: Bearer $E" "$C/api/exports/EXP-2841/definition" ; echo
echo "###### work tree"
find ~/work -maxdepth 2 | head -60
RSH
echo DONE_A9
