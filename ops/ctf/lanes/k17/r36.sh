set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
S2=https://staff.keplerops.test
U='rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo'
T='fk_cert_enrollment_Um9U1sNZQ5b_Cb08iirD4H-BKfz8aMF9'
P="$S2/api/enrollment/StaffArchiveUser/requests"
echo "===== POST requests empty (basic) ====="
curl -sSk -m 8 --cacert $CA -i -u "$U" -X POST -H 'Content-Type: application/json' -d '{}' "$P" | head -30
echo; echo "===== POST requests empty (worker bearer) ====="
curl -sSk -m 8 --cacert $CA -i -H "Authorization: Bearer $T" -X POST -H 'Content-Type: application/json' -d '{}' "$P" | head -30
echo; echo "===== POST requests variants (basic) ====="
for body in '{"subject":"evan.calderoux@keplerops.test"}' '{"subject":"rowan.ito@keplerops.test"}' '{"template":"StaffArchiveUser"}' '{"csr":"x"}' '{"csr":"x","subject":"evan.calderoux@keplerops.test"}'; do
 echo "--- $body"
 curl -sSk -m 8 --cacert $CA -u "$U" -X POST -H 'Content-Type: application/json' -d "$body" -w '\n[%{http_code}]\n' "$P" | head -c 900; echo
done
echo "===== GET requests ====="
curl -sSk -m 8 --cacert $CA -u "$U" -w '\n[%{http_code}]\n' "$P" | head -c 600; echo
echo "===== archive handovers basic (no cert) ====="
for subj in evan.calderoux@keplerops.test rowan.ito@keplerops.test support arwc; do
 echo "--- $subj"
 curl -sSk -m 8 --cacert $CA -u "$U" -w '\n[%{http_code}]\n' "$S2/api/archive/handovers/$subj" | head -c 600; echo
done
echo "===== delegation probe with cert-ish headers ====="
for h in 'X-Client-Cert: x' 'X-SSL-Client-Cert: x' 'X-Forwarded-Client-Cert: x'; do
 echo "--- $h"
 curl -sSk -m 8 --cacert $CA -u "$U" -H "$h" -X POST -H 'Content-Type: application/json' -d '{}' -w '\n[%{http_code}]\n' "$S2/api/archive/delegation/probe" | head -c 600; echo
done
echo "===== openssl available? ====="
which openssl step curl jq python3
echo "===== existing certs on box ====="
find /home/rowan -name '*.crt' -o -name '*.key' -o -name '*.pem' 2>/dev/null | head -20
ls -la /home/rowan/work/certificates 2>/dev/null
INNER
echo DONE_R36
