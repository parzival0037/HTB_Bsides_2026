#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
python3 -m pip install -q pysocks 2>/dev/null
cat > /tmp/cert.py <<'PY'
import socks,ssl,socket,sys
def cert(host,port=443,sni=None,ip=None):
    s=socks.create_connection((host,port),proxy_type=socks.SOCKS5,proxy_addr='127.0.0.1',proxy_port=1080,timeout=8)
    ctx=ssl._create_unverified_context()
    ss=ctx.wrap_socket(s,server_hostname=sni or host)
    c=ss.getpeercert()
    print(host,port,'SNI',sni,'SUBJ',c.get('subject'),'SAN',c.get('subjectAltName'))
for h in ['10.77.51.60','10.77.50.11','connector.arwc.test','10.77.60.20','10.77.51.20','10.77.50.11']:
    for p in [443,8443]:
        for sni in [None,'connector.arwc.test','arwc.test']:
            try: cert(h,p,sni)
            except Exception as e: pass
PY
python3 /tmp/cert.py 2>&1 | sort -u | head -40
echo "==== auth tests on 10.77.51.60 ===="
for h in portal.arwc.test connector.arwc.test checkin.arwc.test appointment.arwc.test gate.arwc.test; do
 for a in "" "-H Authorization:Bearer\ fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b" "-H X-Integration-Token:fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b"; do :; done
 echo "--- Host $h"
 curl -sS -m 10 $P -k -H "Host: $h" -w '\n[%{http_code}]\n' https://10.77.51.60/ 2>&1 | head -5
 curl -sS -m 10 $P -k -H "Host: $h" -H "Authorization: Bearer fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b" -w '\n[%{http_code}]\n' https://10.77.51.60/ 2>&1 | head -5
done
echo "==== no host / default ===="
curl -sS -m 10 $P -k -i https://10.77.51.60/ 2>&1 | head -20
echo "==== 10.77.51.60:8443 ===="
curl -sS -m 10 $P -k -i https://10.77.51.60:8443/ 2>&1 | head -20
