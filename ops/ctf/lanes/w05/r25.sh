#!/bin/bash
H='ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ConnectTimeout=8 -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180'
$H 'cat > /tmp/scan_conn.py' <<'PY'
import concurrent.futures,ssl,http.client
host="connector.arwc.test"; ip="10.77.60.20"
words=[w.strip() for w in open('/tmp/wl.txt',errors='replace') if w.strip() and not w.startswith('#')]
ctx=ssl._create_unverified_context()
def req(path):
    try:
        c=http.client.HTTPSConnection(ip,443,timeout=6,context=ctx)
        c.request("GET", path, headers={"Host":host,"Connection":"close"})
        r=c.getresponse(); b=r.read(160); c.close()
        return (path,r.status,b.decode('utf8','replace'))
    except Exception as e:
        return (path,0,str(e)[:60])
pref=["","api/","api/fieldlink/"]
paths=["/"+p+x for p in pref for x in words]
with concurrent.futures.ThreadPoolExecutor(100) as ex:
    for r in ex.map(req, paths):
        if r[1] not in (404,0):
            print(r,flush=True)
print("DONE",len(paths),flush=True)
PY
$H 'cd /tmp && timeout 560 python3 scan_conn.py' 2>&1 | tail -40
