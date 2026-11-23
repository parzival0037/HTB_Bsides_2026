#!/bin/bash
SSH="ssh -i $HOME/.ssh/keplerops-foothold -o BatchMode=yes -o StrictHostKeyChecking=accept-new -o ConnectTimeout=8 rowan-dev"
$SSH 'timeout 240 python3 - <<PY
import socket, concurrent.futures
def t(p):
    s=socket.socket(); s.settimeout(0.6)
    try:
        s.connect(("10.77.60.20",p)); return p
    except Exception: return None
    finally: s.close()
with concurrent.futures.ThreadPoolExecutor(1000) as ex:
    res=[p for p in ex.map(t,range(1,65536)) if p]
print("10.77.60.20 open:", sorted(res))
PY' 2>&1
