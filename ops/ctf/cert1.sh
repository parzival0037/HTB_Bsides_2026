set +e
P="curl -sS -m 12 --socks5-hostname 127.0.0.1:1080 -k"
W="fk_cert_enrollment_Um9U1sNZQ5b_Cb08iirD4H-BKfz8aMF9"
echo "=== cert.keplerops.test ==="
for p in / /health /api /openapi.json /v1/ /metrics; do printf '%-16s ' "$p"; $P -o /tmp/x -w '%{http_code} ' "https://cert.keplerops.test$p"; head -c 120 /tmp/x | tr '\n' ' '; echo; done
echo "=== enrollment shapes ==="
echo -n "POST /api/enrollment                -> "; $P -X POST -H "Authorization: Bearer $W" -H 'Content-Type: application/json' -d '{"template":"StaffArchiveUser"}' -w ' [%{http_code}]\n' https://staff.keplerops.test/api/enrollment | head -c 200
echo -n "POST /api/enrollment/StaffArchiveUser X-Enrollment-Token -> "; $P -X POST -H "X-Enrollment-Token: $W" -w ' [%{http_code}]\n' https://staff.keplerops.test/api/enrollment/StaffArchiveUser | head -c 200
echo -n "GET  /api/enrollment?template=StaffArchiveUser -> "; $P -H "Authorization: Bearer $W" -w ' [%{http_code}]\n' 'https://staff.keplerops.test/api/enrollment?template=StaffArchiveUser' | head -c 200
echo -n "POST /api/enrollments               -> "; $P -X POST -H "Authorization: Bearer $W" -H 'Content-Type: application/json' -d '{"template":"StaffArchiveUser","subject":"evan.calderoux@keplerops.test"}' -w ' [%{http_code}]\n' https://staff.keplerops.test/api/enrollments | head -c 200
echo "=== staff root + service dir (with token) ==="
$P -H "Authorization: Bearer $W" https://staff.keplerops.test/api/service-directory | head -c 400; echo
