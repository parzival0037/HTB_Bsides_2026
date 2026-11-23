#!/bin/bash
H='ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ConnectTimeout=8 -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180'
$H 'cat > /tmp/scan2.py' <<'PY'
import concurrent.futures,ssl,http.client
host="connector.arwc.test"; ip="10.77.60.20"
ctx=ssl._create_unverified_context()
res="""employees employee staff people users user accounts account identities identity directory roster rosters onboarding onboardings onboard starter starters starter-pack starterpack pack packs package welcome handbooks handbook policies policy kyc access access-requests credentials password passwords signin sign-in login logins sessions session auth activation activations activate enrollment enrollments enrol enroll invite invites invitation invitations temp temporary temps contractors contractor assignments assignment work-assignments hiring hires new-starters fieldlink fieldkest diagnostics diagnostic packages poll rehearsals rollback receipt receipts review entry entries channel channel-identity channels tenants tenant customers customer"""
words=res.split()
pref=["/api/fieldlink/","/api/","/",""]
paths=list({p+w for p in pref for w in words})
paths+=["/api/fieldlink/diagnostics/"+w for w in ("poll","status","jobs","job","new","create","requests","roster","employees","staff","activation","onboarding")]
paths+=["/api/fieldlink/"+w+"/"+x for w in ("employees","staff","onboarding","activation","directory","roster","package","packages") for x in ("roster","status","requests","list","current","new","my","me","pending","approved")]
def req(a):
    path,method=a
    try:
        c=http.client.HTTPSConnection(ip,443,timeout=6,context=ctx)
        h={"Host":host,"Connection":"close"}
        body=None
        if method=="POST":
            h["Content-Type"]="application/json"; body="{}"
        c.request(method,path,body=body,headers=h)
        r=c.getresponse(); b=r.read(160); c.close()
        return (method,path,r.status,b.decode('utf8','replace'))
    except Exception as e:
        return (method,path,0,str(e)[:60])
jobs=[(p,m) for p in paths for m in ("GET","POST")]
with concurrent.futures.ThreadPoolExecutor(60) as ex:
    for r in ex.map(req,jobs):
        if r[2] not in (404,0):
            print(r,flush=True)
print("DONE",len(jobs),flush=True)
PY
$H 'timeout 200 python3 /tmp/scan2.py' 2>&1 | tail -40
