#!/bin/bash
SSH="ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 -i $HOME/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
$SSH 'bash -s' <<'INNER'
python3 - <<'PY'
import socket,concurrent.futures
ports=[22,80,443,3000,4443,5000,8000,8080,8443,9000]
def chk(ip,p):
    s=socket.socket(); s.settimeout(0.8)
    try:
        if s.connect_ex((ip,p))==0: return (ip,p)
    except Exception: pass
    finally: s.close()
ips=[f"10.77.60.{i}" for i in range(1,255)]
res=[]
with concurrent.futures.ThreadPoolExecutor(max_workers=200) as ex:
    futs=[ex.submit(chk,ip,p) for ip in ips for p in ports]
    for f in concurrent.futures.as_completed(futs):
        r=f.result()
        if r: res.append(r)
for r in sorted(res): print(r)
PY
INNER
