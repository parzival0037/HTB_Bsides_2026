set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<"REMOTE" 2>&1 | tail -400
set +e
CA=$HOME/.local/share/keplerops/ca.crt
A="Authorization: Basic $(printf "rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo" | base64 -w0)"
D="https://delivery.keplerops.test:8443"
p(){ echo "===== $1"; shift; curl -sS -m 20 -X POST "$D/api/reconcile/tenant-package" -H "$A" -H "Content-Type: application/json" --cacert $CA -d "$1" -w " [%{http_code}]"; echo; }
p '{}'
p '{"tenant_id":"TEN-ARWC-019"}'
p '{"tenant":"TEN-ARWC-019"}'
p '{"tenant":"TEN-ARWC-019","package":"@keplerops/fieldlink-connector"}'
p '{"tenant_id":"TEN-ARWC-019","package":"@keplerops/fieldlink-connector"}'
p '{"record":"ENT-ARWC-DIAG-0698"}'
p '{"record_id":"ENT-ARWC-DIAG-0698"}'
p '{"record_id":"ENT-ARWC-DIAG-0698","tenant":"TEN-ARWC-019","package":"@keplerops/fieldlink-connector"}'
p '{"export_id":"EXP-2841"}'
p '{"export_id":"EXP-2841","tenant":"TEN-ARWC-019"}'
p '{"export_id":"EXP-2841","tenant_id":"TEN-ARWC-019","package":"@keplerops/fieldlink-connector"}'
p '{"binding":{"export_id":"EXP-2841","tenant_id":"TEN-ARWC-019","partition_id":"PART-ARWC-01","release":"FLK-7.4.2","slot":6,"retained":true}}'
p '{"manifest":"FLK-7.4.2","selection":"FLK-7.4.2"}'
p '{"release_manifest":"7.4.2","selection_record":"6.9.8"}'
p '{"declared_range":"^7.4.0","package":"@keplerops/fieldlink-connector","tenant":"TEN-ARWC-019"}'
p '{"tenant":"TEN-ARWC-047","package":"@keplerops/fieldlink-connector","declared_range":"^7.4.0"}'
p '{"tenant_id":"TEN-ARWC-047","asset_id":"CRR-OG2","package":"@keplerops/fieldlink-connector"}'
echo "===== RELEASES 2"
for r in EXP-2841 exp-2841 EXP2841 PART-ARWC-01 TEN-ARWC-019 $HOME/work/registry 742; do echo "--- $r"; curl -sS -m 10 -H "$A" "$D/api/releases/$r" --cacert $CA -w " [%{http_code}]"; echo; done
echo "===== CONSUMER CHECK GET"
for pth in /api/consumer-checks /api/consumer-checks/CHK-E04D3C186B60 /api/consumer-checks/dac4e2ef698fe4311b6186664add17f3a3710e2275c4c16bfae334e9a6fb3ef0 /api/checks/CHK-E04D3C186B60; do echo "--- $pth"; curl -sS -m 10 -H "$A" "$D$pth" --cacert $CA -w " [%{http_code}]"; echo; done
echo "===== SUPPORT CUSTOMER DIAGNOSTICS"
B="Authorization: Bearer fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b"
for pth in /api/customers/TEN-ARWC-019/diagnostics /api/customers/TEN-ARWC-047/diagnostics /api/handovers/current; do echo "--- $pth"; curl -sS -m 10 -H "$B" "https://support.keplerops.test:8443$pth" --cacert $CA -w " [%{http_code}]"; echo; done
REMOTE
