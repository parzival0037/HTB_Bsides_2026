#!/bin/bash
CA=$HOME/k25/ca.crt
P="--socks5-hostname 127.0.0.1:1080 -sS -m 20 --cacert $CA"
for h in preview.keplerops.test indexer.keplerops.test connector.arwc.test review.keplerops.test support.keplerops.test cloud-api.keplerops.test source.keplerops.test; do
  echo "===== $h"
  for schema in https http; do
    echo "--- $schema://$h/"
    curl $P "$schema://$h/" -D - -o /tmp/body.$$ 2>&1 | head -8
    head -c 400 /tmp/body.$$; echo
    echo "--- $schema://$h/.well-known/fieldkest-client"
    curl $P "$schema://$h/.well-known/fieldkest-client" -m 10 2>&1 | head -c 800; echo
  done
done
echo "===== 10.77.50.11 root"
curl $P https://10.77.50.11/ -D - -o /dev/null 2>&1 | head -8
echo "===== 10.77.60.20 root"
curl $P https://10.77.60.20/ -D - -o /dev/null 2>&1 | head -8
