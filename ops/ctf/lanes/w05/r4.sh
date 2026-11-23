#!/bin/bash
H='ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ConnectTimeout=8 -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180'
$H 'python3 - <<PY
import socket,concurrent.futures
hosts=["10.77.60.20","10.77.50.11","10.77.50.40"]
ports=[22,25,53,80,88,111,389,443,445,464,636,1433,1521,3268,3269,3306,3389,5432,5900,6379,8000,8008,8080,8081,8443,8444,8888,9000,9090,9200,9443,10000,13389]
def t(a):
    h,p=a
    s=socket.socket(); s.settimeout(3)
    try:
        s.connect((h,p)); return (h,p,"open")
    except Exception: return None
    finally: s.close()
with concurrent.futures.ThreadPoolExecutor(64) as ex:
    for r in ex.map(t,[(h,p) for h in hosts for p in ports]):
        if r: print(*r)
PY'
echo "=== www scan 10.77.60.20:1-9000 quick"
$H 'python3 - <<PY
import socket,concurrent.futures
ports=list(range(1,10000))
def t(p):
    s=socket.socket(); s.settimeout(2)
    try:
        s.connect(("10.77.60.20",p)); return p
    except Exception: return None
    finally: s.close()
with concurrent.futures.ThreadPoolExecutor(256) as ex:
    res=[p for p in ex.map(t,ports) if p]
print("OPEN:",res)
PY'
