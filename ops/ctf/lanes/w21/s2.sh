#!/bin/bash
SSH="ssh -i $HOME/.ssh/keplerops-foothold -o BatchMode=yes -o StrictHostKeyChecking=accept-new -o ConnectTimeout=8 rowan-dev"
$SSH 'python3 - <<PY
import socket,concurrent.futures
ports=[22,80,443,1881,4840,5432,8080,8443,3000,5000,8000,8081,8082,8083,9000,502]
def chk(a):
    ip,p=a
    s=socket.socket(); s.settimeout(0.6)
    try:
        s.connect((ip,p)); return (ip,p)
    except Exception: return None
    finally: s.close()
jobs=[("10.77.60.%d"%i,p) for i in range(1,255) for p in ports]
with concurrent.futures.ThreadPoolExecutor(max_workers=200) as ex:
    for r in ex.map(chk,jobs):
        if r: print("OPEN",r[0],r[1],flush=True)
PY
echo == connector routes
for p in / /api /api/ /api/fieldlink /api/v1 /health /status /.well-known/fieldkest-client /api/arwc /api/plant /api/cairn /api/controller /api/project /api/runtime /openplc /fuxa /hmi; do
 printf "%s -> " "$p"; curl -sS -m 8 -k -o /tmp/o -w "%{http_code} " "https://connector.arwc.test$p"; head -c 200 /tmp/o; echo
done
' 2>&1
