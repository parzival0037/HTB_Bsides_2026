#!/bin/bash
cat > /tmp/scanarwc.py <<'PY'
import socket,struct,concurrent.futures as cf,time
PROXY=('127.0.0.1',1080)
def s5(ip,port,timeout=3.0):
    try: s=socket.create_connection(PROXY,timeout=timeout)
    except Exception: return False
    try:
        s.settimeout(timeout); s.sendall(b'\x05\x01\x00')
        if s.recv(2)!=b'\x05\x00': return False
        s.sendall(b'\x05\x01\x00\x01'+socket.inet_aton(ip)+struct.pack('!H',port))
        r=s.recv(4)
        return len(r)>=2 and r[1]==0
    except Exception: return False
    finally:
        try:s.close()
        except:pass
ports=[80,443,8080,8443,8000,3000,5000,1881,4840,5432]
jobs=[(f'10.77.{net}.{i}',p) for net in [51,60,61,62,63] for i in range(1,255) for p in ports]
t0=time.time()
with cf.ThreadPoolExecutor(max_workers=400) as ex:
    futs={ex.submit(s5,*j):j for j in jobs}
    for f in cf.as_completed(futs):
        if f.result(): print('OPEN',futs[f],flush=True)
print('done',round(time.time()-t0))
PY
timeout 420 python3 /tmp/scanarwc.py
