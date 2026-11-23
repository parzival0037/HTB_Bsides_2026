#!/bin/bash
echo "== hosts"; cat /etc/hosts
echo "== name"; hostname; hostname -f; cat /etc/hostname
echo "== ip"; ip -4 a | grep inet; ip route
echo "== mission"; cat "/home/cinder/MISSION - START HERE.txt"
echo "== bash_history"; cat ~/.bash_history
echo "== ssh"; ls -la ~/.ssh; cat ~/.ssh/config 2>/dev/null; cat ~/.ssh/known_hosts 2>/dev/null | head
echo "== scan 10.50.13.0/24"
timeout 120 python3 - <<'PY'
import socket, concurrent.futures
ports=[22,80,443,1881,4840,5432,3389,8080,8443,3000]
def t(a):
    ip,p=a
    s=socket.socket(); s.settimeout(0.7)
    try:
        s.connect((ip,p)); return f"{ip}:{p}"
    except Exception: return None
    finally: s.close()
jobs=[(f"10.50.13.{i}",p) for i in range(1,255) for p in ports]
with concurrent.futures.ThreadPoolExecutor(300) as ex:
    for r in ex.map(t,jobs):
        if r: print(r,flush=True)
print("done")
PY
