set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
G=https://source.keplerops.test
T='rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo'
echo "===== repos (search) ====="
curl -sSk -m 10 --cacert $CA -u "$T" "$G/api/v1/repos/search?limit=50" | python3 -c '
import json,sys
d=json.load(sys.stdin)
for r in d.get("data",[]): print(r["full_name"], r.get("private"), r.get("updated_at"), r.get("description"))
' 2>&1 | head -40
echo "===== orgs ====="
curl -sSk -m 10 --cacert $CA -u "$T" "$G/api/v1/orgs" | head -c 800; echo
echo "===== user repos ====="
curl -sSk -m 10 --cacert $CA -u "$T" "$G/api/v1/user/repos?limit=50" | python3 -c '
import json,sys
d=json.load(sys.stdin)
for r in d: print(r["full_name"], r.get("private"), r.get("description"))
' 2>&1 | head -40
echo "===== connector.arwc.test route probing ====="
C=https://connector.arwc.test
for p in / /health /api /api/v1 /status /cases /case /notes /api/cases /api/notes /api/case-notes /robots.txt /.well-known/openapi.json /openapi.json /api/support /api/diagnostic; do
 echo "--- $p"
 curl -sSk -m 6 --cacert $CA -w '\n[%{http_code}]\n' "$C$p" | head -c 400; echo
done
echo "===== staff notes with cert (evan) probes ====="
E=/home/rowan/work/certificates/evan.calderoux
for n in NOTE-SUP-2841-7 NOTE-CRR-OG2-1 NOTE-ARWC-1 NOTE-CINDER-1 NOTE-CINDER NOTE-CASE-2841 NOTE-REV-2841 NOTE-CRR-OG2; do
 echo "--- $n"
 curl -sSk -m 6 --cacert $CA --cert $E.crt --key $E.key -w '\n[%{http_code}]\n' "https://staff.keplerops.test/api/notes/$n" | head -c 500; echo
done
INNER
echo DONE_R45
