#!/bin/bash
ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180 'bash -s' <<'EOS'
echo "== ip =="; ip -br a; echo; ip route
echo "== arp =="; ip neigh | head -20
echo "== tools =="; which nmap python3 curl dig 2>&1
echo "== scan 10.77.0.0/16 quick ports from rowan =="
cat > /tmp/sc.py <<'PY'
import asyncio,socket
ports=[80,443,8080,8081,8082,8083,8443]
hosts=[f"10.77.{c}.{i}" for c in range(40,70) for i in range(1,255)]
sem=asyncio.Semaphore(400)
res=[]
async def chk(h,p):
    async with sem:
        try:
            r,w=await asyncio.wait_for(asyncio.open_connection(h,p),1.2)
            res.append((h,p)); w.close()
        except Exception: pass
async def main():
    await asyncio.gather(*(chk(h,p) for h in hosts for p in ports))
    for r in sorted(res): print(r)
asyncio.run(main())
PY
timeout 240 python3 /tmp/sc.py
echo scan-done
EOS
