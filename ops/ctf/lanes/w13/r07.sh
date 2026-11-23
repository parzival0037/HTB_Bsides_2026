#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
B=https://connector.arwc.test
probe(){ echo "--- $1 $2"; shift 2; curl -sS -m 15 $P -k -i "$@" 2>&1 | head -20; }
probe GET "$B/api/fieldlink/packages/poll"
probe POST "$B/api/fieldlink/packages/poll" -X POST -H 'Content-Type: application/json' -d '{}'
probe POST "$B/api/fieldlink/rehearsals/rollback" -X POST -H 'Content-Type: application/json' -d '{}'
probe GET "$B/api/fieldlink/packages/7.4.2/receipt"
probe POST "$B/api/fieldlink/packages/7.4.2/activate" -X POST -H 'Content-Type: application/json' -d '{}'
echo "### auth header variants on poll"
for h in "Authorization: Bearer fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b" "X-FieldKest-Integration: fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b" "X-Integration-Token: fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b" "Cookie: fieldkest_support=fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b" "Authorization: Integration fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b"; do
 echo "--- $h"
 curl -sS -m 15 $P -k -X POST -H 'Content-Type: application/json' -H "$h" -d '{}' -w '\n[%{http_code}]\n' "$B/api/fieldlink/packages/poll" 2>&1 | head -10
done
