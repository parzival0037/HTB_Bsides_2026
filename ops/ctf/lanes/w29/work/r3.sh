#!/bin/bash
set +e
P="--socks5-hostname 127.0.0.1:1080 -k -sS -m 20"
T=fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo
for repo in fieldkest/fieldlink-connector fieldkest/connector-archive; do
 echo "########## $repo"
 curl $P -u rowan.ito:$T "https://source.keplerops.test/api/v1/repos/$repo/branches" | python3 -c 'import sys,json
d=json.load(sys.stdin)
[print("branch",b["name"],b["commit"]["id"][:10],b["commit"]["message"].split("\n")[0]) for b in d]' 2>&1 | head -20
 for ref in main; do
  curl $P -u rowan.ito:$T "https://source.keplerops.test/api/v1/repos/$repo/git/trees/$ref?recursive=true&per_page=200" -o /tmp/tree.json
  python3 -c 'import sys,json
d=json.load(open("/tmp/tree.json"))
for e in d.get("tree",[]):
    print(e["type"],e["path"])' 2>&1 | head -80
 done
done
echo DONE_R3
