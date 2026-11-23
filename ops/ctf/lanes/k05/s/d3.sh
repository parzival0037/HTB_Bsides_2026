set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'CA=$HOME/.local/share/keplerops/ca.crt
A="Authorization: Basic $(printf "rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo" | base64 -w0)"
D="https://delivery.keplerops.test:8443"
ENT=$(curl -sS -m 15 -H "Authorization: Basic $(printf "rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo" | base64 -w0)" "https://source.keplerops.test/api/v1/repos/fieldkest/connector-archive/raw/internal/fieldlink/legacy-diagnostics/CRR-OG2/ENT-ARWC-DIAG-0698.json" --cacert $CA)
echo "$ENT" > /tmp/ent.json
post(){ echo "--- $1"; curl -sS -m 20 -X POST "$D/api/reconcile/tenant-package" -H "$A" -H "Content-Type: application/json" --cacert $CA -d "$1" -w " [%{http_code}]"; echo; }
post "{\"record\":$ENT}"
post "{\"entitlement\":$ENT}"
post "{\"record_id\":\"ENT-ARWC-DIAG-0698\",\"tenant\":\"TEN-ARWC-019\",\"package\":\"@keplerops/fieldlink-connector\",\"package_revision\":\"FLK-6.9.8\"}"
post "{\"tenant\":\"TEN-ARWC-019\",\"record\":\"ENT-ARWC-DIAG-0698\",\"package_revision\":\"FLK-6.9.8\"}"
post "{\"customer_id\":\"TEN-ARWC-019\",\"record_id\":\"ENT-ARWC-DIAG-0698\",\"package_revision\":\"FLK-6.9.8\",\"package\":\"@keplerops/fieldlink-connector\"}"
echo "=== releases guesses"
for r in REL-742 REL-7.4.2 EXP-2841 BLD-REL-742 release-742 release-6.9.8 REL-6.9.8 7.4.2 FLK-7.4.2; do echo "-- $r"; curl -sS -m 10 -H "$A" "$D/api/releases/$r" --cacert $CA; echo; done' 2>&1 | tail -60
