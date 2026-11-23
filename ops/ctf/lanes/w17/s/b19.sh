#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
for h in cloud-api.keplerops.test workloads.keplerops.test workload.keplerops.test indexer.keplerops.test foundation.keplerops.test edge.keplerops.test; do
 echo "##### $h"
 curl -sS $P -m 10 -k "https://$h/.well-known/fieldkest-client" -o /tmp/o -w "[%{http_code}]\n"; head -c 3000 /tmp/o; echo
done
echo "##### cloud-api root"
curl -sS $P -m 10 -k https://cloud-api.keplerops.test/ -o /tmp/o -w "[%{http_code}]\n"; head -c 1000 /tmp/o; echo
