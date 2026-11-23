#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
CA=/tmp/ca.crt
[ -f $CA ] || exit 9
echo "=== rowan-dev /etc/hosts ==="
ssh -i /home/cinder/.ssh/keplerops-foothold -p 2222 -o StrictHostKeyChecking=no rowan@10.50.13.180 'cat /etc/hosts' 2>/dev/null | grep -Ei 'delivery|arwc|supplier|planning|cairn'
for h in delivery.keplerops.test:8443 source-tools.keplerops.test:8443 review.keplerops.test support.keplerops.test ticket.keplerops.test; do
  echo "########## https://$h/.well-known/fieldkest-client"
  curl -sS $P --cacert $CA --max-time 20 "https://$h/.well-known/fieldkest-client"; echo
done
echo "########## delivery root"
curl -sS $P --cacert $CA --max-time 20 -i "https://delivery.keplerops.test:8443/" | head -30
