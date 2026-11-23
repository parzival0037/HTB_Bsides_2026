#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
T='fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b'
E=https://10.77.51.60
words="appointment appointments booking bookings reservation reservations visitor visitors visit roster rosters access checkin check-in checkins check_in gate gates pass passes badge badges crew crews contractor contractors assignment assignments inspection inspections inspect outlet outlets maintenance reference references session sessions identity identities staff people person contacts companies sites site permit permits qr codes code token tokens auth login logout whoami profile me dashboard admin config settings health status version docs api v1 field ops schedule schedules calendar event events work order orders job jobs task tasks report reports asset assets plant water supply"
for w in $words; do
  for p in "/api/$w" "/$w" "/api/v1/$w"; do
    out=$(curl -sS -m 6 $P -k -H "Authorization: Bearer $T" -w '|%{http_code}' "$E$p" 2>/dev/null)
    code=${out##*|}; body=${out%|*}
    if [ "$code" != "404" ]; then echo "GET $p -> $code $body"; fi
  done
  for p in "/api/$w"; do
    out=$(curl -sS -m 6 $P -k -X POST -H "Authorization: Bearer $T" -H 'Content-Type: application/json' -d '{}' -w '|%{http_code}' "$E$p" 2>/dev/null)
    code=${out##*|}; body=${out%|*}
    if [ "$code" != "404" ]; then echo "POST $p -> $code $body"; fi
  done
done
