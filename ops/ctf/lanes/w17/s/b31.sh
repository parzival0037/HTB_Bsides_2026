#!/bin/bash
SSH="ssh -i $HOME/.ssh/keplerops-foothold -o BatchMode=yes -o StrictHostKeyChecking=accept-new -o ConnectTimeout=8 rowan-dev"
$SSH 'timeout 200 python3 - <<PY
import socket, concurrent.futures
ports=[22,80,443,1881,3389,4840,5432,3000,8080,8443]
def t(a):
    ip,p=a
    s=socket.socket(); s.settimeout(0.7)
    try:
        s.connect((ip,p)); return f"{ip}:{p}"
    except Exception: return None
    finally: s.close()
jobs=[(f"10.77.{n}.1",p) for n in range(0,256) for p in ports]
with concurrent.futures.ThreadPoolExecutor(500) as ex:
    for r in ex.map(t,jobs):
        if r: print(r,flush=True)
print("gateway scan done")
PY' 2>&1 | tail -60
