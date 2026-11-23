#!/bin/bash
ls /usr/share/wordlists/ 2>/dev/null; which ffuf gobuster feroxbuster dirb 2>/dev/null
P="--socks5-hostname 127.0.0.1:1080"
B=https://connector.arwc.test
for p in api api/ api/v1 api/fieldlink api/fieldlink/ api/fieldlink/packages api/fieldlink/packages/poll api/connector api/status api/version api/health api/session api/sessions api/staff api/staff/ api/employees api/enrollment api/enrollments api/onboarding api/onboarding/ onboarding onboarding.html starter starter-pack starter_pack welcome docs doc assets static files file download upload downloads exports export artifacts archive; do
  out=$(curl -sS $P -k -m 8 -o /tmp/b.$$ -w '%{http_code} %{size_download}' "$B/$p" 2>/dev/null)
  body=$(head -c 160 /tmp/b.$$ | tr -d '\n')
  echo "$out /$p :: $body"
done
rm -f /tmp/b.$$
