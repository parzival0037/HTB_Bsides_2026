import socket,concurrent.futures as cf,sys,time
nets=sys.argv[1].split(',')
ports=[int(x) for x in sys.argv[2].split(',')]
targets=[]
for net in nets:
    base=net.rsplit('.',1)[0]
    for i in range(1,255):
        for p in ports: targets.append((base+'.'+str(i),p))
def chk(t):
    ip,p=t
    s=socket.socket(); s.settimeout(0.7)
    try:
        s.connect((ip,p)); return (ip,p)
    except Exception: return None
    finally: s.close()
t0=time.time(); openp=[]
with cf.ThreadPoolExecutor(max_workers=600) as ex:
    for r in ex.map(chk,targets,chunksize=20):
        if r: openp.append(r)
for ip,p in sorted(openp): print(ip,p,flush=True)
print("DONE",len(openp),round(time.time()-t0),flush=True)
