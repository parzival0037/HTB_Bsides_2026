#!/bin/bash
SSH="ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 -i $HOME/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
$SSH 'bash -s' <<'INNER'
echo "===== arwc_key detail"
ls -l /tmp/arwc_key; tail -c 80 /tmp/arwc_key | od -c | tail -5
echo "===== ssh-keygen on /tmp/arwc_key"
ssh-keygen -y -f /tmp/arwc_key 2>&1 | head -5
echo "===== fetch key from job properly"
python3 - <<'PY'
import json,subprocess,os
CA=os.path.expanduser('~/.local/share/keplerops/ca.crt')
SB='Bearer fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b'
B='https://support.keplerops.test:8443'
def call(method,url):
    a=['curl','--cacert',CA,'-s','-m','15','-X',method,'-H','Authorization: '+SB,url]
    return subprocess.run(a,capture_output=True,text=True).stdout
d=json.loads(call('GET',B+'/api/diagnostics/DIAG-ARWC-5589244C'))
ma=d['maintenance_access']
k=ma['private_key_openssh']
open('/tmp/w10_key2','w').write(k); os.chmod('/tmp/w10_key2',0o600)
print("user",ma.get('user'),"host",ma.get('host'),"len",len(k))
print(repr(k[-60:]))
PY
ls -l /tmp/w10_key2; ssh-keygen -y -f /tmp/w10_key2 2>&1 | head -3
echo "===== try ssh variants"
for u in fieldlink arwc connector maintenance; do echo "--- $u"; timeout 10 ssh -o StrictHostKeyChecking=no -o BatchMode=yes -o ConnectTimeout=6 -i /tmp/w10_key2 $u@connector.arwc.test 'id; hostname' 2>&1 | tail -3; done
INNER
