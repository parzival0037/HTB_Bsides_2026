#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
C=/home/kali/ctf/lanes/k01 2>/dev/null
CA=/tmp/ca.crt
echo "== pivot =="; tmux ls 2>/dev/null
curl -sS -m 15 $P --cacert $CA -o /dev/null -w 'source %{http_code}\n' https://source.keplerops.test/ 2>&1
echo "== connector well-known/root =="
for u in / /.well-known/fieldkest-client /.well-known/fieldkest /.well-known/security.txt /robots.txt /health /api /api/health /status /api/v1 /openapi.json /api/openapi.json; do
  echo "--- $u"
  curl -sS -m 12 $P -k -D- "https://connector.arwc.test$u" 2>&1 | head -25
done
echo "== TLS SANs connector =="
echo | timeout 15 openssl s_client -connect connector.arwc.test:443 -servername connector.arwc.test -proxy 127.0.0.1:1080 2>/dev/null | openssl x509 -noout -text 2>/dev/null | grep -A3 'Subject Alternative Name'
echo "== gitea repos (rowan token) =="
T='fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo'
for ep in "/api/v1/user/repos?limit=50" "/api/v1/repos/search?q=arwc&limit=50" "/api/v1/repos/search?q=field&limit=50" "/api/v1/orgs?limit=50"; do
  echo "--- $ep"
  curl -sS -m 20 $P --cacert $CA -H "Authorization: token $T" "https://source.keplerops.test$ep" 2>&1 | head -c 4000
  echo
done
