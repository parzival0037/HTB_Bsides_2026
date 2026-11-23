import socket, concurrent.futures, sys
nets=sys.argv[1:]
ports=[22,80,443,3000,3389,4840,502,5432,8000,8080,8081,8082,8083,8443,8888,9000,1880,5000,7000,8006,8040,9100,9090,6000,6001,6379,27017,1883,8883,10000,1337]
def chk(hp):
    h,p=hp
    s=socket.socket(); s.settimeout(0.5)
    try:
        s.connect((h,p)); return (h,p)
    except Exception: return None
    finally: s.close()
hosts=[]
for n in nets:
    pre=n.rsplit('.',1)[0]
    hosts += [f"{pre}.{i}" for i in range(1,255)]
res=[]
with concurrent.futures.ThreadPoolExecutor(max_workers=800) as ex:
    for r in ex.map(chk,[(h,p) for h in hosts for p in ports]):
        if r: res.append(r)
for h,p in sorted(res, key=lambda x:(tuple(int(i) for i in x[0].split('.')),x[1])): print(f"{h}:{p}")
