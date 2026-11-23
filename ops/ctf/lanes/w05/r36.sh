#!/bin/bash
H='ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ConnectTimeout=8 -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180'
$H 'python3 - <<PY
import ssl,socket,http.client
ip="10.77.60.20"
ctx=ssl._create_unverified_context()
s=ctx.wrap_socket(socket.create_connection((ip,443),timeout=6),server_hostname="connector.arwc.test")
print("cert:",s.getpeercert(True)[:0], s.getpeercert())
s.close()
hosts=["connector.arwc.test","hr.arwc.test","staff.arwc.test","identity.arwc.test","id.arwc.test","portal.arwc.test","onboarding.arwc.test","it.arwc.test","directory.arwc.test","people.arwc.test","workday.arwc.test","sso.arwc.test","arwc.test","auth.arwc.test","intranet.arwc.test"]
paths=["/","/api/fieldlink/diagnostics","/login","/api/staff","/api/employees","/staff","/hr"]
for h in hosts:
  for p in paths:
    try:
      c=http.client.HTTPSConnection(ip,443,timeout=6,context=ctx)
      c.request("GET",p,headers={"Host":h})
      r=c.getresponse(); b=r.read(100); c.close()
      if r.status!=404: print(h,p,r.status,b[:100])
    except Exception as e: print(h,p,"ERR",str(e)[:40])
PY'
