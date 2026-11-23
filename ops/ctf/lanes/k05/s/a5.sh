set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'CA=$HOME/.local/share/keplerops/ca.crt
echo "=== as-is consumer-request.json"
curl -sS -m 15 -i -X POST "https://delivery.keplerops.test:8443/api/consumer-checks" -H "Content-Type: application/json" --cacert $CA --data @work/registry/consumer-request.json
echo; echo "=== package meta"
curl -sS -m 15 "https://delivery.keplerops.test:8443/api/package-meta/fieldlink-connector" --cacert $CA
echo; echo "=== release 742"
curl -sS -m 15 "https://delivery.keplerops.test:8443/api/releases/release-742" --cacert $CA
echo; echo "=== release BLD-REL-742"
curl -sS -m 15 "https://delivery.keplerops.test:8443/api/releases/BLD-REL-742" --cacert $CA
echo' 2>&1 | tail -80
