#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
echo "== pivot check"
curl -sS $P -k -m 15 https://source.keplerops.test/api/v1/version; echo
echo "== connector.arwc.test root"
curl -sS $P -k -m 15 -i https://connector.arwc.test/ | head -40
echo "== connector well-known"
for p in .well-known/fieldkest-client .well-known/security.txt robots.txt api health; do
  echo "--- $p"; curl -sS $P -k -m 12 -i "https://connector.arwc.test/$p" | head -25
done
