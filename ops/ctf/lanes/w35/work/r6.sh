#!/bin/bash
S="ssh -o StrictHostKeyChecking=no -o BatchMode=yes -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
echo "===== rowan routes/interfaces ====="
$S 'ip route; echo ---; ip -br a'
echo "===== broad scan ====="
$S 'python3 - <<PYEOF
import socket, concurrent.futures as cf
ports=[22,80,443,102,502,1881,1883,2404,3000,3001,3389,4000,4840,5000,5432,5601,6379,8000,8001,8060,8080,8081,8082,8083,8088,8443,8888,9000,9090,9200,27017]
nets=[52,53,54,55,56,60,61,62]
jobs=[("10.77.%d.%d"%(n,i),p) for n in nets for i in range(1,255) for p in ports]
def chk(a):
    h,p=a
    s=socket.socket(); s.settimeout(0.7)
    try:
        if s.connect_ex((h,p))==0: return (h,p)
    except Exception: pass
    finally: s.close()
res=[]
with cf.ThreadPoolExecutor(max_workers=400) as ex:
    for r in ex.map(chk,jobs,chunksize=40):
        if r: res.append(r)
for h,p in sorted(res): print("%s:%s"%(h,p))
PYEOF'
