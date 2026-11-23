#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
U='rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo'
G=https://source.keplerops.test
tree(){ curl -sS -m 25 $P -k -u "$U" "$G/api/v1/repos/$1/git/trees/HEAD?recursive=true&per_page=300" | python3 -c 'import sys,json;d=json.load(sys.stdin);print("\n".join(t["path"] for t in d.get("tree",[]))) if "tree" in d else print(json.dumps(d)[:800])'; }
for r in fieldkest/connector-archive fieldkest/release-signer-history fieldkest/policy-compiler; do
 echo "===== $r"; tree $r | head -120
done
echo "===== connector-archive README"
curl -sS -m 20 $P -k -u "$U" "$G/api/v1/repos/fieldkest/connector-archive/raw/README.md" 2>&1 | head -80
echo "===== recent commits all repos"
for r in fieldkest/connector-archive fieldkest/fieldlink-connector fieldkest/release-signer-history fieldkest/policy-compiler; do
 echo "--- $r"
 curl -sS -m 20 $P -k -u "$U" "$G/api/v1/repos/$r/commits?limit=10" | python3 -c 'import sys,json;d=json.load(sys.stdin);[print(c["sha"][:10],c["commit"]["message"].splitlines()[0]) for c in d]' 2>&1 | head -12
 echo "--- branches/tags"
 curl -sS -m 20 $P -k -u "$U" "$G/api/v1/repos/$r/tags?limit=20" | python3 -c 'import sys,json;d=json.load(sys.stdin);print([t["name"] for t in d])' 2>&1
 curl -sS -m 20 $P -k -u "$U" "$G/api/v1/repos/$r/branches?limit=20" | python3 -c 'import sys,json;d=json.load(sys.stdin);print([t["name"] for t in d])' 2>&1
done
