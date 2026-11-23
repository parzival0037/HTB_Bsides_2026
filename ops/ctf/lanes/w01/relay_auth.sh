#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
B="https://connector.arwc.test/api/fieldlink/packages/poll"
t(){ desc="$1"; shift; code=$(curl -sS $P -k --max-time 8 -o /tmp/ra -w '%{http_code}' -X POST "$B" "$@" 2>/dev/null); echo "$code [$desc] $(head -c 200 /tmp/ra | tr -d '\n')"; }
t "none"
t "X-Channel arwc-stable" -H 'X-Channel: arwc-stable'
t "X-Channel-Id" -H 'X-Channel-Id: arwc-stable'
t "X-FieldKest-Channel" -H 'X-FieldKest-Channel: arwc-stable'
t "X-Tenant TEN-ARWC-047" -H 'X-Tenant: TEN-ARWC-047'
t "X-Customer" -H 'X-Customer: TEN-ARWC-047'
t "Bearer TEN" -H 'Authorization: Bearer TEN-ARWC-047'
t "Bearer arwc-stable" -H 'Authorization: Bearer arwc-stable'
t "body tenant" -H 'Content-Type: application/json' -d '{"tenant_id":"TEN-ARWC-047"}'
t "body channel" -H 'Content-Type: application/json' -d '{"channel":"arwc-stable"}'
t "body both" -H 'Content-Type: application/json' -d '{"tenant_id":"TEN-ARWC-047","channel":"arwc-stable"}'
t "body conn rev" -H 'Content-Type: application/json' -d '{"connector_revision":"FLK-7.4.2"}'
t "body all" -H 'Content-Type: application/json' -d '{"tenant_id":"TEN-ARWC-047","channel":"arwc-stable","connector_revision":"FLK-7.4.2","asset_id":"CRR-OG2"}'
echo "### GET receipt with headers"
for h in "X-Channel: arwc-stable" "X-Tenant: TEN-ARWC-047" "Authorization: Bearer TEN-ARWC-047"; do
 code=$(curl -sS $P -k --max-time 8 -o /tmp/ra -w '%{http_code}' -H "$h" "https://connector.arwc.test/api/fieldlink/packages/7.4.2/receipt"); echo "$code [$h] $(head -c 200 /tmp/ra|tr -d '\n')"
done
rm -f /tmp/ra
