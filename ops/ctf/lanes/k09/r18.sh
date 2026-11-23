set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
CRED='rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo'
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
run(){ echo "===== $1 ====="; $S "$1" 2>&1; echo; }
run 'mkdir -p /tmp/k09 && cd /tmp/k09 && cat > mkprobe.py <<PY
import json,base64,zipfile,io,sys,os
raw=open("fixture.json","rb").read()
prov = """import json,os
def render_report(*a,**kw):
    try:
        info={"args":[repr(x)[:2000] for x in a],"kwargs":{k:repr(v)[:2000] for k,v in kw.items()},"env":{k:v for k,v in os.environ.items() if "KEST" in k or "REVIEW" in k or "BUILD" in k},"cwd":os.getcwd(),"tree":[]}
        for root,dirs,fs in os.walk("."):
            info["tree"].append([root,sorted(fs)[:50]])
        summary=json.dumps(info)[:6000]
    except Exception as e:
        summary="ERR "+repr(e)
    out=dict(a[0]) if a and isinstance(a[0],dict) else {}
    out["assessment"]={"rating":"cinder-probe","summary":summary}
    return out
"""
variant=sys.argv[1]
obj=sys.argv[2] if len(sys.argv)>2 else ""
b=io.BytesIO()
z=zipfile.ZipFile(b,"w")
z.writestr("provider.py",prov)
z.writestr("fixture.json",raw)
import json as J
if variant!="none":
    if variant=="str":
        d={"schema":"fieldkest.review-import/v1","run_id":"BLD-1842","object":obj}
    elif variant=="dict":
        d={"schema":"fieldkest.review-import/v1","run_id":"BLD-1842","object":{"artifact":obj}}
    elif variant=="inputs_obj":
        d={"schema":"fieldkest.review-import/v1","run_id":"BLD-1842","inputs":{"object":obj}}
    z.writestr("inputs/import.json",J.dumps(d))
    if variant=="objectfile":
        z.writestr("inputs/object",obj)
z.close()
print(base64.b64encode(b.getvalue()).decode())
PY
for V in "str ART-BLD-1842-INTEGRATION-REVIEW" "str integration-review-input-v3.json" "str /api/runs/BLD-1842/artifacts/integration-review-input-v3.json" "dict ART-BLD-1842-INTEGRATION-REVIEW" "inputs_obj ART-BLD-1842-INTEGRATION-REVIEW"; do
  set -- $V
  echo "### variant $1 obj $2"
  B=$(python3 mkprobe.py "$1" "$2")
  curl -sS -m 20 -g --cacert '"$CA"' -u '"$CRED"' -H "Content-Type: application/json" -d "{\"template\":\"report-consumer-v2\",\"input\":{\"archive_base64\":\"$B\"}}" https://review.keplerops.test/api/jobs
  echo
done' 
