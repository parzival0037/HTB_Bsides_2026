set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
S2=https://staff.keplerops.test
U='rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo'
echo "===== full well-known ====="
curl -sSk -m 8 --cacert $CA "$S2/.well-known/fieldkest-client" | python3 -m json.tool
echo "===== enrollment template with basic ====="
curl -sSk -m 8 --cacert $CA -i -u "$U" "$S2/api/enrollment/StaffArchiveUser" | head -40
echo "===== enrollment template with worker as basic password ====="
curl -sSk -m 8 --cacert $CA -i -u "evan.calderoux@keplerops.test:fk_cert_enrollment_Um9U1sNZQ5b_Cb08iirD4H-BKfz8aMF9" "$S2/api/enrollment/StaffArchiveUser" | head -40
echo "===== enrollment template with worker bearer and accept header ====="
curl -sSk -m 8 --cacert $CA -i -H "Authorization: Bearer fk_cert_enrollment_Um9U1sNZQ5b_Cb08iirD4H-BKfz8aMF9" -H 'Accept: application/json' "$S2/api/enrollment/StaffArchiveUser" | head -40
echo "===== enrollment other methods ====="
for m in PUT PATCH; do
 echo "--- $m"
 curl -sSk -m 8 --cacert $CA -u "$U" -X $m -H 'Content-Type: application/json' -d '{}' -w '\n[%{http_code}]\n' "$S2/api/enrollment/StaffArchiveUser" | head -c 500; echo
done
echo "===== note-preview source path probing ====="
for body in \
 '{"source_path":"/srv/hotdir/ESC-SUP-2841-R3.md"}' \
 '{"source_path":"NOTE-SUP-2841-7"}' \
 '{"source_path":"/srv/notes/NOTE-SUP-2841-7.md"}' \
 '{"source":"NOTE-SUP-2841-7"}' \
 '{"content":"RESTRICTED SUPPORT-NOTE DRAFT","source_path":"/srv/hotdir/ESC-SUP-2841-R3.md"}'; do
 echo "--- $body"
 curl -sSk -m 8 --cacert $CA -u "$U" -X POST -H 'Content-Type: application/json' -d "$body" -w '\n[%{http_code}]\n' "$S2/api/note-preview" | head -c 800; echo
done
echo "===== note-preview GET ====="
curl -sSk -m 8 --cacert $CA -u "$U" -w '\n[%{http_code}]\n' "$S2/api/note-preview" | head -c 500; echo
INNER
echo DONE_R35
