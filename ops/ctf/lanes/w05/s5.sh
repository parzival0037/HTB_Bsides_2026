#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
for h in staff tickets preview workloads cloud-api assistant review indexer; do
  echo "################ $h"
  curl -sS $P -k -m 15 "https://$h.keplerops.test/.well-known/fieldkest-client" | python3 -m json.tool 2>/dev/null || curl -sS $P -k -m 15 "https://$h.keplerops.test/.well-known/fieldkest-client"
done
echo "################ support:8443"
curl -sS $P -k -m 15 "https://support.keplerops.test:8443/.well-known/fieldkest-client" | python3 -m json.tool
