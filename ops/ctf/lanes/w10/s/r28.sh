#!/bin/bash
echo "===== tools on box"
which ffuf gobuster feroxbuster dirb wfuzz nmap 2>&1
ls /usr/share/seclists/Discovery/Web-Content 2>/dev/null | head
echo "===== dns wildcard + hosts"
SSH="ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 -i $HOME/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
$SSH 'bash -s' <<'INNER'
for n in zzz.keplerops.test zzz.arwc.test reports.keplerops.test report.keplerops.test report-assistant.keplerops.test assistant.arwc.test reports.arwc.test; do printf "%-32s " $n; getent hosts $n | awk '{print $1}' | tr "\n" " "; echo; done
echo "===== cert details"
echo | openssl s_client -connect assistant.keplerops.test:443 -servername assistant.keplerops.test 2>/dev/null | openssl x509 -noout -subject -issuer -ext subjectAltName 2>/dev/null
echo "----- connector"
echo | openssl s_client -connect connector.arwc.test:443 -servername connector.arwc.test 2>/dev/null | openssl x509 -noout -subject -issuer -ext subjectAltName 2>/dev/null
INNER
echo "===== AI token headers"
curl -sS --socks5-hostname 127.0.0.1:1080 -k -m 15 -i -X POST https://assistant.keplerops.test/api/request-token -H 'Content-Type: application/json' -d '{"username":"rowan.ito","password":"fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"}' 2>&1 | head -40
