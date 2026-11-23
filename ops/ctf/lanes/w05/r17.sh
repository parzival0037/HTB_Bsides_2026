#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
B=https://identity.keplerops.test
for r in master keplerops arwc fieldkest alterra ARWC KeplerOps fieldlink staff support; do
  for p in ".well-known/openid-configuration" "protocol/openid-connect/certs" ; do
    code=$(curl -sS $P -k -m 10 -o /tmp/k.$$ -w '%{http_code}' "$B/realms/$r/$p")
    echo "[$code] /realms/$r/$p :: $(head -c 300 /tmp/k.$$ | tr -d '\n')"
  done
done
echo "###### clients-registrations"
for r in keplerops arwc master fieldkest; do
  code=$(curl -sS $P -k -m 10 -o /tmp/k.$$ -w '%{http_code}' "$B/realms/$r/clients-registrations/openid-connect")
  echo "[$code] $r :: $(head -c 200 /tmp/k.$$|tr -d '\n')"
done
rm -f /tmp/k.$$
