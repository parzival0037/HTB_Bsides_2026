#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080 -k -sS --max-time 20"
SUP="fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b"
for H in hmi.arwc.test fuxa.arwc.test arwc.test connector.arwc.test historian.arwc.test plc.arwc.test; do
 echo "########## Host: $H"
 for p in /.well-known/fieldkest-client /.well-known/fieldkest-client/ /api /health /version /api/version /api/status /status; do
   printf '%-34s ' "$p"
   curl $P -o /tmp/o -w '[%{http_code}] ' -H "Host: $H" -H "Authorization: Bearer $SUP" "https://10.77.50.11:8443$p"
   head -c 600 /tmp/o; echo
 done
done
