#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080 -k -sS --max-time 15"
echo "=== cert"
echo | openssl s_client -connect 127.0.0.1:1080 2>/dev/null >/dev/null
echo "=== TLS via proxy (curl -v)"
curl --socks5-hostname 127.0.0.1:1080 -kv https://connector.arwc.test/ 2>&1 | grep -Ei 'subject|issuer|subjectAltName|HTTP/' | head -20
echo "=== path enum"
for p in / /health /healthz /status /api /api/ /api/v1 /v1 /v1/ /.well-known/fieldkest-client /.well-known /openapi.json /docs /robots.txt /sitemap.xml /home /index.html /login /auth /api/plants /api/sites /api/tags /api/points /api/registers /api/native /native /export /api/export /api/catalog /catalog /api/historian /historian /api/plc /plc /api/opcua /api/modbus /outlets /api/outlets /api/gates /gates /dashboard; do
  code=$(curl $P -o /tmp/o -w '%{http_code}' "https://connector.arwc.test$p")
  sz=$(stat -c%s /tmp/o)
  echo "### $p -> $code $sz"; head -c 200 /tmp/o; echo
done
