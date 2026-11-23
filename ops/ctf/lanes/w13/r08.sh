#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
SUP='fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b'
U='rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo'
get(){ echo "--- $1"; shift; curl -sS -m 20 $P -k -i "$@" 2>&1 | head -30; }
get "delivery meta" https://delivery.keplerops.test:8443/api/package-meta/fieldlink-connector -u "$U"
get "delivery releases" https://delivery.keplerops.test:8443/api/releases/FLK-7.4.2 -u "$U"
get "support handovers current bearer" https://support.keplerops.test:8443/api/handovers/current -H "Authorization: Bearer $SUP"
get "support handovers current basic" https://support.keplerops.test:8443/api/handovers/current -u "$U"
echo "=== create diagnostic job for ARWC tenants ==="
for t in TEN-ARWC-047 TEN-ARWC-019 ARWC; do
 echo "--- $t"
 curl -sS -m 25 $P -k -X POST -H "Authorization: Bearer $SUP" -H 'Content-Type: application/json' -d '{"connector_revision":"FLK-7.4.2"}' -w '\n[%{http_code}]\n' "https://support.keplerops.test:8443/api/customers/$t/diagnostics" 2>&1 | head -30
done
get "staff service-directory" https://staff.keplerops.test/api/service-directory -H "Authorization: Bearer $SUP"
