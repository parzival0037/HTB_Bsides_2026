#!/bin/bash
KO="ssh -i $HOME/.ssh/keplerops-foothold -p 2222 -o StrictHostKeyChecking=no -o ConnectTimeout=10 rowan@10.50.13.180"
$KO 'timeout 280 python3 - <<PY
import socket, concurrent.futures
ips=[f"10.77.{net}.{i}" for net in (60,61,62,63,64,65) for i in range(1,255)]
ports=[22,80,443,3000,3001,4000,4840,5432,8080,8081,8086,8443,1880,1881,502,102,1024,5000,8088,8181,9000,9090,10000,2222]
def chk(a):
    ip,p=a
    s=socket.socket(); s.settimeout(0.5)
    try:
        s.connect((ip,p)); return f"{ip}:{p}"
    except Exception: return None
    finally: s.close()
jobs=[(ip,p) for ip in ips for p in ports]
with concurrent.futures.ThreadPoolExecutor(900) as ex:
    for r in ex.map(chk,jobs):
        if r: print(r,flush=True)
print("done")
PY' 2>&1
