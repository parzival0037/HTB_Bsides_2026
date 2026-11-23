#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
U='rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo'
G=https://source.keplerops.test
echo "== user repos =="
curl -sS -m 20 $P -u "$U" "$G/api/v1/user/repos?limit=100" | python3 -c 'import sys,json;d=json.load(sys.stdin);print([(r["full_name"],r.get("default_branch")) for r in d] if isinstance(d,list) else d)' 2>&1 | head -40
echo "== orgs =="
curl -sS -m 20 $P -u "$U" "$G/api/v1/orgs?limit=100" | head -c 1000; echo
for q in arwc relay inspection gate appointment contractor checkin cinder access outlet; do
  echo "== search $q =="
  curl -sS -m 20 $P -u "$U" "$G/api/v1/repos/search?q=$q&limit=20&exclusive=false" | python3 -c 'import sys,json;d=json.load(sys.stdin);print([r["full_name"] for r in d.get("data",[])])' 2>&1
done
echo "== fieldlink-connector tree =="
curl -sS -m 20 $P -u "$U" "$G/api/v1/repos/fieldkest/fieldlink-connector/git/trees/HEAD?recursive=true&per_page=100" | python3 -c 'import sys,json;d=json.load(sys.stdin);print("\n".join(t["path"] for t in d.get("tree",[])) if "tree" in d else d)' 2>&1 | head -120
echo "== source-tools well-known =="
curl -sS -m 15 $P -k https://source-tools.keplerops.test:8443/.well-known/fieldkest-client 2>&1 | head -c 1500; echo
