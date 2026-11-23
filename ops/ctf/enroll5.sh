set +e
P="curl -sS -m 15 --socks5-hostname 127.0.0.1:1080 -k"
W="fk_cert_enrollment_Um9U1sNZQ5b_Cb08iirD4H-BKfz8aMF9"
U="https://staff.keplerops.test/api/enrollment/StaffArchiveUser/requests"
for upn in "arwc-connector-consumer@19f43d2" "rowan.ito@keplerops.test" "maya.ranscombe@keplerops.test" "arwc-connector-consumer" "fieldkest-enrollment@keplerops.test" "cedar-run-diagnostic-session" "talia.mornac-review@keplerops.test"; do
  printf '%-42s ' "$upn"
  $P -X POST -H "Authorization: Bearer $W" -H 'Content-Type: application/json' -d "{\"upn\":\"$upn\"}" -w ' [%{http_code}] ' "$U" | head -c 260; echo
done
