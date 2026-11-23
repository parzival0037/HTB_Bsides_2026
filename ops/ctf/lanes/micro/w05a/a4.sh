#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080 -k -m 15"
G=https://source.keplerops.test
A="-u rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"
echo "===== gitea repo search"
for q in vale starter onboarding arwc roster activation; do
 echo "--- $q"; curl -sS $P $A "$G/api/v1/repos/search?q=$q&limit=20" | head -c 800; echo
done
echo "===== gitea public repos"
curl -sS $P -w '\n[%{http_code}]\n' "$G/api/v1/repos/search?limit=50" | head -c 2500; echo
echo "===== gitea users"
curl -sS $P $A "$G/api/v1/users/search?q=mira" | head -c 500; echo
echo "===== S3 buckets"
for b in arwc arwc-starter arwc-starter-pack arwc-onboarding arwc-staff arwc-hr arwc-people arwc-roster starter-packs starterpack onboarding fieldkest-starters fieldkest-onboarding fieldlink-starters mira mira-vale mira.vale staff hr people identity directory; do
  code=$(curl -sS $P -o /tmp/s3 -w '%{http_code}' "https://objects.keplerops.test/$b?list-type=2")
  sz=$(stat -c%s /tmp/s3)
  echo "[$code] $b $sz $(head -c 120 /tmp/s3 | tr -d '\n')"
done
