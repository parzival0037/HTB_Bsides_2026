#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080 -k -sS --max-time 25"
U=rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo
curl $P -u "$U" https://packages.keplerops.test/@keplerops%2ffieldlink-connector -o /tmp/m.json -w '[%{http_code}]\n'
python3 - <<'PY'
import json
d=json.load(open('/tmp/m.json'))
print("versions:", list(d.get('versions',{})))
for v,m in d.get('versions',{}).items():
    print("==",v)
    print("  dist:", json.dumps(m.get('dist'))[:200])
    print("  deprecated:", m.get('deprecated'))
    for k in ('_id','readme','gitHead','fieldkest'):
        if k in m: print("  ",k,":",str(m[k])[:300])
print("dist-tags:",d.get('dist-tags'))
print("time:",json.dumps(d.get('time'))[:500])
PY
echo "===== support-rehearsal auth"
curl $P -u "$U" -o /tmp/sr.json -w '[%{http_code}]\n' https://packages.keplerops.test/@keplerops%2fsupport-rehearsal; head -c 3000 /tmp/sr.json; echo
echo "===== support-rehearsal noauth"
curl $P -o /tmp/sr2.json -w '[%{http_code}]\n' https://packages.keplerops.test/@keplerops%2fsupport-rehearsal; head -c 500 /tmp/sr2.json; echo
