set +e
C="curl -sSk -m 20 --socks5-hostname 127.0.0.1:1080"
B=https://cloud-api.keplerops.test
U="rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"
WT=$($C -u "$U" -X POST -H 'Content-Type: application/json' -d '{}' "$B/api/workspaces/current/token-exchange" | python3 -c 'import sys,json;print(json.load(sys.stdin).get("access_token",""))')
EJ=$($C -X POST -H "Authorization: Bearer $WT" -H 'Content-Type: application/json' -d '{}' "$B/api/token-exchange/fieldkest-export-access" | python3 -c 'import sys,json;print(json.load(sys.stdin).get("access_token",""))')
echo "===== PATCH destination -> EXP-2841-rowan"
$C -m 12 -X PATCH -H "Authorization: Bearer $EJ" -H 'Content-Type: application/json' -d '{"destination":"fieldkest-exports/EXP-2841-rowan"}' -w '\n[%{http_code}]\n' "$B/api/exports/EXP-2841/destination" | head -c 1500; echo
echo "===== GET export after"
$C -m 12 -H "Authorization: Bearer $EJ" "$B/api/exports/EXP-2841" | head -c 900; echo
echo "===== PATCH definition destination configmap"
$C -m 12 -X PATCH -H "Authorization: Bearer $EJ" -H 'Content-Type: application/merge-patch+json' -d '{"data":{"destination":"fieldkest-exports/EXP-2841-rowan"}}' -w '\n[%{http_code}]\n' "https://cloud-api.keplerops.test:6443/api/v1/namespaces/fieldlink/configmaps/exp-2841-definition" | head -c 700; echo
echo "===== export run POST"
$C -m 20 -X POST -H "Authorization: Bearer $EJ" -H 'Content-Type: application/json' -d '{}' -w '\n[%{http_code}]\n' "$B/api/exports/EXP-2841/runs" | head -c 1500; echo
