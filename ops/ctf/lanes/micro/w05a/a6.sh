#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080 -k -m 10"
B="Authorization: Bearer fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b"
words="starter-pack starterpacks starter-packs starters onboarding onboardings staff staff-pack employees employee roster rosters activation activations directory people person new-hire new-hires temp temporary assignments assignment hr cases handovers diagnostics customers customer tenants users accounts"
for host in support.keplerops.test:8443 delivery.keplerops.test:8443; do
echo "##### $host"
for w in $words; do
 for pre in "/api/$w" "/api/customers/TEN-ARWC-047/$w" "/api/customers/CRR-OG2/$w"; do
  code=$(curl -sS $P -H "$B" -o /tmp/fz -w '%{http_code}' "https://$host$pre")
  [ "$code" != "404" ] && echo "[$code] $pre :: $(head -c 200 /tmp/fz | tr -d '\n')"
 done
done
done
