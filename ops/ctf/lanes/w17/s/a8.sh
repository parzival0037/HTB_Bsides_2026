#!/bin/bash
SSH="ssh -i $HOME/.ssh/keplerops-foothold -o BatchMode=yes -o StrictHostKeyChecking=accept-new -o ConnectTimeout=8 rowan-dev"
$SSH 'H=connector.arwc.test
echo ==cert; echo | openssl s_client -connect 10.77.60.20:443 -servername $H 2>/dev/null | openssl x509 -noout -subject -ext subjectAltName 2>&1
for p in / /.well-known/arwc-client /.well-known/fieldkest-client /.well-known/security.txt /robots.txt /health /healthz /api /api/ /api/v1 /openapi.json /docs /redoc /metrics /status /version /engineering /engineering/reference /reference /tags /api/tags /api/plant; do
  out=$(curl -sS -m 8 -k --resolve $H:443:10.77.60.20 -D /tmp/h -o /tmp/o -w "%{http_code}" "https://$H$p" 2>/dev/null)
  echo "== $p -> $out $(head -c 200 /tmp/o|tr -d "\n")"
  grep -i "^content-type\|^location\|^server" /tmp/h | head -3
done' 2>&1
