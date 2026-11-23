set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
S2=https://staff.keplerops.test
T='fk_cert_enrollment_Um9U1sNZQ5b_Cb08iirD4H-BKfz8aMF9'
P="$S2/api/enrollment/StaffArchiveUser/requests"
post(){ curl -sSk -m 8 --cacert $CA -H "Authorization: Bearer $T" -X POST -H 'Content-Type: application/json' -d "$1" -w ' [HTTP %{http_code}]' "$P"; echo; }
for b in '{}' '{"upn":"evan.calderoux"}' '{"upn":"evan.calderoux@keplerops.test"}' '{"subject":"evan.calderoux"}' '{"subject":"evan.calderoux@keplerops.test"}' '{"email":"evan.calderoux"}' '{"email":"evan.calderoux@keplerops.test"}' '{"upn":"evan.calderoux@KEPLEROPS.TEST"}' '{"upn":"rowan.ito@keplerops.test"}' '{"subject":"rowan.ito@keplerops.test"}' '{"userPrincipalName":"evan.calderoux@keplerops.test"}' '{"upn":"evan.calderoux@keplerops.test","csr":"x"}' '{"subject":"evan.calderoux@keplerops.test","csr":"x"}' '{"csr":"x","upn":"evan.calderoux@keplerops.test"}' '{"csr":"x","subject":"evan.calderoux@keplerops.test"}'; do
 echo "--- $b"; post "$b"
done
echo "=== content-type forms ==="
echo "--- form upn"
curl -sSk -m 8 --cacert $CA -H "Authorization: Bearer $T" -X POST --data-urlencode "upn=evan.calderoux@keplerops.test" -w ' [HTTP %{http_code}]' "$P"; echo
echo "--- form subject"
curl -sSk -m 8 --cacert $CA -H "Authorization: Bearer $T" -X POST --data-urlencode "subject=evan.calderoux@keplerops.test" -w ' [HTTP %{http_code}]' "$P"; echo
echo "--- plain csr body"
curl -sSk -m 8 --cacert $CA -H "Authorization: Bearer $T" -X POST -H 'Content-Type: application/x-pem-file' --data-binary "x" -w ' [HTTP %{http_code}]' "$P"; echo
echo "=== who is evan.calderoux? try identity/staff lookups ==="
curl -sSk -m 8 --cacert $CA -u 'rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo' -w '\n[%{http_code}]\n' "$S2/api/managed-identities" | head -c 600; echo
curl -sSk -m 8 --cacert $CA -u 'rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo' -w '\n[%{http_code}]\n' "$S2/api/managed-identities/StaffArchiveUser/session" -X POST -H 'Content-Type: application/json' -d '{}' | head -c 600; echo
INNER
echo DONE_R38
