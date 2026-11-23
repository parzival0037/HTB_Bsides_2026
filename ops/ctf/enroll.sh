set +e
P="curl -sS -m 15 --socks5-hostname 127.0.0.1:1080 -k"
W="fk_cert_enrollment_Um9U1sNZQ5b_Cb08iirD4H-BKfz8aMF9"
echo "=== GET enrollment template ==="
$P -H "Authorization: Bearer $W" https://staff.keplerops.test/api/enrollment/StaffArchiveUser; echo
echo "=== POST variants ==="
for subj in "arwc-connector-consumer@19f43d2" "rowan.ito@keplerops.test" "arwc-connector-consumer"; do
  echo "--- subject=$subj"
  $P -X POST -H "Authorization: Bearer $W" -H 'Content-Type: application/json' \
     -d "{\"subject\":\"$subj\"}" https://staff.keplerops.test/api/enrollment/StaffArchiveUser | head -c 400; echo
done
echo "=== alt: token only, no body ==="
$P -X POST -H "Authorization: Bearer $W" https://staff.keplerops.test/api/enrollment/StaffArchiveUser | head -c 300; echo
echo "=== archive handover without cert (baseline) ==="
$P -o /dev/null -w '%{http_code}\n' https://staff.keplerops.test/api/archive/handovers/rowan.ito@keplerops.test
