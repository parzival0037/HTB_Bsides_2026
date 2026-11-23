#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080 -k -m 12"
DEV="-u rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"
B="Authorization: Bearer fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b"
echo "== delivery with dev basic"
curl -sS $P $DEV -w '\n[%{http_code}]\n' https://delivery.keplerops.test:8443/api/package-meta/fieldlink-connector | head -c 600; echo
echo "== npm exact names"
for n in @keplerops%2fstarter-pack @keplerops%2fstarter-pack-connector @keplerops%2fsupport-rehearsal @keplerops%2fonboarding @keplerops%2ffieldlink-starter @fieldkest%2fstarter-pack; do
 printf "%-46s " "$n"; curl -sS $P $DEV -o /tmp/np -w '%{http_code} ' "https://packages.keplerops.test/$n"; head -c 200 /tmp/np|tr -d '\n'; echo
done
echo "== cloud-api token-exchange GET (bearer + dev)"
for opt in "$B" "$DEV"; do curl -sS $P ${opt:+-H "$B"} -w '\n[%{http_code}]\n' https://cloud-api.keplerops.test/api/workspaces/current/token-exchange | head -c 600; echo; break; done
curl -sS $P $DEV -w '\n[%{http_code}]\n' https://cloud-api.keplerops.test/api/workspaces/current/token-exchange | head -c 600; echo
