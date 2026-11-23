set +e
R=/home/rowan/.local/share/keplerops/ca.crt
U=https://staff.keplerops.test/api/archive/delegation/probe
SPN="HTTP/staff.keplerops.test@KEPLEROPS.TEST"
ssh -o BatchMode=yes rowan-dev "curl -sS -m 12 --cacert $R --cert /tmp/evan.calderoux.crt --key /tmp/evan.calderoux.key -X POST -H 'Content-Type: application/json' -d '{\"spn\":\"$SPN\",\"subject\":\"DIAG-CRR-MIXED-19\",\"reviewer\":\"talia.mornac-review\"}' $U -o /tmp/del.json; python3 -c \"
import json;d=json.load(open('/tmp/del.json'));print('keys:',list(d));print({k:(str(v)[:80]) for k,v in d.items() if k!='credential_cache'})\""
echo "=== write ccache and test ==="
ssh -o BatchMode=yes rowan-dev "python3 -c \"
import json,base64;d=json.load(open('/tmp/del.json'));open('/tmp/evan.ccache','wb').write(base64.b64decode(d['credential_cache']))\"; ls -l /tmp/evan.ccache; export KRB5CCNAME=FILE:/tmp/evan.ccache; klist 2>&1 | head -6; curl -sS -m 12 --negotiate -u : --cacert $R -w ' [%{http_code}] ' https://staff.keplerops.test/api/whoami | head -c 300; echo"
