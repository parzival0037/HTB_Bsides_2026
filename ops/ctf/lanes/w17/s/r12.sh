#!/bin/bash
SSH="ssh -i $HOME/.ssh/keplerops-foothold -o BatchMode=yes -o StrictHostKeyChecking=accept-new -o ConnectTimeout=8 rowan-dev"
$SSH 'python3 - <<PY
import socket, concurrent.futures
ports=[1881,4840,5432,3000,8080,8443,80,443]
def t(a):
    ip,p=a
    s=socket.socket(); s.settimeout(1.0)
    try:
        s.connect((ip,p)); return f"OPEN {ip}:{p}"
    except Exception: return None
    finally: s.close()
jobs=[(f"{net}.{i}",p) for net in ["10.77.52","10.77.50","10.77.51"] for i in range(1,255) for p in ports]
with concurrent.futures.ThreadPoolExecutor(300) as ex:
    for r in ex.map(t,jobs):
        if r: print(r)
print("scan done")
PY' 2>&1 | tail -60
