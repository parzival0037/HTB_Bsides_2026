#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
for u in \
 https://support.keplerops.test:8443/.well-known/fieldkest-client \
 https://delivery.keplerops.test:8443/.well-known/fieldkest-client \
 https://review.keplerops.test/.well-known/fieldkest-client \
 https://source-tools.keplerops.test:8443/.well-known/fieldkest-client \
 https://support.keplerops.test/.well-known/fieldkest-client \
 https://connector.arwc.test/.well-known/fieldkest-client ; do
 echo "##### $u"
 curl -sS -m 15 $P -k "$u" 2>&1 | head -c 3000; echo
done
