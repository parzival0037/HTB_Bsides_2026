#!/bin/bash
set +e
P="--socks5-hostname 127.0.0.1:1080 -sS -m 10"
B=http://10.77.60.21:8080
echo "## root"
curl $P -i "$B/" | head -40
echo "## wellknowns"
for p in /.well-known/fieldkest-client /.well-known/arwc-client /openapi.json /api /health /status /version /robots.txt; do
  echo "--- $p"
  curl $P "$B$p" -w '\n[%{http_code}]\n' | head -c 1500; echo
done
echo "## path guesses"
for p in /planning /planning/ /api/planning /api/planning/current /api/allocations /api/allocations/current /api/allocation /api/ledger /api/ledger/current /api/meters /api/meter /api/meter-export /api/process /api/process/current /api/process-data /api/readings /api/readings/current /api/observations /api/observations/current /api/districts /api/reserves /api/reserve /api/reports /api/reports/current /api/customers /api/tenants /api/assets /api/outlets /api/asset/CRR-OG2; do
  code=$(curl $P -o /tmp/p21.out -w '%{http_code}' "$B$p")
  sz=$(wc -c </tmp/p21.out)
  if [ "$code" != "404" ]; then echo "HIT $code $sz $p :: $(head -c 300 /tmp/p21.out | tr -d '\n')"; fi
done
echo DONE_A11
