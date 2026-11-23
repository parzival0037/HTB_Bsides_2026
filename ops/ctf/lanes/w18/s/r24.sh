#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080 -k -sS --max-time 30"
U=rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo
B=https://source.keplerops.test/api/v1/repos/fieldkest/connector-archive/contents
for f in maps/fieldlink-connector-6.9.8.map bin/fieldlink-connector internal/fieldlink/legacy-diagnostics/CRR-OG2/ENG-FLK-LEGACY-42.md internal/fieldlink/legacy-diagnostics/CRR-OG2/ENT-ARWC-DIAG-0698.json; do
  out=/tmp/ca_$(echo $f | tr '/' '_')
  curl $P -u "$U" "$B/$f" -o /tmp/ca.json
  python3 - "$out" <<'PY'
import sys,json,base64
try:
 d=json.load(open('/tmp/ca.json'))
 open(sys.argv[1],'wb').write(base64.b64decode(d['content']))
 print('OK',sys.argv[1], len(base64.b64decode(d['content'])), d.get('encoding'))
except Exception as e: print('ERR',e, open('/tmp/ca.json').read()[:200])
PY
done
echo "===== map/content"
ls -la /tmp/ca_*
echo "--- map strings"; strings -n 4 /tmp/ca_maps_fieldlink-connector-6.9.8.map 2>/dev/null | head -80
echo "--- binary strings net"; strings -n 5 /tmp/ca_bin_fieldlink-connector 2>/dev/null | grep -Ei 'http|opc|modbus|arwc|cairn|api/|/v[0-9]|fieldlink|process|channel|register|tag|historian|poll|activate' | head -120
echo "--- eng md"; cat /tmp/ca_internal_fieldlink_legacy-diagnostics_CRR-OG2_ENG-FLK-LEGACY-42.md
echo "--- ent json"; cat /tmp/ca_internal_fieldlink_legacy-diagnostics_CRR-OG2_ENT-ARWC-DIAG-0698.json
