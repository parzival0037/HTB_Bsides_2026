#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
B="https://connector.arwc.test"
paths="api api/ api/v1 api/fieldlink api/fieldlink/ api/fieldlink/packages api/fieldlink/identity api/fieldlink/channel api/fieldlink/channels api/fieldlink/handover api/fieldlink/receipt api/handover api/handovers api/documents api/document api/records api/inspections api/planning api/procurement api/purchasing api/suppliers api/customer api/cairos api/cairn api/cairn-reach api/outlet api/water api/plants api/maintenance api/cases api/work api/tasks api/orders api/contracts api/assets api/gate api/appointments api/roster api/access api/checkin api/scada api/historian api/telemetry static static/app.js assets robots.txt sitemap.xml .well-known openapi.json swagger.json docs docs/ index.html fieldlink fieldlink/ relay relay/ customer customer/ arwc arwc/ app app/ portal portal/ handover handover/ plant plant/ outlet outlet/ gate gate/ supply supply/ planning planning/ procurement procurement/ v1 v1/ ping healthz info version metrics debug routes"
for p in $paths; do
  for m in GET POST; do
    code=$(curl -sS $P -k --max-time 6 -o /tmp/rp -w '%{http_code}' -X $m "https://connector.arwc.test/$p" 2>/dev/null)
    body=$(head -c 140 /tmp/rp | tr -d '\n')
    [ "$code" != "404" ] && echo "[$m] $code /$p -> $body"
  done
done
rm -f /tmp/rp
