#!/bin/bash
timeout 200 python3 - <<'PY'
import socket, concurrent.futures
ports=[22,80,443,1881,4840,5432,8080,8081,8082,8083,8443,3000,502,102,9090,8086,1880,1882,4000,5000]
nets=["10.77.40","10.77.41"]
def t(a):
    ip,p=a
    s=socket.socket(); s.settimeout(0.8)
    try:
        s.connect((ip,p)); return f"{ip}:{p}"
    except Exception: return None
    finally: s.close()
jobs=[(f"{n}.{i}",p) for n in nets for i in range(1,255) for p in ports]
with concurrent.futures.ThreadPoolExecutor(500) as ex:
    res=[r for r in ex.map(t,jobs) if r]
print("\n".join(res))
print("scan done", len(res))
PY
