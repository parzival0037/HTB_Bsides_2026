#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
T="Authorization: Bearer fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"
B=https://staff.keplerops.test
for t in StaffArchiveUser TemporaryEmployee TempEmployee TempStaff ARWCStaff ARWCEmployee FieldContractor Contractor FieldStaff FieldEmployee NewStarter Starter TemporaryAccess Employee StaffUser FieldTechnician MiraVale; do
  c=$(curl -sS $P -k -m 10 -H "$T" -o /tmp/s.$$ -w '%{http_code}' "$B/api/enrollment/$t")
  [ "$c" = "200" ] && echo "[$c] $t :: $(head -c 300 /tmp/s.$$|tr -d '\n')"
done
echo "--- requests endpoints"
for u in "/api/enrollment/StaffArchiveUser/requests" "/api/enrollments" "/api/enrollment/templates" "/api/managed-identities" "/api/archive/handovers/evan.calderoux@keplerops.test" "/api/archive/handovers/mira.vale@arwc.test"; do
  echo "### $u"; curl -sS $P -k -m 12 -H "$T" -w ' [%{http_code}]' "$B$u" | head -c 400; echo
done
rm -f /tmp/s.$$
