#!/bin/bash
echo "== box ip/route"; ip -4 a 2>/dev/null || ifconfig; ip route 2>/dev/null; cat /etc/resolv.conf
echo "== arp"; cat /proc/net/arp
echo "== ping sweep 10.50.13.0/24 + port scan"
python3 - <<'PY'
import socket,concurrent.futures
ips=[f"10.50.13.{i}" for i in range(1,255)]
ports=[22,80,443,1881,3389,4840,502,5432,8000,8080,8443,8701,3000,9090,102,2404]
def chk(a):
    ip,p=a
    s=socket.socket(); s.settimeout(0.35)
    try:
        s.connect((ip,p)); return (ip,p)
    except Exception: return None
    finally: s.close()
with concurrent.futures.ThreadPoolExecutor(800) as ex:
    for r in ex.map(chk,[(ip,p) for ip in ips for p in ports]):
        if r: print("OPEN %s:%d"%r,flush=True)
print("done")
PY
