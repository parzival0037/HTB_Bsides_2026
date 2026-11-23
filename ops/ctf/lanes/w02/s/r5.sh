C="curl -sS --socks5-hostname 127.0.0.1:1080 --cacert /tmp/ca.crt --max-time 25"
B=https://delivery.keplerops.test:8443
echo "### POST inspections normal"
$C -i -X POST "$B/api/inspections" -H 'Content-Type: application/json' -d '{"action":"inspect_public_manifest","package":"@keplerops/fieldlink-connector","request_id":"release-742","schema":"fieldkest.inspection/v1","version":"7.4.2"}' | head -c 3000
echo; echo "### GET inspections list"
$C -i "$B/api/inspections" | head -c 1500
echo; echo "### POST envelope"
$C -i -X POST "$B/api/inspections/envelope" -H 'Content-Type: application/octet-stream' --data-binary @/dev/null | head -c 1500
