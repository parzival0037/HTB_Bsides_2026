set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'CA=$HOME/.local/share/keplerops/ca.crt
A="Authorization: Basic $(printf "rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo" | base64 -w0)"
D="https://delivery.keplerops.test:8443"
echo "=== as-is consumer-request"
curl -sS -m 20 -i -X POST "$D/api/consumer-checks" -H "$A" -H "Content-Type: application/json" --cacert $CA --data @work/registry/consumer-request.json
echo; echo "=== documented example only"
cat > /tmp/ex.json <<J
{"schema":"fieldkest.connector/v3","tenant_id":"TEN-ARWC-047","asset_id":"CRR-OG2","measurements":{"callback_latency_ms":184,"sample_count":17}}
J
curl -sS -m 20 -i -X POST "$D/api/consumer-checks" -H "$A" -H "Content-Type: application/json" --cacert $CA --data @/tmp/ex.json
echo; echo "=== releases"
for r in release-742 BLD-REL-742 742; do echo "-- $r"; curl -sS -m 15 -H "$A" "$D/api/releases/$r" --cacert $CA; echo; done
echo "=== inspections normal"
curl -sS -m 20 -i -X POST "$D/api/inspections" -H "$A" -H "Content-Type: application/json" --cacert $CA --data @work/registry/inspection-normal.json
echo' 2>&1 | tail -80
