#!/bin/bash
KO="ssh -i $HOME/.ssh/keplerops-foothold -p 2222 -o StrictHostKeyChecking=no -o ConnectTimeout=10 rowan@10.50.13.180"
echo "===== scan .50.11 .51.60 .51.20 .51.40 .51.41 .51.50 .51.30"
$KO 'timeout 240 python3 - <<PY
import socket, concurrent.futures
hosts=["10.77.50.11","10.77.51.60","10.77.51.20","10.77.51.40","10.77.51.41","10.77.51.50","10.77.51.30","10.77.51.70"]
ports=list(range(1,9000))+[9100,9200,9300,9400,9500,10000,10250,13389,15000,18800,20000,24000,30000,50000]
def chk(a):
    h,p=a
    s=socket.socket(); s.settimeout(0.35)
    try:
        s.connect((h,p)); return (h,p)
    except Exception: return None
    finally: s.close()
with concurrent.futures.ThreadPoolExecutor(1200) as ex:
    for r in ex.map(chk,[(h,p) for h in hosts for p in ports]):
        if r: print("OPEN %s:%d"%r,flush=True)
print("done")
PY' 2>&1
