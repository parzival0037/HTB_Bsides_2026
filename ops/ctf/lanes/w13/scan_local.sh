#!/bin/bash
cat > /tmp/sc16.py <<'PY'
import socket,concurrent.futures as cf,sys,time,ipaddress
nets=sys.argv[1].split(',')
ports=[int(x) for x in sys.argv[2].split(',')]
targets=[]
for net in nets:
    for ip in ipaddress.ip_network(net).hosts():
        for p in ports: targets.append((str(ip),p))
def chk(t):
    ip,p=t
    s=socket.socket(); s.settimeout(0.6)
    try:
        s.connect((ip,p)); return (ip,p)
    except Exception: return None
    finally: s.close()
t0=time.time(); openp=[]
with cf.ThreadPoolExecutor(max_workers=800) as ex:
    for r in ex.map(chk,targets,chunksize=30):
        if r: openp.append(r)
for ip,p in sorted(openp): print(ip,p,flush=True)
print("DONE",len(openp),round(time.time()-t0),flush=True)
PY
echo "== 10.77.40.0/23 =="
python3 /tmp/sc16.py 10.77.40.0/23 22,80,443,8080,8081,8082,8083,8443,3000,5000,8000,8888,9090,1881,4840,502
echo "== 10.77.42.0/23 =="
python3 /tmp/sc16.py 10.77.42.0/23 22,80,443,8080,8081,8082,8083,8443,3000,5000,8000,8888,9090,1881
