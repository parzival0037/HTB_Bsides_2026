set +e
P="curl -sS -m 15 --socks5-hostname 127.0.0.1:1080 -k"
W="fk_cert_enrollment_Um9U1sNZQ5b_Cb08iirD4H-BKfz8aMF9"
U="https://staff.keplerops.test/api/enrollment/StaffArchiveUser/requests"
UPN="evan.calderoux@keplerops.test"
echo "--- GET requests"; $P -H "Authorization: Bearer $W" -w ' [%{http_code}]\n' "$U" | head -c 300
for body in "{\"upn\":\"$UPN\"}" "{\"subject\":\"$UPN\"}" "{\"user_principal_name\":\"$UPN\"}" "{\"principal\":\"$UPN\"}" "{\"user\":{\"upn\":\"$UPN\"}}"; do
  echo "--- POST $body"
  $P -X POST -H "Authorization: Bearer $W" -H 'Content-Type: application/json' -d "$body" -w ' [%{http_code}]\n' "$U" | head -c 400; echo
done
