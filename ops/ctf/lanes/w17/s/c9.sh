#!/bin/bash
set +e
echo "== docker sock"; ls -la /var/run/docker.sock 2>&1; ls -la /run/docker.sock 2>&1; which docker 2>&1
echo "== cgroup"; cat /proc/1/cgroup 2>/dev/null | head; cat /proc/self/status | grep -i cap
echo "== routes"; cat /proc/net/route; cat /etc/resolv.conf
echo "== connect 10.77.60.20 443/22"
for p in 22 443; do timeout 3 bash -c "exec 3<>/dev/tcp/10.77.60.20/$p" 2>/dev/null && echo "OPEN 10.77.60.20:$p" || echo "closed 60.20:$p"; done
for p in 4840 1881 5432 80 8080; do timeout 2 bash -c "exec 3<>/dev/tcp/10.77.50.11/$p" 2>/dev/null && echo "OPEN 50.11:$p"; done
echo "== scan 60.0/24 from box"
timeout 100 python3 - <<'PY'
import socket, concurrent.futures
ports=[22,80,443,1880,1881,3000,3389,4840,5432,8000,8080,8081,8443,5900]
def t(a):
    ip,p=a
    s=socket.socket(); s.settimeout(0.5)
    try:
        s.connect((ip,p)); return f"{ip}:{p}"
    except Exception: return None
    finally: s.close()
jobs=[(f"10.77.{n}.{i}",p) for n in (60,61,62) for i in range(1,255) for p in ports]
with concurrent.futures.ThreadPoolExecutor(600) as ex:
    for r in ex.map(t,jobs):
        if r: print(r,flush=True)
print("scan done")
PY
