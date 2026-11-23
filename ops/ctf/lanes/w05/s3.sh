#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
A="-u rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"
G=https://source.keplerops.test
for f in \
 "fieldkest/connector-archive/contents/internal/fieldlink/legacy-diagnostics/CRR-OG2/ENG-FLK-LEGACY-42.md" \
 "fieldkest/connector-archive/contents/internal/fieldlink/legacy-diagnostics/CRR-OG2/ENT-ARWC-DIAG-0698.json" \
 "fieldkest/connector-archive/contents/notes/retained-diagnostic.md" \
 "fieldkest/connector-archive/contents/README.md" \
 "fieldkest/fieldlink-connector/contents/review/FLK-7.4.2.md" \
 "fieldkest/fieldlink-connector/contents/docs/report-provider.md" \
 "fieldkest/fieldlink-connector/contents/README.md" ; do
  echo "################ $f"
  curl -sS $P -k -m 20 $A "$G/api/v1/repos/$f" | python3 -c "
import sys,json,base64
d=json.load(sys.stdin)
print(base64.b64decode(d['content']).decode('utf8','replace'))
" 2>&1 | head -200
done
