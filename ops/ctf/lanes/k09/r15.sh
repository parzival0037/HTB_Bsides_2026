set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
CRED='rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo'
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
run(){ echo "===== $1 ====="; $S "$1" 2>&1; echo; }
run 'mkdir -p /tmp/k09 && cd /tmp/k09 && curl -sS -g --cacert '"$CA"' -u '"$CRED"' "https://source.keplerops.test/api/v1/repos/fieldkest/fieldlink-connector/contents/fixtures/report-crr-og2.json?ref=80560bcf8381c36ef82be771e58fc164a349ea07" > fx.json && python3 - <<PY
import json,base64,zipfile,io,hashlib
j=json.load(open("fx.json"))
raw=base64.b64decode(j["content"])
open("fixture.json","wb").write(raw)
print("fixture bytes",len(raw),hashlib.sha256(raw).hexdigest())
prov="""def render_report(fixture):
    out=dict(fixture)
    out[\"assessment\"]={\"rating\":\"cinder-rehearsal\",\"summary\":\"cinder probe\"}
    return out
"""
b=io.BytesIO()
z=zipfile.ZipFile(b,"w")
z.writestr("provider.py",prov)
z.writestr("fixture.json",raw)
z.close()
open("b64.txt","w").write(base64.b64encode(b.getvalue()).decode())
print("zip",len(b.getvalue()))
PY
curl -sS -m 20 -g --cacert '"$CA"' -u '"$CRED"' -H "Content-Type: application/json" -d "{\"template\":\"report-consumer-v2\",\"input\":{\"archive_base64\":\"$(cat b64.txt)\"}}" https://review.keplerops.test/api/jobs; echo' 
