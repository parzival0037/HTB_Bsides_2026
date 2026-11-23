#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080 -k -sS --max-time 20"
U=rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo
echo "===== well-known routes mentioning connector/ot/opc/modbus/historian/arwc"
for h in delivery.keplerops.test:8443 source-tools.keplerops.test:8443 workloads.keplerops.test data.keplerops.test support.keplerops.test staff.keplerops.test; do
 echo "##### $h"
 curl $P -u "$U" "https://$h/.well-known/fieldkest-client" 2>/dev/null | python3 -c "
import sys,json
try:
 d=json.load(sys.stdin)
 print('TITLE',d.get('title'),'| PURPOSE',d.get('purpose'))
 for r in d.get('routes',[]):
  k=r.get('key','');t=r.get('template','')
  if any(x in (k+t).lower() for x in ['connector','arwc','ot','opc','modbus','historian','tag','register','native','outlet','gate','plc','process','scada']):
   print(' ',r.get('method'),k,t)
except Exception as e: print('ERR',e)
"
done
echo "===== connector-archive ALL files"
curl $P -u "$U" "https://source.keplerops.test/api/v1/repos/fieldkest/connector-archive/git/trees/HEAD?recursive=1&per_page=500" | python3 -c "
import sys,json,base64,urllib.request
d=json.load(sys.stdin)
for t in d.get('tree',[]):
 if t['type']=='blob': print('BLOB',t['path'])
"
echo "===== connector-archive contents"
for f in README.md config/diagnostic.conf config/ordinary.conf notes/retained-diagnostic.md link-map.json linkmap.json; do
 echo "##### $f"
 curl $P -u "$U" "https://source.keplerops.test/api/v1/repos/fieldkest/connector-archive/contents/$f" | python3 -c "
import sys,json,base64
try:
 d=json.load(sys.stdin)
 print(base64.b64decode(d['content']).decode('utf-8','replace'))
except Exception as e: print('ERR',e)
"
done
echo "===== all repo list v2"
curl $P -u "$U" "https://source.keplerops.test/api/v1/repos/search?limit=100&q=" | python3 -c "
import sys,json
d=json.load(sys.stdin)
for r in d.get('data',[]): print(r['full_name'],'|',r.get('description',''))
"
