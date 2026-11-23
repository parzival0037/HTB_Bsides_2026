set +e
ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev 'cat > /tmp/scan.py' <<'PY'
import socket, concurrent.futures, sys
hosts = [f"10.77.60.{i}" for i in range(1, 40)]
ports = [22, 80, 443, 3000, 4000, 4840, 5432, 8000, 8080, 8081, 8443, 1880, 1883]
def probe(hp):
    h, p = hp
    s = socket.socket(); s.settimeout(0.6)
    try:
        if s.connect_ex((h, p)) == 0: return (h, p)
    except Exception: pass
    finally: s.close()
    return None
with concurrent.futures.ThreadPoolExecutor(128) as ex:
    for r in ex.map(probe, [(h, p) for h in hosts for p in ports]):
        if r: print(f"{r[0]}:{r[1]} OPEN", flush=True)
PY
ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev 'timeout 60 python3 /tmp/scan.py'
echo "=== rowan-dev routes to 60.x ==="
ssh -o BatchMode=yes rowan-dev 'ip route get 10.77.60.20; ip route get 10.77.60.10 2>&1 | head -2'
