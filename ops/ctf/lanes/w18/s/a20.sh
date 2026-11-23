#!/bin/bash
KO="ssh -i $HOME/.ssh/keplerops-foothold -p 2222 -o StrictHostKeyChecking=no -o ConnectTimeout=10 rowan@10.50.13.180"
$KO 'ip -4 addr show; echo ---; hostname -I; echo ---; ip route get 10.77.50.11; echo ---; ip route get 10.77.60.20; echo ---; timeout 240 python3 - <<PY
import socket, concurrent.futures
ports=[4840,1881,502,102,2404,4800,44818,20000,7890,5006,19000]
def chk(a):
    ip,p=a
    s=socket.socket(); s.settimeout(0.25)
    try:
        s.connect((ip,p)); return (ip,p)
    except Exception: return None
    finally: s.close()
ips=[f"10.77.{n}.{i}" for n in range(0,256) for i in range(1,255)]
jobs=[(ip,p) for ip in ips for p in ports]
print("jobs",len(jobs),flush=True)
with concurrent.futures.ThreadPoolExecutor(2000) as ex:
    for r in ex.map(chk,jobs,chunksize=16):
        if r: print("OPEN %s:%d"%r,flush=True)
print("done",flush=True)
PY' 2>&1 | tail -40
