#!/bin/bash
R() { ssh -o StrictHostKeyChecking=no -o ConnectTimeout=8 -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180 "$@"; }
PX='--socks5-hostname 127.0.0.1:1080 -k -m 20'
echo "=== source-tools well-known ==="
curl -sS $PX 'https://source-tools.keplerops.test:8443/.well-known/fieldkest-client' | head -80
echo "=== review well-known ==="
curl -sS $PX 'https://review.keplerops.test/.well-known/fieldkest-client' | head -80
echo "=== connector cert ==="
echo | openssl s_client -connect connector.arwc.test:443 -servername connector.arwc.test 2>/dev/null | openssl x509 -noout -subject -issuer -ext subjectAltName 2>/dev/null
echo "=== connector with /api prefix routes guess ==="
for p in /healthz /v1 /api/v1/status '/arwc' '/supply' '/catalog' '/quotes' '/api/supply/catalog' '/api/arwc/supply/catalog' '/supply/catalog' '/replacement-supply/catalog' '/api/replacement-supply/catalog' '/district/quotes' '/api/districts'; do
 printf '%-40s ' "$p"; curl -sS $PX -o /tmp/o -w '%{http_code} ' "https://connector.arwc.test$p"; head -c 200 /tmp/o; echo
done
