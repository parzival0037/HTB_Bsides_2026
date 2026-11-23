#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
T='fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b'
E=https://10.77.51.60
for h in portal docs planning supply inspection inspections appointment appointments gate access checkin check-in outlet outlets water reports api cairn cairnreach app records roster contractor contractors crew visitor visitors booking bookings schedule schedules maintenance field site ops reception security gatehouse admin staff hr hse permits permit induction signin sign-in lobby reservation reservations calendar workorder work-order asset assets plant scada hmi historian fuxa opcua plc connector cairnreach portal2 guest compliance audit; do
  out=$(curl -sS -m 8 $P -k -H "Host: $h.arwc.test" -H "Authorization: Bearer $T" -w '|%{http_code}' "$E/" 2>/dev/null)
  code=${out##*|}; body=${out%|*}
  if [ "$code" != "404" ] || [ "$body" != '{"error":"not_found"}' ]; then
    echo "HIT $h.arwc.test -> $code $body"
  fi
done
echo "=== well-known on all candidates ==="
for h in portal docs planning supply inspection appointment gate access checkin outlet water reports cairn cairnreach app records roster contractor crew visitor booking schedule maintenance field site ops reception security gatehouse; do
  out=$(curl -sS -m 8 $P -k -H "Host: $h.arwc.test" -H "Authorization: Bearer $T" -w '|%{http_code}' "$E/.well-known/fieldkest-client" 2>/dev/null)
  code=${out##*|}; body=${out%|*}
  echo "$h -> $code ${body:0:120}"
done
