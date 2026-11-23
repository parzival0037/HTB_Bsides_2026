#!/bin/bash
SSH="ssh -i $HOME/.ssh/keplerops-foothold -o BatchMode=yes -o StrictHostKeyChecking=accept-new -o ConnectTimeout=8 rowan-dev"
$SSH 'timeout 200 python3 - <<PY
import socket, concurrent.futures, struct, random

def dnsq(server, name, qtype=1):
    tid=random.randint(0,65535)
    q=struct.pack(">HHHHHH",tid,0x0100,1,0,0,0)
    for part in name.split("."): q+=bytes([len(part)])+part.encode()
    q+=b"\x00"+struct.pack(">HH",qtype,1)
    s=socket.socket(socket.AF_INET,socket.SOCK_DGRAM); s.settimeout(2)
    try:
        s.sendto(q,(server,53)); data,_=s.recvfrom(2048)
        # crude parse answers
        ancount=struct.unpack(">H",data[6:8])[0]
        i=12
        while data[i]!=0: i+=data[i]+1
        i+=5
        out=[]
        for _ in range(ancount):
            # name (compressed)
            if data[i]&0xc0: i+=2
            else:
                while data[i]!=0: i+=data[i]+1
                i+=1
            typ,cls,ttl,rdlen=struct.unpack(">HHIH",data[i:i+10]); i+=10
            rdata=data[i:i+rdlen]; i+=rdlen
            if typ==1 and rdlen==4: out.append(".".join(str(b) for b in rdata))
            elif typ==5: out.append(rdata.hex())
        return out
    except Exception as e: return ["ERR:"+str(e)]
    finally: s.close()

for srv in ["10.77.50.10","10.77.50.254","10.77.55.1","127.0.0.11"]:
    for n in ["hmi.arwc.test","plc","plc.arwc.test","cairn.arwc.test","historian.arwc.test","arwc.test","connector.arwc.test","ot.arwc.test","hmi.keplerops.test"]:
        print(srv,n,dnsq(srv,n))
print("=== scan 55-59")
ports=[22,80,443,1881,4840,5432,3000,3389,8080,8443,502,5900,6080,8000,8086,9090,2222]
nets=[f"10.77.{n}" for n in (55,56,57,58,59)]
def t(a):
    ip,p=a
    s=socket.socket(); s.settimeout(0.55)
    try:
        s.connect((ip,p)); return f"{ip}:{p}"
    except Exception: return None
    finally: s.close()
jobs=[(f"{net}.{i}",p) for net in nets for i in range(1,255) for p in ports]
with concurrent.futures.ThreadPoolExecutor(600) as ex:
    for r in ex.map(t,jobs):
        if r: print(r,flush=True)
print("scan done")
PY' 2>&1 | tail -100
