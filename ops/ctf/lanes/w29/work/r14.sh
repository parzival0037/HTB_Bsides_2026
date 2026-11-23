#!/bin/bash
set +e
P="--socks5-hostname 127.0.0.1:1080 -k -sS -m 15"
for u in https://data.keplerops.test/.well-known/fieldkest-client https://workloads.keplerops.test/.well-known/fieldkest-client https://cloud-api.keplerops.test/.well-known/fieldkest-client https://delivery.keplerops.test:8443/.well-known/fieldkest-client https://staff.keplerops.test/.well-known/fieldkest-client https://support.keplerops.test/.well-known/fieldkest-client; do
 echo "########## $u"
 curl $P "$u" | python3 -m json.tool 2>/dev/null | head -120
done
echo DONE_R14
