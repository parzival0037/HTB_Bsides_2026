#!/bin/bash
R() { ssh -o StrictHostKeyChecking=no -o ConnectTimeout=8 -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180 "$@"; }
PX="--socks5-hostname 127.0.0.1:1080 -k -m 10"
for p in / /index.html /api /api/ /health /healthz /robots.txt /.well-known/fieldkest-client /openapi.json /api/v1 /docs /status /metrics; do
  echo "### GET $p"
  curl -sS $PX -w '\n[%{http_code}]\n' "https://connector.arwc.test$p" | head -30
done
echo "=== ARWC net scan from rowan-dev ==="
R 'for i in 1 2 3 4 5 6 10 11 12 20 21 22 30 40 50 60 70 80 100; do for p in 80 443 8080 8081 8443; do timeout 1 bash -c "echo > /dev/tcp/10.77.60.$i/$p" 2>/dev/null && echo "10.77.60.$i:$p open"; done; done' 
echo "=== DNS attempts ==="
R 'getent hosts supply.arwc.test; getent hosts arwc.test; getent hosts portal.arwc.test; getent hosts procurement.arwc.test'
