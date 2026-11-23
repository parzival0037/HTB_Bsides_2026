#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080 -k -m 25"
B="Authorization: Bearer fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b"
echo "===== support well-known"
curl -sS $P -H "$B" -w '\n[%{http_code}]\n' https://support.keplerops.test:8443/.well-known/fieldkest-client | head -c 4000; echo
echo "===== delivery well-known"
curl -sS $P -H "$B" -w '\n[%{http_code}]\n' https://delivery.keplerops.test:8443/.well-known/fieldkest-client | head -c 4000; echo
echo "===== handovers/current"
curl -sS $P -H "$B" -w '\n[%{http_code}]\n' https://support.keplerops.test:8443/api/handovers/current | head -c 4000; echo
echo "===== package-meta"
curl -sS $P -H "$B" -w '\n[%{http_code}]\n' https://delivery.keplerops.test:8443/api/package-meta/fieldlink-connector | head -c 4000; echo
echo "===== diagnostics ARWC"
curl -sS $P -H "$B" -w '\n[%{http_code}]\n' https://support.keplerops.test:8443/api/customers/TEN-ARWC-047/diagnostics | head -c 4000; echo
echo "===== support root"
curl -sS $P -H "$B" -w '\n[%{http_code}]\n' https://support.keplerops.test:8443/ | head -c 2000; echo
