#!/bin/bash
SSH="ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 -i $HOME/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
$SSH 'bash -s' <<'INNER'
python3 - <<'PY'
import socket,concurrent.futures,time
ip='10.77.60.20'
def chk(p):
    s=socket.socket(); s.settimeout(2.0)
    try:
        r=s.connect_ex((ip,p))
        if r==0: return p
    except Exception: pass
    finally: s.close()
res=[]
t0=time.time()
with concurrent.futures.ThreadPoolExecutor(max_workers=40) as ex:
    for r in ex.map(chk, range(1,10001)):
        if r: res.append(r)
print('open',sorted(res),'elapsed',round(time.time()-t0,1))
PY
echo "===== ssh banner"
timeout 5 bash -c "exec 3<>/dev/tcp/10.77.60.20/22; head -1 <&3" 2>&1
echo "===== ssh try users"
for u in rowan arwc fieldlink connector relay; do echo "--- $u"; timeout 8 ssh -o StrictHostKeyChecking=no -o BatchMode=yes -o ConnectTimeout=5 -i ~/.ssh/keplerops-foothold $u@connector.arwc.test 'id; hostname' 2>&1 | tail -2; done
INNER
