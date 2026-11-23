#!/bin/bash
SSH="ssh -i $HOME/.ssh/keplerops-foothold -o BatchMode=yes -o StrictHostKeyChecking=accept-new -o ConnectTimeout=8 rowan-dev"
$SSH 'timeout 260 python3 - <<PY
import socket, concurrent.futures
ports=[22,80,443,1880,1881,1882,3000,4840,5432,8080,8081,8086,8443,502,102,9090,4000,5000]
nets=[f"10.77.{n}" for n in (60,61,62,63,64,65)]
def t(a):
    ip,p=a
    s=socket.socket(); s.settimeout(0.6)
    try:
        s.connect((ip,p)); return f"OPEN {ip}:{p}"
    except Exception: return None
    finally: s.close()
jobs=[(f"{net}.{i}",p) for net in nets for i in range(1,255) for p in ports]
with concurrent.futures.ThreadPoolExecutor(400) as ex:
    for r in ex.map(t,jobs):
        if r: print(r, flush=True)
print("scan done")
PY' 2>&1 | tail -80
