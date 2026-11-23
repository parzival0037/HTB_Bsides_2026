#!/bin/bash
timeout 120 python3 - <<'PY'
import socket, concurrent.futures
ips=[f"10.77.{net}.{i}" for net in (40,41) for i in range(1,255)]
ports=[22,80,443,3000,3389,4840,502,102,1881,5432,8000,8001,8080,8081,8082,8083,8084,8085,8086,8087,8088,8089,8090,8443,8888,9090,10000]
def chk(a):
    ip,p=a
    s=socket.socket(); s.settimeout(0.4)
    try:
        s.connect((ip,p)); return f"{ip}:{p}"
    except Exception: return None
    finally: s.close()
with concurrent.futures.ThreadPoolExecutor(600) as ex:
    for r in ex.map(chk,[(ip,p) for ip in ips for p in ports]):
        if r: print(r,flush=True)
print("done")
PY
