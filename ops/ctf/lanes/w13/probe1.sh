#!/bin/bash
echo "== connector cert =="
curl -sv -m 15 --socks5-hostname 127.0.0.1:1080 https://connector.arwc.test/ 2>&1 | grep -iE 'subject|issuer|start date|expire|SSL certificate|subjectAlt|TLS' | head -20
echo "== connector cert via openssl (socat?) =="
which socat proxychains4 proxychains 2>&1
echo "== .51.60 cert =="
curl -sv -m 15 --socks5-hostname 127.0.0.1:1080 https://10.77.51.60/ 2>&1 | grep -iE 'subject|issuer|HTTP/|SSL|server' | head -20
echo "== .51.60 body =="
curl -sS -m 15 --socks5-hostname 127.0.0.1:1080 -k https://10.77.51.60/ 2>&1 | head -20
echo "== POST probes on connector =="
for p in api/jobs api/exercises/connector-archive/run api/inspection-summary api/appointments api/checkin api/roster api/v1/jobs; do
  echo "--- POST /$p"
  curl -sS -m 10 --socks5-hostname 127.0.0.1:1080 -k -X POST -H 'Content-Type: application/json' -d '{}' -w '\n[%{http_code}]\n' "https://connector.arwc.test/$p" 2>&1 | head -5
done
