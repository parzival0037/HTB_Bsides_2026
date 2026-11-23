#!/bin/bash
set +e
P="--socks5-hostname 127.0.0.1:1080 -k -sS -m 12"
echo "== pivot"
curl $P -o /dev/null -w '%{http_code}\n' https://source.keplerops.test/
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=10 rowan-dev"
echo "== rowan hosts"
$S 'cat /etc/hosts; echo ---RESOLV; cat /etc/resolv.conf; echo ---HOSTNAME; hostname; echo ---GETENT; getent hosts connector.arwc.test source.keplerops.test' 2>&1
echo "== connector wellknown variants"
for p in /.well-known/fieldkest-client /.well-known/fieldkest-relay /.well-known/fieldkest-connector /api/fieldlink/.well-known/fieldkest-client /api/.well-known/fieldkest-client /api/fieldlink /api/fieldlink/ /api/fieldlink/status /api/fieldlink/health /api/fieldlink/process /api/fieldlink/read /api/fieldlink/planning /api/fieldlink/customers /api/fieldlink/exports /; do
  echo "--- $p"
  curl $P "https://connector.arwc.test$p" -w '\n[%{http_code}]\n' | head -c 900
  echo
done
echo "== arwc dns brute"
$S 'for h in planning planner allocation ledger meter meters process process-data feeds feed api portal water data reports report historian fuxa scada plant outlet reservoir crr-og2 arwc; do r=$(getent hosts $h.arwc.test | head -1); echo "$h.arwc.test => ${r:-NODNS}"; done' 2>&1
echo "== connector cert SAN"
echo | openssl s_client -connect 127.0.0.1:1080 2>/dev/null | head -1
echo DONE_A1
