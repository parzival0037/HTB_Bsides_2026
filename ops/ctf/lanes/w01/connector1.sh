#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
B=https://connector.arwc.test
req(){ echo "===== $1 $2"; shift 2; curl -sS $P -k --max-time 15 -i -X "$REQM" "$B$REQP" "${@}" | head -c 1200; echo; }
echo "### receipt 7.4.2"; curl -sS $P -k --max-time 15 -i "$B/api/fieldlink/packages/7.4.2/receipt" | head -c 1500; echo
echo "### receipt 7.4.1"; curl -sS $P -k --max-time 15 -i "$B/api/fieldlink/packages/7.4.1/receipt" | head -c 1200; echo
echo "### receipt 6.9.8"; curl -sS $P -k --max-time 15 -i "$B/api/fieldlink/packages/6.9.8/receipt" | head -c 1200; echo
echo "### poll POST {}"; curl -sS $P -k --max-time 15 -i -X POST -H 'Content-Type: application/json' -d '{}' "$B/api/fieldlink/packages/poll" | head -c 1500; echo
echo "### poll GET"; curl -sS $P -k --max-time 15 -i "$B/api/fieldlink/packages/poll" | head -c 600; echo
echo "### activate GET"; curl -sS $P -k --max-time 15 -i "$B/api/fieldlink/packages/7.4.2/activate" | head -c 600; echo
echo "### packages GET"; curl -sS $P -k --max-time 15 -i "$B/api/fieldlink/packages" | head -c 600; echo
echo "### fieldlink GET"; curl -sS $P -k --max-time 15 -i "$B/api/fieldlink" | head -c 600; echo
echo "### fieldlink slash"; curl -sS $P -k --max-time 15 -i "$B/api/fieldlink/" | head -c 600; echo
echo "### OPTIONS poll"; curl -sS $P -k --max-time 15 -i -X OPTIONS "$B/api/fieldlink/packages/poll" | head -c 600; echo
