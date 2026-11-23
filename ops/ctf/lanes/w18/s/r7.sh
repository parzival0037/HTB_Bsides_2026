#!/bin/bash
KO="-i ~/.ssh/keplerops-foothold -p 2222 -o StrictHostKeyChecking=no -o ConnectTimeout=10"
ssh $KO rowan@10.50.13.180 'python3 - <<PY
import socket,concurrent.futures
hosts=["10.77.60.20"]
ports=list(range(1,10000))
def chk(p):
    s=socket.socket(); s.settimeout(1.0)
    try:
        s.connect(("10.77.60.20",p)); return p
    except Exception: return None
    finally: s.close()
openp=[]
with concurrent.futures.ThreadPoolExecutor(max_workers=300) as ex:
    for r in ex.map(chk,ports):
        if r: openp.append(r)
print("OPEN",sorted(openp))
PY' 2>&1
