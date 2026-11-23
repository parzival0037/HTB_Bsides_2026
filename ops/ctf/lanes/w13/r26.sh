#!/bin/bash
S="ssh -o StrictHostKeyChecking=no -o BatchMode=yes -o ConnectTimeout=10 -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
$S 'cat > /tmp/scan16.py <<'"'"'PY'"'"'
import asyncio,ipaddress,sys,time
ports=[int(x) for x in sys.argv[1].split(",")]
sem=asyncio.Semaphore(2000)
res=[]
async def chk(ip,p):
    async with sem:
        try:
            r,w=await asyncio.wait_for(asyncio.open_connection(str(ip),p),0.8)
            res.append((str(ip),p)); w.close()
        except Exception: pass
async def main():
    tasks=[]
    for ip in ipaddress.ip_network("10.77.0.0/16").hosts():
        for p in ports:
            tasks.append(asyncio.create_task(chk(ip,p)))
    await asyncio.gather(*tasks)
    for ip,p in sorted(res): print(ip,p,flush=True)
    print("DONE",len(res))
asyncio.run(main())
PY
python3 /tmp/scan16.py 443 8443 80 3000 1881 4840 8080 2>&1 | tail -80'
