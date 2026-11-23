#!/bin/bash
cat > /tmp/s5scan.py <<'PY'
import socket,struct,concurrent.futures as cf,sys,time
PROXY=('127.0.0.1',1080)
def s5(ip,port,timeout=2.0):
    try:
        s=socket.create_connection(PROXY,timeout=timeout)
    except Exception:
        return False
    try:
        s.settimeout(timeout)
        s.sendall(b'\x05\x01\x00')
        r=s.recv(2)
        if r!=b'\x05\x00': return False
        try: addr=socket.inet_aton(ip)
        except OSError: return False
        s.sendall(b'\x05\x01\x00\x01'+addr+struct.pack('!H',port))
        r=s.recv(4)
        if len(r)<2: return False
        return r[1]==0
    except Exception:
        return False
    finally:
        try: s.close()
        except: pass

def scan(ip,ports,workers=400,timeout=1.6):
    openp=[]
    with cf.ThreadPoolExecutor(max_workers=workers) as ex:
        futs={ex.submit(s5,ip,p,timeout):p for p in ports}
        for f in cf.as_completed(futs):
            if f.result(): openp.append(futs[f])
    return sorted(openp)

if __name__=='__main__':
    mode=sys.argv[1]
    t0=time.time()
    if mode=='full':
        ip=sys.argv[2]; r=scan(ip,range(1,65536),workers=500,timeout=1.5)
        print(ip,"OPEN:",r,"elapsed",round(time.time()-t0))
    else:
        nets=sys.argv[2].split(',')
        ports=[int(x) for x in sys.argv[3].split(',')]
        for net in nets:
            for i in range(1,255):
                ip=net.replace('X',str(i))
                r=scan(ip,ports,workers=100,timeout=1.5)
                if r: print(ip,r,flush=True)
    print("done",round(time.time()-t0))
PY
timeout 900 python3 /tmp/s5scan.py full 10.77.60.20
