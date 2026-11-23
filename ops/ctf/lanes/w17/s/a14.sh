#!/bin/bash
SSH="ssh -i $HOME/.ssh/keplerops-foothold -o BatchMode=yes -o StrictHostKeyChecking=accept-new -o ConnectTimeout=8 rowan-dev"
$SSH 'echo ==edge; curl -sS -m 10 -k https://edge.keplerops.test/ -o /tmp/o -w "%{http_code}\n"; head -c 500 /tmp/o; echo
echo ==data; curl -sS -m 10 -k https://data.keplerops.test/ -o /tmp/o -w "%{http_code}\n"; head -c 300 /tmp/o; echo
echo ==sourcetools; echo | openssl s_client -connect 10.77.51.20:8443 -servername source-tools.keplerops.test 2>/dev/null | openssl x509 -noout -subject -ext subjectAltName 2>&1
for p in / /health /api /reference /.well-known/fieldkest-client; do echo "-- $p"; curl -sS -m 8 -k https://source-tools.keplerops.test:8443$p -o /tmp/o -w "%{http_code} "; head -c 200 /tmp/o; echo; done
echo ==sourceexercises
for p in /api/exercises /api/exercises/connector-archive/run; do echo "-- $p"; curl -sS -m 8 -k https://source.keplerops.test$p -o /tmp/o -w "%{http_code} "; head -c 300 /tmp/o; echo; done' 2>&1
