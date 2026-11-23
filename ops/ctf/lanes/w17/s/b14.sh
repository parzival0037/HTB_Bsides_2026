#!/bin/bash
timeout 200 python3 - <<'PY'
import socket, concurrent.futures
def t(a):
    ip,p=a
    s=socket.socket(); s.settimeout(0.6)
    try:
        s.connect((ip,p)); return f"{ip}:{p}"
    except Exception: return None
    finally: s.close()
# full scan of .41.1 and .40.1
ips=["10.77.41.1","10.77.40.1"]
jobs=[(ip,p) for ip in ips for p in range(1,65536)]
with concurrent.futures.ThreadPoolExecutor(700) as ex:
    for r in ex.map(t,jobs):
        if r: print(r,flush=True)
print("== 40/41 sweep")
ports=[22,80,443,1881,3389,4840,5432,5900,6080,8080,8443,2222,3000,1880,8086,9090,502,102,8000,8888,4000,5800]
jobs=[(f"10.77.{n}.{i}",p) for n in (40,41) for i in range(1,255) for p in ports]
with concurrent.futures.ThreadPoolExecutor(500) as ex:
    for r in ex.map(t,jobs):
        if r: print(r,flush=True)
print("done")
PY
