#!/bin/bash
KO="ssh -i $HOME/.ssh/keplerops-foothold -p 2222 -o StrictHostKeyChecking=no -o ConnectTimeout=10 rowan@10.50.13.180"
$KO 'timeout 280 python3 - <<PY
import socket, concurrent.futures
ips=[f"10.77.55.{i}" for i in range(0,8)]+[f"10.77.60.{i}" for i in range(1,255)]
ports=[22,80,443,502,102,1881,3000,3389,4000,4840,5432,8000,8001,8080,8081,8086,8443,8701,9090,10000,1502,2404,20000]
def chk(a):
    ip,p=a
    s=socket.socket(); s.settimeout(0.5)
    try:
        s.connect((ip,p)); return (ip,p)
    except Exception: return None
    finally: s.close()
with concurrent.futures.ThreadPoolExecutor(800) as ex:
    for r in ex.map(chk,[(ip,p) for ip in ips for p in ports]):
        if r: print("OPEN %s:%d"%r,flush=True)
print("done")
PY' 2>&1
