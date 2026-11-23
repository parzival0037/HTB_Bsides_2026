#!/bin/bash
echo "===== BOX identity"
id; hostname; cat /etc/hosts; cat /etc/resolv.conf | grep -v '^#'
echo "== getent"; for h in hmi.arwc.test plc historian historian.arwc.test arwc.test cairnreach.arwc.test plc.arwc.test connector.arwc.test; do printf '%-24s %s\n' "$h" "$(getent hosts $h|head -1)"; done
echo "== listening"; ss -lntp 2>/dev/null | head -40
echo "== CairnReach on box"; ls -la ~/CairnReach 2>&1; sudo -n find / -maxdepth 4 -iname '*CairnReach*' 2>/dev/null | head -20
echo "== home"; ls -la ~ | head -30
echo "== scan 10.50.13.0/24 OT+web ports"
timeout 120 python3 - <<'PY'
import socket,concurrent.futures
ports=[22,80,443,1880,1881,1882,3000,3389,4840,5432,5900,8000,8080,8081,8443,9000,9090,10000,502,102,2404,20000]
ips=[f"10.50.13.{i}" for i in range(1,255)]
def chk(a):
    ip,p=a
    s=socket.socket(); s.settimeout(0.4)
    try:
        s.connect((ip,p)); return (ip,p)
    except Exception: return None
    finally: s.close()
with concurrent.futures.ThreadPoolExecutor(800) as ex:
    for r in ex.map(chk,[(ip,p) for ip in ips for p in ports]):
        if r: print("BOXSCAN OPEN %s:%d"%r,flush=True)
print("BOXSCAN done")
PY
echo "===== ROWAN"
KO="ssh -i $HOME/.ssh/keplerops-foothold -p 2222 -o StrictHostKeyChecking=no -o ConnectTimeout=10 rowan@10.50.13.180"
$KO 'timeout 200 python3 - <<PY
import socket,concurrent.futures
ports=[22,80,443,1880,1881,3000,3389,4840,5432,8000,8080,8081,8443,9000,9090,502,102,2404,20000,2222]
nets=[f"10.77.{n}" for n in (56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71)]
ips=[f"{net}.{i}" for net in nets for i in range(1,255)]
def chk(a):
    ip,p=a
    s=socket.socket(); s.settimeout(0.35)
    try:
        s.connect((ip,p)); return (ip,p)
    except Exception: return None
    finally: s.close()
with concurrent.futures.ThreadPoolExecutor(2500) as ex:
    for r in ex.map(chk,[(ip,p) for ip in ips for p in ports],chunksize=8):
        if r: print("ROWAN OPEN %s:%d"%r,flush=True)
print("ROWAN done")
PY' 2>&1
