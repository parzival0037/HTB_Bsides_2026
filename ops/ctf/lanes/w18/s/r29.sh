#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080 -k -sS --max-time 25"
U=rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo
echo "===== package-meta"; curl $P -u "$U" "https://delivery.keplerops.test:8443/api/package-meta/fieldlink-connector" | head -c 3000; echo
echo "===== support-rehearsal npm"; curl $P -u "$U" "https://packages.keplerops.test/@keplerops%2fsupport-rehearsal" | head -c 4000; echo
echo "===== fieldlink-connector npm meta"; curl $P -u "$U" "https://packages.keplerops.test/@keplerops%2ffieldlink-connector" | python3 -c "
import sys,json
d=json.load(sys.stdin)
print('dist-tags',d.get('dist-tags'))
for v,m in d.get('versions',{}).items():
 print(v, m.get('dist',{}).get('tarball'), m.get('dist',{}).get('shasum'))
" 2>&1 | head -40
