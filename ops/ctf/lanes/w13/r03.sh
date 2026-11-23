#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
U='rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo'
G=https://source.keplerops.test
jqit(){ python3 -c 'import sys,json
try:
 d=json.load(sys.stdin)
except Exception as e:
 print("PARSE_FAIL"); sys.exit()
if isinstance(d,list):
 for r in d: print(r.get("full_name") or r.get("name") or r)
elif isinstance(d,dict):
 if "data" in d:
  for r in d["data"]: print(r.get("full_name") or r)
 else: print(json.dumps(d)[:1500])'; }
echo "== user repos =="
curl -sS -m 25 $P -k -u "$U" "$G/api/v1/user/repos?limit=100" | jqit
echo "== orgs =="
curl -sS -m 25 $P -k -u "$U" "$G/api/v1/orgs?limit=100" | jqit
for q in arwc relay inspection gate appointment contractor checkin cinder access outlet connector; do
  echo "== search $q =="
  curl -sS -m 25 $P -k -u "$U" "$G/api/v1/repos/search?q=$q&limit=20" | jqit
done
echo "== fieldlink-connector tree =="
curl -sS -m 25 $P -k -u "$U" "$G/api/v1/repos/fieldkest/fieldlink-connector/git/trees/HEAD?recursive=true&per_page=200" | python3 -c 'import sys,json;d=json.load(sys.stdin);print("\n".join(t["path"] for t in d.get("tree",[]))) if "tree" in d else print(json.dumps(d)[:1000])' 2>&1 | head -150
