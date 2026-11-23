#!/bin/bash
SSH="ssh -i $HOME/.ssh/keplerops-foothold -o BatchMode=yes -o StrictHostKeyChecking=accept-new -o ConnectTimeout=8 rowan-dev"
$SSH 'python3 - <<PY
import socket,concurrent.futures
nets=["10.77.52.%d","10.77.61.%d","10.77.62.%d","10.77.63.%d"]
ports=[22,80,443,1881,4840,5432,8080,8443,3000,502,8081,8000]
def chk(a):
    ip,p=a
    s=socket.socket(); s.settimeout(0.5)
    try:
        s.connect((ip,p)); return (ip,p)
    except Exception: return None
    finally: s.close()
jobs=[(n%i,p) for n in nets for i in range(1,255) for p in ports]
with concurrent.futures.ThreadPoolExecutor(max_workers=300) as ex:
    for r in ex.map(chk,jobs):
        if r: print("OPEN",r[0],r[1],flush=True)
print("done")
PY
' 2>&1
