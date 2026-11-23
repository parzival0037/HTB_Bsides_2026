#!/bin/bash
echo "== train nets scan"
timeout 220 python3 - <<'PY'
import socket, concurrent.futures
ports=[21,22,80,443,1880,1881,3000,4840,5432,502,8080,8081,8082,8083,8084,8085,8443,9000,9090,1883,1884]
nets=["10.77.40","10.77.41"]
def t(a):
    ip,p=a
    s=socket.socket(); s.settimeout(0.7)
    try:
        s.connect((ip,p)); return f"{ip}:{p}"
    except Exception: return None
    finally: s.close()
jobs=[(f"{n}.{i}",p) for n in nets for i in range(1,255) for p in ports]
with concurrent.futures.ThreadPoolExecutor(500) as ex:
    for r in ex.map(t,jobs):
        if r: print(r,flush=True)
print("done")
PY
