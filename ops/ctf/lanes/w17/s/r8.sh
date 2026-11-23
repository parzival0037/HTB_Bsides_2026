#!/bin/bash
SSH="ssh -i $HOME/.ssh/keplerops-foothold -o BatchMode=yes -o StrictHostKeyChecking=accept-new -o ConnectTimeout=8 rowan-dev"
$SSH 'python3 - <<PY
import socket, concurrent.futures
ports=[22,443,4840,5432,1881,80,3000,8080,8443]
def t(a):
    ip,p=a
    s=socket.socket(); s.settimeout(1.0)
    try:
        s.connect((ip,p)); return f"OPEN {ip}:{p}"
    except Exception: return None
    finally: s.close()
jobs=[(f"10.77.60.{i}",p) for i in range(1,255) for p in ports]
with concurrent.futures.ThreadPoolExecutor(200) as ex:
    for r in ex.map(t,jobs):
        if r: print(r)
print("scan done")
PY
echo ===
echo | timeout 10 openssl s_client -connect connector.arwc.test:443 -servername connector.arwc.test 2>/dev/null | openssl x509 -noout -subject -issuer -ext subjectAltName 2>/dev/null
echo ===
curl -sS -m 10 -k -D- https://connector.arwc.test/ 2>&1 | head -30' 2>&1
