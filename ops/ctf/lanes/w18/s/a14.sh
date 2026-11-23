#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080 -k -sS --max-time 25"
U=rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo
echo "===== registry meta fieldlink-connector"
curl $P -u "$U" https://packages.keplerops.test/@keplerops%2ffieldlink-connector -o /tmp/m.json -w '[%{http_code}]\n'
python3 - <<'PY'
import json
d=json.load(open('/tmp/m.json'))
print(json.dumps(d,indent=1)[:4000])
PY
echo "===== support-rehearsal private metadata"
curl $P -u "$U" -o /tmp/sr.json -w '[%{http_code}]\n' https://packages.keplerops.test/@keplerops%2fsupport-rehearsal
head -c 3000 /tmp/sr.json; echo
echo "===== support-rehearsal no auth"
curl $P -o /tmp/sr2.json -w '[%{http_code}]\n' https://packages.keplerops.test/@keplerops%2fsupport-rehearsal; head -c 600 /tmp/sr2.json; echo
