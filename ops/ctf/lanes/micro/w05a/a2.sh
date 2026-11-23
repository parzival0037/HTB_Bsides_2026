#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080 -k -m 25"
B="Authorization: Bearer fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b"
DEV="-u rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"
echo "===== indexer well-known"
curl -sS $P -w '\n[%{http_code}]\n' https://indexer.keplerops.test/.well-known/fieldkest-client | head -c 4000; echo
echo "===== cloud-api well-known"
curl -sS $P -w '\n[%{http_code}]\n' https://cloud-api.keplerops.test/.well-known/fieldkest-client | head -c 4000; echo
echo "===== delivery inspections GET"
curl -sS $P -H "$B" -w '\n[%{http_code}]\n' https://delivery.keplerops.test:8443/api/inspections | head -c 3000; echo
echo "===== delivery inspections POST empty"
curl -sS $P -H "$B" -X POST -H 'Content-Type: application/json' -d '{}' -w '\n[%{http_code}]\n' https://delivery.keplerops.test:8443/api/inspections | head -c 2000; echo
echo "===== osTicket KB"
curl -sS $P -H "$B" -w '\n[%{http_code}]\n' https://support.keplerops.test/kb/faq.php | head -c 2000; echo
echo "===== osTicket public search vale"
curl -sS $P -w '\n[%{http_code}]\n' "https://support.keplerops.test/kb/faq.php?cid=1" | head -c 1500; echo
