#!/bin/bash
KO="ssh -i $HOME/.ssh/keplerops-foothold -p 2222 -o StrictHostKeyChecking=no -o ConnectTimeout=10 rowan@10.50.13.180"
$KO '
cd /tmp && rm -rf pk && mkdir pk && cd pk
for v in 7.4.2 6.9.8; do
  curl -sS -k -u rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo -o $v.tgz "https://packages.keplerops.test/@keplerops/fieldlink-connector/-/fieldlink-connector-$v.tgz"
  echo "===== $v $(ls -l $v.tgz | awk "{print \$5}")"
  tar xzf $v.tgz && mv package p$v
done
for d in p7.4.2 p6.9.8; do echo "########## $d"; find $d -type f | sort; for f in $d/package.json $d/README.md $d/limits.json $d/index.js; do echo "##### $f"; head -c 4000 "$f" 2>/dev/null; echo; done; done
' 2>&1
