set +e
C="curl -sSk -m 20 --socks5-hostname 127.0.0.1:1080"
B=https://cloud-api.keplerops.test
U="rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"
WT=$($C -u "$U" -X POST -H 'Content-Type: application/json' -d '{}' "$B/api/workspaces/current/token-exchange" | python3 -c 'import sys,json;print(json.load(sys.stdin).get("access_token",""))')
EJ=$($C -X POST -H "Authorization: Bearer $WT" -H 'Content-Type: application/json' -d '{}' "$B/api/token-exchange/fieldkest-export-access" | python3 -c 'import sys,json;print(json.load(sys.stdin).get("access_token",""))')
echo "===== GET definition"
$C -m 12 -H "Authorization: Bearer $EJ" -w '\n[%{http_code}]\n' "$B/api/exports/EXP-2841/definition" | head -c 1800; echo
echo "===== GET destination route"
$C -m 12 -H "Authorization: Bearer $EJ" -w '\n[%{http_code}]\n' "$B/api/exports/EXP-2841/destination" | head -c 900; echo
echo "===== POST run current binding"
$C -m 20 -X POST -H "Authorization: Bearer $EJ" -H 'Content-Type: application/json' \
 -d '{"tenant":"TEN-ARWC-019","connector_revision":"FLK-7.4.2","partitions":["PART-ARWC-01"],"revision":6}' \
 -w '\n[%{http_code}]\n' "$B/api/exports/EXP-2841/runs" | head -c 1800; echo
echo "===== POST run other binding"
$C -m 20 -X POST -H "Authorization: Bearer $EJ" -H 'Content-Type: application/json' \
 -d '{"tenant":"TEN-OTHER-001","connector_revision":"FLK-7.3.1","partitions":["PART-ARWC-02"],"revision":5}' \
 -w '\n[%{http_code}]\n' "$B/api/exports/EXP-2841/runs" | head -c 1800; echo
