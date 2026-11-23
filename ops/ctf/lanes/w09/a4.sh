#!/bin/bash
set +e
P="--socks5-hostname 127.0.0.1:1080 -k -sS -m 15"
B=https://connector.arwc.test
echo "## documented relay routes"
for m in GET POST; do
for p in /api/fieldlink/packages/poll /api/fieldlink/packages/7.4.2/activate /api/fieldlink/packages/7.4.2/receipt /api/fieldlink/rehearsals/rollback; do
 echo "--- $m $p"
 curl $P -X $m -H 'Content-Type: application/json' -d '{}' "$B$p" -w '\n[%{http_code}]\n' | head -c 800; echo
done
done
echo "## route candidates GET"
for p in /api/fieldlink/readings /api/fieldlink/readings/current /api/fieldlink/process /api/fieldlink/process/current /api/fieldlink/process-data /api/fieldlink/observations /api/fieldlink/observations/current /api/fieldlink/planning /api/fieldlink/planning/current /api/fieldlink/allocation /api/fieldlink/allocation/current /api/fieldlink/ledger /api/fieldlink/ledger/current /api/fieldlink/meter /api/fieldlink/meter/export /api/fieldlink/meters /api/fieldlink/exports /api/fieldlink/exports/current /api/fieldlink/customers /api/fieldlink/customers/TEN-ARWC-047 /api/fieldlink/tenants/TEN-ARWC-047 /api/fieldlink/asset/CRR-OG2 /api/fieldlink/assets/CRR-OG2 /api/fieldlink/districts /api/fieldlink/reserve /api/fieldlink/reports /api/fieldlink/reports/current /api/fieldlink/integration /api/fieldlink/integrations /api/fieldlink/contracts /api/fieldlink/schema /api/fieldlink/health /api/fieldlink/status /api/fieldlink/version /api/fieldlink/.well-known/fieldkest-client; do
  code=$(curl $P -o /tmp/x -w '%{http_code}' "$B$p")
  if [ "$code" != "404" ]; then echo "FOUND $code $p"; head -c 600 /tmp/x; echo; fi
done
echo "## route candidates POST"
for p in /api/fieldlink/readings /api/fieldlink/readings/current /api/fieldlink/process/read /api/fieldlink/observations /api/fieldlink/planning/query /api/fieldlink/ledger/query /api/fieldlink/meter/export /api/fieldlink/exports /api/fieldlink/reports /api/fieldlink/integrations; do
  for m in POST PUT; do
  code=$(curl $P -X $m -H 'Content-Type: application/json' -d '{}' -o /tmp/x -w '%{http_code}' "$B$p")
  if [ "$code" != "404" ]; then echo "FOUND $m $code $p"; head -c 600 /tmp/x; echo; fi
  done
done
echo DONE_A4
