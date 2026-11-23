import socket, concurrent.futures, sys
host=sys.argv[1] if len(sys.argv)>1 else '10.77.60.20'
def chk(p):
    s=socket.socket(); s.settimeout(0.7)
    try:
        s.connect((host,p)); return p
    except Exception: return None
    finally: s.close()
res=[]
with concurrent.futures.ThreadPoolExecutor(max_workers=600) as ex:
    for r in ex.map(chk, range(1,65536)):
        if r: res.append(r)
print(host, sorted(res))
