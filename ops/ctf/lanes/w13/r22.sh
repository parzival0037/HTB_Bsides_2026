#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
T='fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b'
B="https://10.77.50.11:8443"
hosts="hmi fuxa nfuxa nhmi portal appointment appointments gate access checkin check-in roster inspection outlet connector arwc cairn cairnreach historian plant scada opcua plc water records"
for h in $hosts; do
  o1=$(curl -sS -m 8 $P -k -H "Host: $h.arwc.test" -w '|%{http_code}' "$B/" 2>/dev/null)
  c1=${o1##*|}; b1=${o1%|*}
  o2=$(curl -sS -m 8 $P -k -H "Host: $h.arwc.test" -H "Authorization: Bearer $T" -w '|%{http_code}' "$B/" 2>/dev/null)
  c2=${o2##*|}; b2=${o2%|*}
  o3=$(curl -sS -m 8 $P -k -H "Host: $h.arwc.test" -H "Cookie: fieldkest_support=$T" -w '|%{http_code}' "$B/" 2>/dev/null)
  c3=${o3##*|}; b3=${o3%|*}
  echo "$h.arwc.test: noauth=$c1 ${b1:0:60} | bearer=$c2 ${b2:0:80} | cookie=$c3 ${b3:0:80}"
done
