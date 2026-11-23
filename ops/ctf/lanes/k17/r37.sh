set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
S2=https://staff.keplerops.test
T='fk_cert_enrollment_Um9U1sNZQ5b_Cb08iirD4H-BKfz8aMF9'
P="$S2/api/enrollment/StaffArchiveUser/requests"
for body in \
 '{"upn":"evan.calderoux@keplerops.test"}' \
 '{"upn":"rowan.ito@keplerops.test"}' \
 '{"user":"evan.calderoux@keplerops.test"}' \
 '{"email":"evan.calderoux@keplerops.test"}' \
 '{"subject":"evan.calderoux@keplerops.test"}' \
 '{"common_name":"evan.calderoux@keplerops.test"}' \
 '{"identity":"evan.calderoux@keplerops.test"}' \
 '{"username":"evan.calderoux"}' ; do
 echo "--- $body"
 curl -sSk -m 8 --cacert $CA -H "Authorization: Bearer $T" -X POST -H 'Content-Type: application/json' -d "$body" -w '\n[%{http_code}]\n' "$P" | head -c 900; echo
done
echo "===== template again with worker bearer ====="
curl -sSk -m 8 --cacert $CA -H "Authorization: Bearer $T" -w '\n[%{http_code}]\n' "$S2/api/enrollment/StaffArchiveUser"; echo
echo "===== enrollment template names probes ====="
for t in StaffArchiveUser FieldStaff staff staff-archive cinder Cinder; do
 echo "--- $t"
 curl -sSk -m 8 --cacert $CA -u 'rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo' -w '\n[%{http_code}]\n' "$S2/api/enrollment/$t" | head -c 300; echo
done
INNER
echo DONE_R37
