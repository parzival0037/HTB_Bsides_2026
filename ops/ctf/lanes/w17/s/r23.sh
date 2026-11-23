#!/bin/bash
SSH="ssh -i $HOME/.ssh/keplerops-foothold -o BatchMode=yes -o StrictHostKeyChecking=accept-new -o ConnectTimeout=8 rowan-dev"
$SSH 'timeout 240 python3 - <<PY
import socket, concurrent.futures
ports=[443,22,1881,4840,5432,3000]
nets=[f"10.77.{n}" for n in list(range(53,60))+list(range(61,80))]
def t(a):
    ip,p=a
    s=socket.socket(); s.settimeout(0.7)
    try:
        s.connect((ip,p)); return f"OPEN {ip}:{p}"
    except Exception: return None
    finally: s.close()
jobs=[(f"{net}.{i}",p) for net in nets for i in range(1,255) for p in ports]
with concurrent.futures.ThreadPoolExecutor(400) as ex:
    for r in ex.map(t,jobs):
        if r: print(r, flush=True)
print("scan done")
PY' 2>&1 | tail -40
