set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
S2=https://staff.keplerops.test
T='fk_cert_enrollment_Um9U1sNZQ5b_Cb08iirD4H-BKfz8aMF9'
mkdir -p /home/rowan/work/certificates
P="$S2/api/enrollment/StaffArchiveUser/requests"
for who in evan.calderoux rowan.ito; do
  curl -sSk -m 10 --cacert $CA -H "Authorization: Bearer $T" -X POST -H 'Content-Type: application/json' -d "{\"upn\":\"$who@keplerops.test\"}" "$P" > /tmp/enr_$who.json
  python3 - "$who" <<'PY'
import json,sys
w=sys.argv[1]
d=json.load(open(f'/tmp/enr_{w}.json'))
open(f'/home/rowan/work/certificates/{w}.crt','w').write(d['certificate_pem'])
open(f'/home/rowan/work/certificates/{w}.key','w').write(d['private_key_pem'])
print(w,'enrolled upn=',d.get('upn'),'flag=',d.get('flag'))
PY
  chmod 600 /home/rowan/work/certificates/$who.key
done
E=/home/rowan/work/certificates/evan.calderoux
R=/home/rowan/work/certificates/rowan.ito
echo "===== cert subject ====="
openssl x509 -in $E.crt -noout -subject -issuer -dates -ext subjectAltName 2>&1
echo "===== archive handovers with evan cert ====="
for subj in "evan.calderoux@keplerops.test" "rowan.ito@keplerops.test" "support" "arwc" "SUP-2841" "NOTE-SUP-2841-7" "cinder" "Cinder"; do
 echo "--- $subj"
 curl -sSk -m 10 --cacert $CA --cert $E.crt --key $E.key -w '\n[%{http_code}]\n' "$S2/api/archive/handovers/$subj" | head -c 2000; echo
done
echo "===== archive with rowan cert ====="
curl -sSk -m 10 --cacert $CA --cert $R.crt --key $R.key -w '\n[%{http_code}]\n' "$S2/api/archive/handovers/rowan.ito@keplerops.test" | head -c 2000; echo
echo "===== delegation probe with evan cert, empty ====="
curl -sSk -m 10 --cacert $CA --cert $E.crt --key $E.key -X POST -H 'Content-Type: application/json' -d '{}' -w '\n[%{http_code}]\n' "$S2/api/archive/delegation/probe" | head -c 2000; echo
INNER
echo DONE_R39
