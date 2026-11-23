set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'RSH'
set +e
echo "===OPT==="; ls -la /opt /opt/fieldkest-workbench 2>&1; head -50 /opt/fieldkest-workbench/workbench.py 2>&1
echo "===MATERIAL==="; find ~/.local/share/keplerops -type f 2>/dev/null | head -60
echo "===DNS==="; for n in delivery.keplerops.test connector.arwc.test support.keplerops.test packages.keplerops.test review.keplerops.test; do echo -n "$n -> "; getent hosts $n || echo NXDOMAIN; done
echo "===SCAN==="
python3 - <<'PY'
import socket,concurrent.futures
targets={
 '10.77.50.11':[22,80,443,5432,6443,8080,8443,8000,9000,3000],
 '10.77.50.40':[22,80,88,389,443,636,749,8080],
 '10.77.51.20':[22,80,443,8080,8443],
 '10.77.51.30':[22,80,443,8080,8443],
 '10.77.51.40':[22,80,443,8080,8443],
 '10.77.51.41':[22,80,443,8080,8443],
 '10.77.51.50':[22,80,443,3000,8080,8443],
 '10.77.51.70':[22,80,443,8080,8443],
 '10.77.60.20':[22,80,443,8080,8443,5432],
 '10.77.50.254':[22,80,443],
 '10.77.55.1':[22,80,443],
}
def chk(a,p):
    s=socket.socket(); s.settimeout(2)
    try:
        s.connect((a,p)); return (a,p)
    except Exception: return None
    finally: s.close()
jobs=[(a,p) for a,ps in targets.items() for p in ps]
with concurrent.futures.ThreadPoolExecutor(max_workers=64) as ex:
    for r in ex.map(lambda x: chk(*x), jobs):
        if r: print('OPEN',r[0],r[1])
PY
echo "===ARP/NEIGH==="; ip neigh
RSH
