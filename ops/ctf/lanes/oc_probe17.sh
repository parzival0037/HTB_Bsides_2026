set +e
C="curl -sSk -m 20 --socks5-hostname 127.0.0.1:1080"
B=https://cloud-api.keplerops.test
K=https://cloud-api.keplerops.test:6443
U="rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"
WT=$($C -u "$U" -X POST -H 'Content-Type: application/json' -d '{}' "$B/api/workspaces/current/token-exchange" | python3 -c 'import sys,json;print(json.load(sys.stdin).get("access_token",""))')
EJ=$($C -X POST -H "Authorization: Bearer $WT" -H 'Content-Type: application/json' -d '{}' "$B/api/token-exchange/fieldkest-export-access" | python3 -c 'import sys,json;print(json.load(sys.stdin).get("access_token",""))')
echo "===== PATCH definition tenant -> TEN-ARWC-047"
$C -m 12 -X PATCH -H "Authorization: Bearer $EJ" -H 'Content-Type: application/merge-patch+json' \
 -d '{"data":{"tenant":"TEN-ARWC-047","tenant_id":"TEN-ARWC-047"}}' -w '\n[%{http_code}]\n' \
 "$K/api/v1/namespaces/fieldlink/configmaps/exp-2841-definition" | head -c 500; echo
echo "===== run current binding TEN-ARWC-047"
$C -m 20 -X POST -H "Authorization: Bearer $EJ" -H 'Content-Type: application/json' \
 -d '{"tenant":"TEN-ARWC-047","connector_revision":"FLK-7.4.2","partitions":["PART-ARWC-01"],"revision":6}' \
 -w '\n[%{http_code}]\n' "$B/api/exports/EXP-2841/runs" | head -c 1800; echo
echo "===== GET definition after"
$C -m 12 -H "Authorization: Bearer $EJ" "$B/api/exports/EXP-2841/definition" | head -c 1200; echo
