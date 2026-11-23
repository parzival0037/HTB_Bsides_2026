#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
B="https://connector.arwc.test"
t(){ echo "--- $1"; curl -sS $P -k --max-time 8 -o /tmp/t.$$ -w '%{http_code} ' -X ${2:-GET} "$B$1"; head -c 400 /tmp/t.$$; echo; }
echo "== known route check"
t /api/fieldlink/packages/poll POST
echo "== Host header routing"
for h in portal.arwc.test docs.arwc.test records.arwc.test planning.arwc.test; do
  echo "--- Host: $h"; curl -sS $P -k --max-time 8 -H "Host: $h" -o /tmp/t.$$ -w '%{http_code} ' "$B/"; head -c 300 /tmp/t.$$; echo
done
echo "== path fuzz"
for p in api api/ api/v1 healthz health status info about docs doc documents document register registers records record archive archives handover handovers handback supplier suppliers supplier-documents planning plan plans procurement purchasing purchase purchases supply water water-supply inspection inspections appointment appointments gate access checkin check-in outlet reports report cairn cairnreach maintenance maintenance-cases cases case fieldlink fieldkest portal portal/ app login auth session sessions admin internal files file download upload search query; do
  code=$(curl -sS $P -k --max-time 6 -o /tmp/t.$$ -w '%{http_code}' "$B/$p" 2>/dev/null)
  body=$(head -c 120 /tmp/t.$$ | tr -d '\n')
  [ "$code" != "404" ] && echo "$code /$p -> $body"
done
rm -f /tmp/t.$$
