#!/bin/bash
echo "== route"; awk 'NR>1{printf "%s %s\n",$1,$2}' /proc/net/route | head; cat /proc/net/route
timeout 250 python3 - <<'PY'
import socket, concurrent.futures
ports=[22,80,443,1880,1881,3000,3389,4840,5432,5900,8000,8080,8081,8086,8443,9090,502,102,2222]
nets=[f"10.77.{n}" for n in range(42,50)]
def t(a):
    ip,p=a
    s=socket.socket(); s.settimeout(0.6)
    try:
        s.connect((ip,p)); return f"{ip}:{p}"
    except Exception: return None
    finally: s.close()
jobs=[(f"{net}.{i}",p) for net in nets for i in range(1,255) for p in ports]
with concurrent.futures.ThreadPoolExecutor(700) as ex:
    for r in ex.map(t,jobs):
        if r: print(r,flush=True)
print("scan done")
PY
