#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
H='ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ConnectTimeout=8 -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180'
echo "===== rowan-dev /etc/hosts"
$H 'cat /etc/hosts' 2>/dev/null
echo "===== quick probes"
for h in preview indexer tickets assistant workloads llm data ca id support cert cloud-api objects staff workboard review source packages ci; do
  for p in "" health api .well-known/fieldkest-client; do
    out=$(curl -sS $P -k -m 8 -o /tmp/b.$$ -w '%{http_code}' "https://$h.keplerops.test/$p" 2>/dev/null)
    b=$(head -c 120 /tmp/b.$$ | tr -d '\n' | tr -s ' ')
    echo "[$out] https://$h.keplerops.test/$p :: $b"
  done
done
rm -f /tmp/b.$$
