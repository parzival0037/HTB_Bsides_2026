#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080 -k -sS --max-time 20"
for U in \
 https://delivery.keplerops.test:8443/.well-known/fieldkest-client \
 https://workloads.keplerops.test/.well-known/fieldkest-client \
 https://data.keplerops.test/.well-known/fieldkest-client \
 https://support.keplerops.test/.well-known/fieldkest-client \
 https://support.keplerops.test:8443/.well-known/fieldkest-client \
 https://staff.keplerops.test/.well-known/fieldkest-client \
 https://source-tools.keplerops.test:8443/.well-known/fieldkest-client \
 https://review.keplerops.test/.well-known/fieldkest-client \
 https://preview.keplerops.test/.well-known/fieldkest-client \
 https://indexer.keplerops.test/.well-known/fieldkest-client \
 https://assistant.keplerops.test/.well-known/fieldkest-client \
 https://tickets.keplerops.test/.well-known/fieldkest-client \
 https://workboard.keplerops.test/.well-known/fieldkest-client \
 https://cert.keplerops.test/.well-known/fieldkest-client \
 https://ca.keplerops.test/.well-known/fieldkest-client \
 https://connector.arwc.test/.well-known/fieldkest-client \
 https://connector.arwc.test/.well-known/arwc-client \
 https://hmi.arwc.test/.well-known/fieldkest-client ; do
  echo "########## $U"
  curl $P -m 10 "$U" -o /tmp/o -w '[%{http_code}]\n' 2>&1
  head -c 3000 /tmp/o; echo
done
