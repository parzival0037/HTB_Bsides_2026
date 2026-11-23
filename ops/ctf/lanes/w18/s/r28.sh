#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080 -k -sS --max-time 20"
U=rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo
for h in support.keplerops.test:8443 staff.keplerops.test workboard.keplerops.test review.keplerops.test indexer.keplerops.test id.keplerops.test identity.keplerops.test cert.keplerops.test ca.keplerops.test data.keplerops.test tickets.keplerops.test objects.keplerops.test source.keplerops.test delivery.keplerops.test:8443; do
 echo "################ $h"
 curl $P -u "$U" -w '\n[%{http_code}]\n' "https://$h/.well-known/fieldkest-client" 2>/dev/null | head -c 4000
 echo
done
