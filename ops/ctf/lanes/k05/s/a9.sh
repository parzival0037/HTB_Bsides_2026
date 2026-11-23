set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'CA=$HOME/.local/share/keplerops/ca.crt
A="Authorization: Basic $(printf "rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo" | base64 -w0)"
D="https://delivery.keplerops.test:8443"
for p in / /api /api/ /openapi.json /api/openapi.json /docs /api/docs /health /api/routes /api/consumer-checks /api/consumer-checks/CHK-7138E417672F /api/sealed /api/sealed-flags /api/registry /api/package-meta /api/packages /api/compatibility /api/reconcile/tenant-package; do
  echo "--- GET $p"
  curl -sS -m 10 -o /tmp/o -w "%{http_code} " -H "$A" "$D$p" --cacert $CA; head -c 300 /tmp/o; echo
done' 2>&1 | tail -70
