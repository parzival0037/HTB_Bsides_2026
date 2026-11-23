#!/bin/bash
H='ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ConnectTimeout=8 -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180'
$H 'cat > /tmp/scan3.py' <<'PY'
import concurrent.futures,ssl,http.client,sys
host=sys.argv[1]; ip=sys.argv[2] if len(sys.argv)>2 else host
ctx=ssl._create_unverified_context()
words=[w.strip() for w in open("/tmp/wl.txt",errors="replace") if w.strip() and not w.startswith("#")]
paths=["/"+w for w in words]
extra="sign verify enroll enrollment enrollments activate activation provisioners provisioner templates template token tokens profiles profile ca certs cert issue renew revoke roots root cert api api/v1 acme acme/directory account accounts staff employees roster status health config"
paths+=["/"+e for e in extra.split()]
def req(a):
    path,method=a
    try:
        c=http.client.HTTPSConnection(ip,443,timeout=6,context=ctx)
        h={"Host":host,"Connection":"close"}; body=None
        if method=="POST":
            h["Content-Type"]="application/json"; body="{}"
        c.request(method,path,body=body,headers=h)
        r=c.getresponse(); b=r.read(200); c.close()
        return (method,path,r.status,b.decode("utf8","replace"))
    except Exception as e:
        return (method,path,0,str(e)[:60])
jobs=[(p,m) for p in set(paths) for m in ("GET","POST")]
with concurrent.futures.ThreadPoolExecutor(80) as ex:
    for r in ex.map(req,jobs):
        if r[2] not in (404,0):
            print(r,flush=True)
print("DONE",len(jobs),flush=True)
PY
$H 'timeout 400 python3 /tmp/scan3.py cert.keplerops.test' 2>&1 | tail -40
