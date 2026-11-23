#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
T='fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b'
E=https://10.77.51.60
CK="Cookie: fieldkest_support=$T"
paths="api/session api/assignments api/assignments/ASMT-SUP-2841 api/assignment/ASMT-SUP-2841 api/customers/TEN-ARWC-047 api/customer/TEN-ARWC-047 api/tenants/TEN-ARWC-047 api/history/DOS-ARWC-HIST-01 api/dossiers/DOS-ARWC-HIST-01 api/dossier/DOS-ARWC-HIST-01 api/recovery/talia.mornac api/accounts/talia.mornac api/account/talia.mornac api/contractors api/contractor api/appointments api/appointment api/appointments/upcoming api/appointments/next api/appointments/today api/roster api/rosters api/access api/access/roster api/checkin api/checkins api/gate api/gates api/sites api/outlets api/outlet api/inspections api/inspection api/me api/user api/identity api/whoami api/profile api/crew api/crews api/visitors api/visits api/assignment api/assignments/ASMT-SUP-2841/contractor api/assignments/ASMT-SUP-2841/attendee api/inspection/appointment api/inspection/crew api/maintenance api/maintenance/CRR-OG2 api/outlet/CRR-OG2 api/asset/CRR-OG2 api/assets/CRR-OG2 api/sites/CRR-OG2 api/customer api/customers api/tenant"
for pp in $paths; do
  out=$(curl -sS -m 6 $P -k -H "$CK" -w '|%{http_code}' "$E/$pp" 2>/dev/null)
  code=${out##*|}; body=${out%|*}
  [ "$code" != "404" ] && echo "GET /$pp -> $code $body"
done
for pp in $paths; do
  out=$(curl -sS -m 6 $P -k -H "$CK" -X POST -H 'Content-Type: application/json' -d '{}' -w '|%{http_code}' "$E/$pp" 2>/dev/null)
  code=${out##*|}; body=${out%|*}
  [ "$code" != "404" ] && echo "POST /$pp -> $code $body"
done
echo "=== well-known variants ==="
for p in fieldkest-edge fieldkest-access fieldkest-session fieldkest-gate fieldkest-roster fieldkest-client; do
 out=$(curl -sS -m 6 $P -k -H "$CK" -w '|%{http_code}' "$E/.well-known/$p" 2>/dev/null)
 echo "/.well-known/$p -> ${out##*|} ${out%|*}" | head -c 200; echo
done
