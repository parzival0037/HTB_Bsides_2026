#!/bin/bash
set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=10 -i /home/cinder/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
$S bash -s <<'REMOTE'
set +e
export PATH=$PATH:/usr/local/bin
cd /tmp; rm -rf npmx; mkdir npmx; cd npmx
echo "== versions"; npm view @keplerops/fieldlink-connector versions --json 2>&1 | tail -20
for v in 7.4.2 6.9.8; do
  echo "== pack $v"; npm pack @keplerops/fieldlink-connector@$v 2>&1 | tail -3
  mkdir -p v$v; tar xzf keplerops-fieldlink-connector-$v.tgz -C v$v 2>/dev/null
done
echo "== file list"
find . -type f | grep -v tgz | head -60
echo "== grep routes"
grep -rInE 'arwc|allocation|tariff|UsableVolume|export|planning|RPT-CRR|native' --include='*.js' --include='*.json' --include='*.md' . 2>/dev/null | grep -v 'node_modules' | head -80
echo "== binary strings"
strings -n 6 /home/rowan/repos/connector-archive/connector-archive/bin/fieldlink-connector 2>/dev/null | grep -iE 'http|/api|arwc|allocation|tariff|planning|export|native|observation|volume' | head -60
echo DONE_R11
REMOTE
