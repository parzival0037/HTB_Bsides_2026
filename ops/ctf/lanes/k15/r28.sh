set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'RSH'
set +e
C=https://cloud-api.keplerops.test
BASIC=$(printf 'rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo' | base64 -w0)
W=$(curl -sS -m 15 -k -X POST -H "Authorization: Basic $BASIC" -H "Content-Type: application/json" -d '{}' "$C/api/workspaces/current/token-exchange" | python3 -c 'import json,sys;print(json.load(sys.stdin)["access_token"])')
E=$(curl -sS -m 12 -k -X POST -H "Authorization: Bearer $W" -H "Content-Type: application/json" -d '{}' "$C/api/token-exchange/export" | python3 -c 'import json,sys;print(json.load(sys.stdin)["access_token"])')
p(){ echo "--- PATCH body=$1"; curl -sS -m 15 -k -X PATCH -H "Authorization: Bearer $E" -H "Content-Type: application/json" -d "$1" -w " [%{http_code}]" "$C/api/exports/EXP-2841/destination" | head -c 1500; echo; }
p '{"destination":"fieldkest-exports/EXP-2841-rowan"}'
p '{"handover":"fieldkest-exports/EXP-2841-rowan"}'
p '{"destination":{"name":"fieldkest-exports/EXP-2841-rowan"}}'
p '{"destination":"fieldkest-exports/EXP-2841-maya"}'
echo "=== current export record"
curl -sS -m 15 -k -H "Authorization: Bearer $E" "$C/api/exports/EXP-2841"; echo
RSH
