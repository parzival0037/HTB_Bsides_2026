set +e
C="curl -sSk -m 20 --socks5-hostname 127.0.0.1:1080"
B=https://cloud-api.keplerops.test
K=https://cloud-api.keplerops.test:6443
U="rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"
WT=$($C -u "$U" -X POST -H 'Content-Type: application/json' -d '{}' "$B/api/workspaces/current/token-exchange" | python3 -c 'import sys,json;print(json.load(sys.stdin).get("access_token",""))')
EJ=$($C -X POST -H "Authorization: Bearer $WT" -H 'Content-Type: application/json' -d '{}' "$B/api/token-exchange/fieldkest-export-access" | python3 -c 'import sys,json;print(json.load(sys.stdin).get("access_token",""))')
PB='[{"partition":"PART-ARWC-01","current":true,"tenant":"TEN-ARWC-047","tenant_id":"TEN-ARWC-047","connector_revision":"FLK-7.4.2","revision":6},{"partition":"PART-ARWC-02","current":false,"tenant":"TEN-OTHER-001","tenant_id":"TEN-OTHER-001","connector_revision":"FLK-7.3.1","revision":5}]'
python3 - "$PB" > /tmp/pb.json <<'PY'
import json,sys
print(json.dumps({"data":{"partition_bindings":sys.argv[1],"partitions":json.dumps(["PART-ARWC-01"]),"tenant":"TEN-ARWC-047"}}))
PY
echo "payload:"; head -c 600 /tmp/pb.json; echo
echo "===== PATCH partition_bindings"
$C -m 12 -X PATCH -H "Authorization: Bearer $EJ" -H 'Content-Type: application/merge-patch+json' --data-binary @/tmp/pb.json -w '\n[%{http_code}]\n' "$K/api/v1/namespaces/fieldlink/configmaps/exp-2841-definition" | head -c 400; echo
echo "===== run current binding"
$C -m 20 -X POST -H "Authorization: Bearer $EJ" -H 'Content-Type: application/json' \
 -d '{"tenant":"TEN-ARWC-047","connector_revision":"FLK-7.4.2","partitions":["PART-ARWC-01"],"revision":6}' \
 -w '\n[%{http_code}]\n' "$B/api/exports/EXP-2841/runs" | head -c 1800; echo
echo "===== GET definition after"
$C -m 12 -H "Authorization: Bearer $EJ" "$B/api/exports/EXP-2841/definition" | head -c 1400; echo
