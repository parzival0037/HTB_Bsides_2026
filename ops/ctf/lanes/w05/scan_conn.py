import sys,concurrent.futures,ssl,http.client,json
host="connector.arwc.test"; ip="10.77.60.20"
words=[w.strip() for w in open('/tmp/wl.txt',errors='replace') if w.strip() and not w.startswith('#')]
ctx=ssl._create_unverified_context()
def req(path, method="GET"):
    try:
        c=http.client.HTTPSConnection(ip,443,timeout=6,context=ctx)
        c.request(method, path, headers={"Host":host})
        r=c.getresponse(); b=r.read(200); c.close()
        return (method,path,r.status,b.decode('utf8','replace'))
    except Exception as e:
        return (method,path,0,str(e)[:80])
pref=["","api/","api/fieldlink/","api/v1/","v1/","hr/","staff/","internal/"]
paths=[p+x for p in pref for x in words]
found=[]
with concurrent.futures.ThreadPoolExecutor(80) as ex:
    for r in ex.map(lambda p: req("/"+p), paths):
        if r[2]!=404:
            found.append(r); print(r)
print("DONE",len(paths),flush=True)
