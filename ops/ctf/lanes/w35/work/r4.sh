#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
C="curl -sS $P -k --max-time 60"
TOK=fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo
B="https://source.keplerops.test/api/v1/repos/fieldkest/connector-archive/raw"
mkdir -p /tmp/ca
$C -u "rowan.ito:$TOK" "$B/bin/fieldlink-connector?ref=main" -o /tmp/ca/bin
$C -u "rowan.ito:$TOK" "$B/maps/fieldlink-connector-6.9.8.map?ref=main" -o /tmp/ca/map
$C -u "rowan.ito:$TOK" "$B/config/diagnostic.conf?ref=main" -o /tmp/ca/diag.conf
$C -u "rowan.ito:$TOK" "$B/config/ordinary.conf?ref=main" -o /tmp/ca/ord.conf
$C -u "rowan.ito:$TOK" "$B/README.md?ref=main" -o /tmp/ca/README.md
$C -u "rowan.ito:$TOK" "$B/notes/retained-diagnostic.md?ref=main" -o /tmp/ca/notes.md
ls -la /tmp/ca; echo ---README; cat /tmp/ca/README.md; echo ---CONF; cat /tmp/ca/diag.conf /tmp/ca/ord.conf; echo ---NOTES; cat /tmp/ca/notes.md
echo "===== grep keywords in binary/map ====="
for f in /tmp/ca/bin /tmp/ca/map; do
  echo "### $f"
  grep -aoiE '.{40}(supply|procurement|district|quote|budget|replacement|price catalog|catalog).{60}' "$f" | head -40
done
echo "===== channel identities / routes in map ====="
grep -aoiE 'channel[_a-z]*|route_not_found|/api/[a-z0-9/_.-]+' /tmp/ca/map | sort -u | head -100
