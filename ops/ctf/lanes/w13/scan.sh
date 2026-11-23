#!/bin/bash
set -x
python3 -c "import socks" 2>/dev/null || pip install pysocks --quiet 2>&1 | tail -2
cat > /tmp/scan.py <<'PYEOF'
import socks, socket, ssl, concurrent.futures as cf
PROXY=('127.0.0.1',1080)
def chk(args):
    ip,port=args
    s=socks.socksocket()
    s.set_proxy(socks.SOCKS5,*PROXY)
    s.settimeout(2.5)
    try:
        s.connect((ip,port)); 
        banner=b''
        try:
            s.settimeout(1.5); banner=s.recv(200)
        except Exception: pass
        return (ip,port,banner[:80])
    except Exception:
        return None
    finally:
        try: s.close()
        except: pass
targets=[]
for net in ('10.77.60.','10.77.61.'):
    for i in range(1,255):
        for p in (22,80,443,3000,8000,8080,8081,8082,8083,8443,9090,5000):
            targets.append((net+str(i),p))
res=[]
with cf.ThreadPoolExecutor(max_workers=120) as ex:
    for r in ex.map(chk,targets):
        if r: res.append(r)
for r in res: print(r)
PYEOF
python3 /tmp/scan.py
echo "== cert =="
cat > /tmp/cert.py <<'PYEOF'
import socks,ssl,socket
s=socks.socksocket(); s.set_proxy(socks.SOCKS5,'127.0.0.1',1080); s.settimeout(5)
s.connect(('connector.arwc.test',443))
ctx=ssl.create_default_context(); ctx.check_hostname=False; ctx.verify_mode=ssl.CERT_NONE
ss=ctx.wrap_socket(s,server_hostname='connector.arwc.test')
print(ss.getpeercert(binary_form=True).hex()[:0])
import ssl as _s
cert=_s.DER_cert_to_PEM_cert(ss.getpeercert(True))
print(cert)
PYEOF
python3 /tmp/cert.py > /tmp/cert.pem 2>&1; openssl x509 -in /tmp/cert.pem -noout -subject -issuer -ext subjectAltName 2>&1 | head -20
