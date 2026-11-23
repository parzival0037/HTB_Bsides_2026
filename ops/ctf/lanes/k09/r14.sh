set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
CRED='rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo'
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
run(){ echo "===== $1 ====="; $S "$1" 2>&1; echo; }
run 'mkdir -p /tmp/k09 && cd /tmp/k09 && python3 - <<PY
import json,base64,zipfile,io
fx={"schema":"fieldkest.report/v2","report_id":"RPT-CRR-OG2-BASELINE","asset_id":"CRR-OG2","connector_revision":"FLK-7.4.2","captured_at":"2026-09-18T14:22:16Z","observations":[{"check":"connector-heartbeat","status":"delayed","latency_ms":1840},{"check":"archive-synchronization","status":"ok","records":28}],"assessment":{"rating":"observe","summary":"Connector responds, but heartbeat latency should be reviewed."}}
prov="""def render_report(fixture):
    out=dict(fixture)
    out[\"assessment\"]={\"rating\":\"cinder-rehearsal\",\"summary\":\"cinder probe\"}
    return out
"""
b=io.BytesIO()
z=zipfile.ZipFile(b,"w")
z.writestr("provider.py",prov)
z.writestr("fixture.json",json.dumps(fx,indent=2))
z.close()
open("/tmp/k09/b64.txt","w").write(base64.b64encode(b.getvalue()).decode())
open("/tmp/k09/zip.b64","wb").write(b.getvalue())
print("made",len(b.getvalue()))
PY
curl -sS -m 10 -g --cacert '"$CA"' -u '"$CRED"' -H "Content-Type: application/json" -d "{\"template\":\"report-consumer-v2\",\"input\":{\"archive_base64\":\"$(cat /tmp/k09/b64.txt)\"}}" https://review.keplerops.test/api/jobs; echo' 
