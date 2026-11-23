set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'RSH'
set +e
echo "===MATERIAL-CONTENT==="
for f in ~/.local/share/keplerops/*; do echo "----- $f -----"; head -c 2000 "$f" 2>&1; echo; done
echo "===SUBNET-SCAN==="
python3 - <<'PY'
import socket,concurrent.futures
subs=['10.77.52','10.77.60','10.77.51','10.77.50']
ports=[22,80,443,8080,8443,5432,6443]
def chk(a,p):
    s=socket.socket(); s.settimeout(0.6)
    try: s.connect((a,p)); return (a,p)
    except Exception: return None
    finally: s.close()
jobs=[(f'{s}.{i}',p) for s in subs for i in range(1,255) for p in ports]
res=[]
with concurrent.futures.ThreadPoolExecutor(max_workers=256) as ex:
    for r in ex.map(lambda x: chk(*x), jobs, chunksize=8):
        if r: res.append(r)
for a,p in sorted(res,key=lambda t:(t[0].split('.')[2],int(t[0].split('.')[3]),t[1])):
    print('OPEN',a,p)
PY
RSH
