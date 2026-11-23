#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080 -k -sS --max-time 12"
echo "===== pivot"; curl -sS -m 15 --socks5-hostname 127.0.0.1:1080 -k -o /dev/null -w '%{http_code}\n' https://source.keplerops.test/
echo "===== TLS cert 10.77.60.20"
echo | timeout 15 openssl s_client -connect 10.77.60.20:443 -servername connector.arwc.test 2>/dev/null | openssl x509 -noout -subject -issuer -ext subjectAltName 2>&1
echo "===== HTTP root no host"
curl $P -o /tmp/o -w '[%{http_code}] ' https://10.77.60.20/ ; head -c 300 /tmp/o; echo
echo "===== Host-header probes on 10.77.60.20:443"
for H in hmi.arwc.test plc.arwc.test historian.arwc.test opcua.arwc.test arwc.test cairn.arwc.test fuxa.arwc.test scada.arwc.test plant.arwc.test portal.arwc.test records.arwc.test ot.arwc.test; do
  printf '%-24s ' "$H"
  curl $P -o /tmp/o -w '[%{http_code}] ' -H "Host: $H" https://10.77.60.20/ ; head -c 200 /tmp/o | tr '\n' ' '; echo
done
echo "===== path probes connector"
for p in / /health /api /api/health /status /api/status /version /api/version /assets /api/assets /api/tags /tags /api/tag-catalog /historian /api/historian /api/process /api/samples; do
  printf '%-20s ' "$p"
  curl $P -o /tmp/o -w '[%{http_code}] ' "https://connector.arwc.test$p"; head -c 200 /tmp/o | tr '\n' ' '; echo
done
echo "===== ports 10.77.60.20"
python3 - <<'PY'
import socket,concurrent.futures
ports=[22,80,443,3000,3389,4840,5432,502,102,1880,1881,8000,8080,8443,9090,10000,1502,2404,4000,5000,8888,61616]
def chk(p):
    s=socket.socket(); s.settimeout(1.2)
    try:
        s.connect(("10.77.60.20",p)); return p
    except Exception: return None
    finally: s.close()
with concurrent.futures.ThreadPoolExecutor(40) as ex:
    print([r for r in ex.map(chk,ports) if r])
PY
