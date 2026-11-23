set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'CA=$HOME/.local/share/keplerops/ca.crt
A="Authorization: Basic $(printf "rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo" | base64 -w0)"
D="https://delivery.keplerops.test:8443"
post(){ echo "--- $1"; curl -sS -m 20 -i -X POST "$D/api/reconcile/tenant-package" -H "$A" -H "Content-Type: application/json" --cacert $CA -d "$1"; echo; }
post "{}"
post "{\"tenant\":\"TEN-ARWC-047\",\"package\":\"@keplerops/fieldlink-connector\"}"
post "{\"tenant_id\":\"TEN-ARWC-047\",\"package\":\"@keplerops/fieldlink-connector\"}"
post "{\"tenant\":\"TEN-ARWC-019\",\"package\":\"@keplerops/fieldlink-connector\"}"
post "{\"tenant\":\"TEN-OTHER-001\",\"package\":\"@keplerops/fieldlink-connector\"}"
' 2>&1 | tail -80
