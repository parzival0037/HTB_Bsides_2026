#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
T="Authorization: Bearer fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"
B=https://staff.keplerops.test
g(){ echo "===== $1"; curl -sS $P -k -m 20 -H "$T" -i "$1" | head -c 2500; echo; }
echo "###### service-directory"; curl -sS $P -k -m 20 -H "$T" "$B/api/service-directory" | python3 -m json.tool
for t in StaffArchiveUser staff-archive-user archive StaffOnboard onboard onboarding Onboarding temp Temporary contractor fieldtech FieldTechnician; do
  echo "###### enrollment/$t"; curl -sS $P -k -m 15 -H "$T" -w ' [%{http_code}]' "$B/api/enrollment/$t" | head -c 1200; echo
done
