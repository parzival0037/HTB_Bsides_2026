#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080 -k -m 15"
for h in data.keplerops.test workloads.keplerops.test staff.keplerops.test objects.keplerops.test workboard.keplerops.test identity.keplerops.test cert.keplerops.test; do
  echo "===== $h"
  for path in /.well-known/fieldkest-client /.well-known/fieldkest /api; do
    printf "%-32s " "$path"
    curl -sS $P -o /tmp/wk -w '%{http_code} %{size_download} ' "https://$h$path"
    head -c 300 /tmp/wk | tr -d '\n'; echo
  done
done
