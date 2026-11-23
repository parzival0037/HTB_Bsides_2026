#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080 -k -sS --max-time 25"
SUP="fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b"
S=https://support.keplerops.test:8443
echo "===== handover current"; curl $P -H "Authorization: Bearer $SUP" "$S/api/handovers/current" | head -c 2000; echo
for T in TEN-ARWC-047 TEN-ARWC-019; do
 echo "##### create $T"
 J=$(curl $P -H "Authorization: Bearer $SUP" -H 'Content-Type: application/json' -d '{"connector_revision":"FLK-7.4.2"}' "$S/api/customers/$T/diagnostics")
 echo "$J"
 JID=$(echo "$J" | python3 -c "import sys,json;print(json.load(sys.stdin).get('job_id',''))" 2>/dev/null)
 echo "--- read $JID"
 curl $P -H "Authorization: Bearer $SUP" "$S/api/diagnostics/$JID" | head -c 3000; echo
done
echo "===== diagnostics list guess"
for p in /api/diagnostics /api/customers/TEN-ARWC-047 /api/customers/TEN-ARWC-047/records /api/customers/TEN-ARWC-047/attachment /api/customers/TEN-ARWC-047/dossier; do
 echo "### $p"; curl $P -H "Authorization: Bearer $SUP" -o /tmp/o -w '[%{http_code}] ' "$S$p"; head -c 800 /tmp/o; echo
done
