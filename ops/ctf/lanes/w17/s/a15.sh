#!/bin/bash
SSH="ssh -i $HOME/.ssh/keplerops-foothold -o BatchMode=yes -o StrictHostKeyChecking=accept-new -o ConnectTimeout=8 rowan-dev"
$SSH 'for u in https://source-tools.keplerops.test:8443/.well-known/fieldkest-client https://review.keplerops.test/.well-known/fieldkest-client https://delivery.keplerops.test:8443/.well-known/fieldkest-client https://delivery.keplerops.test/.well-known/fieldkest-client https://cloud.keplerops.test/.well-known/fieldkest-client https://foundation.keplerops.test/.well-known/fieldkest-client; do echo "##### $u"; curl -sS -m 10 -k "$u" -o /tmp/o -w "[%{http_code}]\n"; head -c 2000 /tmp/o; echo; done
echo "== DNS"
for h in delivery foundation git registry cloud workboard preview indexer; do echo "$h => $(getent hosts $h.keplerops.test|head -1)"; done' 2>&1
