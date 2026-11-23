#!/bin/bash
set +e
P="--socks5-hostname 127.0.0.1:1080 -k -sS -m 12"
A="rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"
B=https://staff.keplerops.test
echo "## directory anon"
curl $P "$B/api/service-directory" -w '\n[%{http_code}]\n'
echo "## directory basic"
curl $P -u "$A" "$B/api/service-directory" -w '\n[%{http_code}]\n'
echo "## directory cookie support"
curl $P -H 'Cookie: fieldkest_support=fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b' "$B/api/service-directory" -w '\n[%{http_code}]\n'
echo "## workboard wellknown"
curl $P "https://workboard.keplerops.test/.well-known/fieldkest-client" -w '\n[%{http_code}]\n'
echo "## tickets wellknown"
curl $P "https://tickets.keplerops.test/.well-known/fieldkest-client" -w '\n[%{http_code}]\n'
echo "## registry wellknown"
curl $P "https://registry.keplerops.test/.well-known/fieldkest-client" -w '\n[%{http_code}]\n'
echo DONE_A10
