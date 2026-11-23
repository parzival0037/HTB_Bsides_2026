set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
A=https://assistant.keplerops.test
cat > /tmp/sse2.py <<'PY'
import sys,json,ssl,http.client,urllib.parse,time
A,CA,TOK,slug,msg,mode=sys.argv[1:7]
body=json.dumps({"message":msg,"mode":mode,"attachments":[],"reset":False})
ctx=ssl.create_default_context(cafile=CA)
u=urllib.parse.urlparse(A)
conn=http.client.HTTPSConnection(u.netloc,context=ctx,timeout=200)
conn.request("POST",f"/api/workspace/{slug}/stream-chat",body,{"Authorization":f"Bearer {TOK}","Content-Type":"application/json","Accept":"text/event-stream"})
r=conn.getresponse()
print("STATUS",r.status,r.getheader("Content-Type"))
text="";sources=[];raw=""
deadline=time.time()+190
while time.time()<deadline:
    line=r.fp.readline()
    if not line: break
    l=line.decode("utf-8","replace").rstrip("\n")
    raw+=l+"\n"
    if l.startswith("data: "):
        try: d=json.loads(l[6:])
        except Exception: continue
        t=d.get("type")
        if d.get("sources"): sources=d["sources"]
        if t=="textResponseChunk": text+=d.get("textResponse") or ""
        elif t in ("finalizeResponseStream","statusResponse","textResponse"):
            if d.get("textResponse") and t!="textResponseChunk": text+=(d.get("textResponse") or "")
        if t=="finalizeResponseStream": break
print("=== TEXT ===");print(text)
print("=== SOURCES ===");print(json.dumps(sources)[:8000])
print("=== RAWTAIL ===");print(raw[-2500:])
PY
TOK=$(curl -sS -m 10 --cacert $CA -X POST -H 'Content-Type: application/json' -d '{"username":"rowan.ito","password":"fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"}' "$A/api/request-token" | python3 -c 'import json,sys;print(json.load(sys.stdin)["token"])')
echo "########## Q1 query-mode"
python3 /tmp/sse2.py "$A" "$CA" "$TOK" support-private "What case details and reference codes appear in the context documents?" query
INNER
echo DONE_MARK_$RANDOM
