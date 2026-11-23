set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'CA=$HOME/.local/share/keplerops/ca.crt
A="Authorization: Basic $(printf "rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo" | base64 -w0)"
D="https://delivery.keplerops.test:8443"
post(){ echo "--- $1"; curl -sS -m 20 -X POST "$D/api/reconcile/tenant-package" -H "$A" -H "Content-Type: application/json" --cacert $CA -d "$1" -w " [%{http_code}]"; echo; }
post "{\"record_id\":\"MTN-6.9.8\"}"
post "{\"record\":\"MTN-6.9.8\"}"
post "{\"tenant\":\"TEN-ARWC-019\",\"record_id\":\"MTN-6.9.8\"}"
post "{\"tenant_id\":\"TEN-ARWC-019\",\"record_id\":\"MTN-6.9.8\",\"package\":\"@keplerops/fieldlink-connector\"}"
post "{\"tenant\":\"TEN-ARWC-019\",\"record_id\":\"MTN-6.9.8\",\"package\":\"@keplerops/fieldlink-connector\",\"selected_version\":\"6.9.8\"}"
post "{\"tenant\":\"TEN-ARWC-047\",\"package\":\"@keplerops/fieldlink-connector\",\"declared_range\":\"^7.4.0\"}"
post "{\"package\":\"@keplerops/fieldlink-connector\",\"declared_range\":\"^7.4.0\"}"
' 2>&1 | tail -40
