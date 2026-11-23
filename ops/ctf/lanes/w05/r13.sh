#!/bin/bash
H='ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ConnectTimeout=8 -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180'
echo "###### DNS zone probe"
$H 'python3 - <<PY
import socket,struct,random
def q(name,qtype=1,tcp=False):
    tid=random.randint(0,65535)
    hdr=struct.pack(">HHHHHH",tid,0x0100,1,0,0,0)
    qn=b"".join(bytes([len(x)])+x.encode() for x in name.split("."))+b"\x00"
    pkt=hdr+qn+struct.pack(">HH",qtype,1)
    try:
        if tcp:
            s=socket.create_connection(("10.77.50.10",53),timeout=5)
            s.sendall(struct.pack(">H",len(pkt))+pkt)
            n=struct.unpack(">H",s.recv(2))[0]; d=b""
            while len(d)<n: d+=s.recv(n-len(d))
        else:
            s=socket.socket(socket.AF_INET,socket.SOCK_DGRAM); s.settimeout(5)
            s.sendto(pkt,("10.77.50.10",53)); d,_=s.recvfrom(4096)
        return d
    except Exception as e: return b"ERR:%s"%str(e).encode()
for n in ["arwc.test","keplerops.test"]:
    r=q(n,2)
    print(n,"NS:",r[:200])
    r=q(n,6)
    print(n,"SOA:",r[:300])
    r=q(n,252,True)
    print(n,"AXFR:",r[:800])
for n in ["hr.arwc.test","onboard.arwc.test","start.arwc.test","staff.arwc.test","portal.arwc.test","w05.arwc.test"]:
    r=q(n,1); print(n,"A:",r[:120])
PY'
echo "###### sweep 10.77.60-64 443"
$H 'python3 - <<PY
import socket,concurrent.futures
ips=[f"10.77.{n}.{i}" for n in range(60,65) for i in range(1,255)]
def t(ip):
    s=socket.socket(); s.settimeout(2)
    try: s.connect((ip,443)); return ip
    except Exception: return None
    finally: s.close()
with concurrent.futures.ThreadPoolExecutor(256) as ex:
    print("OPEN443:",[x for x in ex.map(t,ips) if x])
PY'
