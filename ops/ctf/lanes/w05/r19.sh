#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
echo "###### npm search"
for u in "https://packages.keplerops.test/-/v1/search?text=arwc&size=50" "https://packages.keplerops.test/-/v1/search?text=starter&size=50" "https://packages.keplerops.test/-/v1/search?text=onboard&size=50" "https://packages.keplerops.test/-/all"; do
  echo "--- $u"; curl -sS $P -k -m 15 "$u" | head -c 1200; echo
done
echo "###### s3 bucket probes"
for b in arwc arwc-starter arwc-starter-pack arwc-onboarding arwc-staff arwc-hr arwc-records fieldlink-exports arwc-internal arwc-portal starter-packs onboarding staff; do
  code=$(curl -sS $P -k -m 10 -o /tmp/b.$$ -w '%{http_code}' "https://objects.keplerops.test/$b")
  echo "[$code] $b :: $(head -c 120 /tmp/b.$$ | tr -d '\n')"
done
echo "###### gitea"
T="Authorization: token fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"
for u in "https://source.keplerops.test/api/v1/repos/search?limit=50" "https://source.keplerops.test/api/v1/orgs" "https://source.keplerops.test/api/v1/user/repos?limit=50"; do
  echo "--- $u"; curl -sS $P -k -m 15 -H "$T" -w ' [%{http_code}]' "$u" | head -c 1500; echo
done
rm -f /tmp/b.$$
