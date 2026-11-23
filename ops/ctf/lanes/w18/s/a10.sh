#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080 -k -sS --max-time 25"
U=rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo
echo "===== npm /-/all (names only)"
curl $P -u "$U" https://packages.keplerops.test/-/all -o /tmp/all.json -w '[%{http_code} bytes=%{size_download}]\n'
python3 - <<'PY'
import json
try:
    d=json.load(open('/tmp/all.json'))
    print("count",len(d))
    for k in sorted(d)[:200]: print(k)
except Exception as e:
    print("ERR",e); print(open('/tmp/all.json',errors='replace').read()[:500])
PY
echo "===== npm search"
curl $P -u "$U" "https://packages.keplerops.test/-/v1/search?text=&size=100" -o /tmp/s.json -w '[%{http_code}]\n'; head -c 1500 /tmp/s.json; echo
echo "===== delivery client doc"
curl $P -u "$U" https://delivery.keplerops.test:8443/.well-known/fieldkest-client | head -c 2500; echo
