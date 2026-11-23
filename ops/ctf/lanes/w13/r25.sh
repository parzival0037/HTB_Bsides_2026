#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
T='fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b'
B="https://10.77.50.11:8443"
for h in hmi fuxa arwc connector appointment appointments gate checkin check-in access roster inspection outlet cairn historian plant; do
 for auth in "" "Authorization: Bearer $T"; do
   out=$(curl -sS -m 8 $P -k -H "Host: $h.arwc.test" ${auth:+-H "$auth"} -w '|%{http_code}' "$B/.well-known/fieldkest-client" 2>/dev/null)
   c=${out##*|}; b=${out%|*}
   [ "$b" != '{"error":"client_reference_not_found"}' ] && echo "WK $h [$auth] -> $c $b"
   out2=$(curl -sS -m 8 $P -k -H "Host: $h.arwc.test" ${auth:+-H "$auth"} -w '|%{http_code}' "$B/api/version" 2>/dev/null)
   c2=${out2##*|}; b2=${out2%|*}
   [ "$c2" != "404" ] && echo "VER $h [$auth] -> $c2 $b2"
 done
done
echo "=== paths on fuxa/hmi with token ==="
for h in fuxa hmi; do
 for u in /fuxa /fuxa/ /api/project /api/projects /api/auth /api/settings /api/version /socket.io/ /index.html /api; do
  out=$(curl -sS -m 8 $P -k -H "Host: $h.arwc.test" -H "Authorization: Bearer $T" -w '|%{http_code}' "$B$u" 2>/dev/null)
  c=${out##*|}; b=${out%|*}
  echo "$h$u -> $c ${b:0:90}"
 done
done
