#!/bin/bash
SSH="ssh -i $HOME/.ssh/keplerops-foothold -o BatchMode=yes -o StrictHostKeyChecking=accept-new -o ConnectTimeout=8 rowan-dev"
$SSH 'timeout 280 python3 - <<PY
import socket, concurrent.futures
ports=[22,80,443,1880,1881,3000,3389,4840,5432,5900,6080,8000,8080,8081,8086,8443,9090,102,502]
nets=[f"10.77.{n}" for n in range(40,63)]
def t(a):
    ip,p=a
    s=socket.socket(); s.settimeout(0.55)
    try:
        s.connect((ip,p)); return f"{ip}:{p}"
    except Exception: return None
    finally: s.close()
jobs=[(f"{net}.{i}",p) for net in nets for i in range(1,255) for p in ports]
seen=set()
with concurrent.futures.ThreadPoolExecutor(800) as ex:
    for r in ex.map(t,jobs):
        if r: print(r,flush=True)
print("scan done")
PY' 2>&1 | tail -120
