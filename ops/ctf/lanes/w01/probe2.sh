#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
CA=/tmp/ca.crt
base=https://connector.arwc.test
for p in / /health /healthz /status /api /api/ /v1 /v1/ /.well-known/fieldkest-client /openapi.json /docs /robots.txt /handover /handovers /api/handovers /api/handover /customer /customers /deliveries /fields /fieldlink /maintenance /cases /api/cases; do
  code=$(curl -sS $P -k --max-time 12 -o /tmp/o -w '%{http_code}' "$base$p")
  echo "### $p -> $code"
  head -c 400 /tmp/o; echo
done
