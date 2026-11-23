#!/bin/bash
echo "== cert SANs =="
echo | openssl s_client -connect 127.0.0.1:1080 2>/dev/null >/dev/null
# use curl to dump cert via socks: openssl can't socks. Use proxychains? Use python ssl over socks later.
echo "== connector routes =="
for p in "" "api" "api/v1" "health" "healthz" "status" "version" "robots.txt" ".well-known/fieldkest-client" "docs" "openapi.json" "api/appointments" "appointments" "roster" "checkin" "check-in" "outlet" "inspection" "maintenance" "admin" "login" "auth" "session" "v1" "api/v1/appointments" "api/roster" "api/checkin"; do
  code=$(curl -sS -m 10 --socks5-hostname 127.0.0.1:1080 -k -o /tmp/body.$$ -w '%{http_code}' "https://connector.arwc.test/$p" 2>/dev/null)
  sz=$(wc -c </tmp/body.$$)
  echo "$code $sz /$p :: $(head -c 200 /tmp/body.$$ | tr '\n' ' ')"
done
rm -f /tmp/body.$$
