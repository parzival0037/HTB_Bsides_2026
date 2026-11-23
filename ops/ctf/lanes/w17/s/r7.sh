#!/bin/bash
SSH="ssh -i $HOME/.ssh/keplerops-foothold -o BatchMode=yes -o StrictHostKeyChecking=accept-new -o ConnectTimeout=8 rowan-dev"
$SSH 'timeout 8 ping -c2 10.77.60.20 2>&1 | tail -3; echo ===
python3 - <<PY
import socket, concurrent.futures
ips=["10.77.60.20","10.77.60.1","10.77.60.254"]
ports=[22,80,443,1881,3000,3001,4840,5432,8000,8080,8081,8443,9090,5433]
def t(a):
    ip,p=a
    s=socket.socket(); s.settimeout(2)
    try:
        s.connect((ip,p)); return f"OPEN {ip}:{p}"
    except Exception as e: return None
    finally: s.close()
with concurrent.futures.ThreadPoolExecutor(40) as ex:
    for r in ex.map(t,[(i,p) for i in ips for p in ports]):
        if r: print(r)
print("done")
PY
echo ===
curl -sS -m 8 -k -o /dev/null -w "conn_https:%{http_code}\n" https://connector.arwc.test/ 2>&1
curl -sS -m 8 -o /dev/null -w "conn_http:%{http_code}\n" http://connector.arwc.test/ 2>&1' 2>&1
