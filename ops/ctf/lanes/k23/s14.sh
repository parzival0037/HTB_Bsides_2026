#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
K="-k -sS -m 30"
B="Authorization: Bearer fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b"
U=https://support.keplerops.test:8443
echo "== well-known full"
curl $K $P -H "$B" $U/.well-known/fieldkest-client | python3 -m json.tool
echo "== handover current"
curl $K $P -H "$B" $U/api/handovers/current -w "\n[%{http_code}]\n" | head -c 6000
echo; echo "== customers / handovers list"
for u in /api/handovers /api/customers /api/customers/arwc /api/customers/arwc/diagnostics /api/customers/arwc/handovers; do
 echo "-- $u"; curl $K $P -H "$B" "$U$u" -w "\n[%{http_code}]\n" | head -c 800; echo
done
