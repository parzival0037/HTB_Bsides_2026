#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
for u in https://source-tools.keplerops.test:8443/.well-known/fieldkest-client https://review.keplerops.test/.well-known/fieldkest-client https://delivery.keplerops.test:8443/.well-known/fieldkest-client https://support.keplerops.test/.well-known/fieldkest-client https://connector.arwc.test/.well-known/fieldkest-client; do
  echo "########## $u"
  curl -sS $P -k --max-time 20 "$u" | python3 -m json.tool 2>/dev/null || curl -sS $P -k --max-time 20 "$u"
  echo
done
