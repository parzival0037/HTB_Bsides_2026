#!/bin/bash
R() { ssh -o StrictHostKeyChecking=no -o ConnectTimeout=8 -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180 "$@"; }
cat > /tmp/pscan.py <<'PYEOF'
import socket, concurrent.futures, sys
hosts = ['10.77.60.%d'%i for i in range(1,255)]
ports = [22,80,443,3000,3389,4000,4840,502,5432,8000,8001,8080,8081,8082,8083,8088,8443,8888,9000,9090,1880,102,20000,1337,5000,5001,7000,7070,9001,9002,10000]
def chk(hp):
    h,p=hp
    s=socket.socket(); s.settimeout(0.6)
    try:
        s.connect((h,p)); return (h,p)
    except Exception: return None
    finally: s.close()
res=[]
with concurrent.futures.ThreadPoolExecutor(max_workers=300) as ex:
    for r in ex.map(chk,[(h,p) for h in hosts for p in ports]):
        if r: res.append(r)
for h,p in sorted(res): print(f"{h}:{p}")

R 'python3 /tmp/pscan.py'
