#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
B=https://cert.keplerops.test
echo "###### provisioners"
curl -sS $P -k -m 15 "$B/provisioners" | python3 -m json.tool
echo "###### version/roots subject"
curl -sS $P -k -m 15 "$B/roots" | python3 -c "
import sys,json,subprocess
d=json.load(sys.stdin)
for c in d['crts']:
    print(subprocess.run(['openssl','x509','-noout','-subject','-issuer'],input=c,capture_output=True,text=True).stdout)
"
echo "###### sign with CSR no token"
openssl req -new -newkey ec -pkeyopt ec_paramgen_curve:P-256 -nodes -keyout /tmp/k.pem -subj "/O=ARWC/CN=mira.vale" -out /tmp/req.pem 2>/dev/null
python3 -c "
import json;print(json.dumps({'csr':open('/tmp/req.pem').read()}))
" > /tmp/sign.json
curl -sS $P -k -m 15 -X POST -H 'Content-Type: application/json' --data @/tmp/sign.json "$B/sign" | head -c 800; echo
echo "###### staff enrollment requests"
curl -sS $P -k -m 15 -X POST -H 'Content-Type: application/json' -H "Authorization: Bearer fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo" --data @/tmp/sign.json "https://staff.keplerops.test/api/enrollment/StaffArchiveUser/requests" | head -c 800; echo
