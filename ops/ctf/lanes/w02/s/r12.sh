C="curl -sS --socks5-hostname 127.0.0.1:1080 --cacert /tmp/ca.crt --max-time 15 -o /dev/null -w"
B=https://connector.arwc.test
for p in / /api /api/ /api/fieldlink /api/fieldlink/ /api/fieldlink/packages /api/fieldlink/packages/poll /api/fieldlink/packages/7.4.2/receipt /robots.txt /health /version /.well-known/fieldkest-client /api/orders /api/order /api/workorders /api/work-orders /api/inspections /api/jobs /api/crew /api/roster /api/appointments /api/maintenance /api/supplier /api/contractor /api/assets /api/outlets /api/customers /api/tenants /api/documents /api/drawings /api/records /api/indexes /api/exports /api/status /admin /docs /openapi.json /swagger.json; do
 r=$($C '%{http_code} %{size_download}' "$B$p")
 echo "$r $p"
done
