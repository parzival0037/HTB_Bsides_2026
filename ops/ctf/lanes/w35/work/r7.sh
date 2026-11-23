#!/bin/bash
S="ssh -o StrictHostKeyChecking=no -o BatchMode=yes -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
echo "===== full port scan 10.77.60.20 ====="
$S 'python3 - <<PYEOF
import socket, concurrent.futures as cf
def chk(p):
    s=socket.socket(); s.settimeout(0.5)
    try:
        if s.connect_ex(("10.77.60.20",p))==0: return p
    except Exception: pass
    finally: s.close()
res=[]
with cf.ThreadPoolExecutor(max_workers=1000) as ex:
    for r in ex.map(chk, range(1,65536), chunksize=200):
        if r: res.append(r)
print("OPEN:", sorted(res))
PYEOF'
echo "===== tools + dns axfr ====="
$S 'which dig host nslookup nmap masscan 2>/dev/null; echo ---'
$S 'python3 - <<PYEOF
import socket,struct,random
def name(n):
    out=b""
    for l in n.split("."):
        out+=bytes([len(l)])+l.encode()
    return out+b"\x00"
def axfr(zone,server):
    qid=random.randint(0,65535)
    q=struct.pack(">HHHHHH",qid,0x0000,1,0,0,0)+name(zone)+struct.pack(">HH",252,1)
    msg=struct.pack(">H",len(q))+q
    s=socket.socket(); s.settimeout(5)
    try:
        s.connect((server,53)); s.sendall(msg)
        data=b""
        while True:
            try: chunk=s.recv(4096)
            except socket.timeout: break
            if not chunk: break
            data+=chunk
            if len(data)>20000: break
        return data
    finally: s.close()
for z in ["arwc.test","keplerops.test"]:
    d=axfr(z,"10.77.50.10")
    print(z,"axfr bytes",len(d), d[:40].hex())
    # print printable strings
    import re
    print([s.decode() for s in re.findall(rb"[ -~]{4,}", d)][:40])
PYEOF'
