#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
C="curl -sS $P -k --max-time 30"
TOK=fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo
echo "===== support-rehearsal metadata 443 ====="
$C -u "rowan.ito:$TOK" "https://packages.keplerops.test/@keplerops%2fsupport-rehearsal" -w '\n%{http_code}\n' | head -c 3000
echo "===== support-rehearsal metadata 8443 ====="
$C -u "rowan.ito:$TOK" "https://packages.keplerops.test:8443/@keplerops%2fsupport-rehearsal" -w '\n%{http_code}\n' | head -c 3000
echo "===== npm search arwc/supply ====="
for q in arwc supply water procurement district; do echo "--- $q"; $C -u "rowan.ito:$TOK" "https://packages.keplerops.test/-/v1/search?text=$q&size=20" | head -c 1500; echo; done
echo "===== workboard root/paths ====="
for u in / /api /api/service-directory /api/boards /api/work /health; do printf '%s -> ' "$u"; $C -o /tmp/w.out -w '%{http_code} ' "https://workboard.keplerops.test$u"; head -c 250 /tmp/w.out; echo; done
