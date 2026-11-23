#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
A="-u rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"
G=https://source.keplerops.test
for repo in fieldkest/fieldlink-connector fieldkest/connector-archive fieldkest/policy-compiler fieldkest/release-signer-history; do
 echo "##### $repo"
 curl -sS $P -k -m 20 $A "$G/api/v1/repos/$repo/git/trees/HEAD?recursive=true&per_page=200" | python3 -c "
import sys,json
d=json.load(sys.stdin)
for t in d.get('tree',[])[:200]: print(t['type'], t['path'])
" 2>/dev/null | head -80
done
