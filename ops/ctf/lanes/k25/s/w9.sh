S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'RSH'
set +e
TOK=fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo
CA=/home/rowan/.local/share/keplerops/ca.crt
B=https://source.keplerops.test
echo "=== user repos"
curl -sSk --cacert $CA -m 20 -u "rowan.ito:$TOK" "$B/api/v1/user/repos?limit=100" | python3 -c "import json,sys;d=json.load(sys.stdin);print(len(d));[print(r['full_name'],r.get('empty'),r.get('default_branch'),r.get('updated_at')) for r in d]" 2>&1
echo "=== org repos fieldkest"
curl -sSk --cacert $CA -m 20 -u "rowan.ito:$TOK" "$B/api/v1/orgs/fieldkest/repos?limit=100" | python3 -c "import json,sys;d=json.load(sys.stdin);[print(r['full_name']) for r in d]" 2>&1 | head -40
echo "=== repos dir"
ls -la ~/repos ~/repos_k05 2>&1
cd /tmp && rm -rf grepos && mkdir grepos && cd grepos
for r in fieldlink-connector connector-archive policy-compiler release-signer-history; do
  git -c http.sslCAInfo=$CA clone -q "https://rowan.ito:$TOK@source.keplerops.test/fieldkest/$r.git" 2>&1 | tail -1
done
echo "=== grep codes"
grep -rIn "record_binding_mismatch\|tenant-package\|reconcile" . 2>/dev/null | grep -v '\.git/' | head -40
echo "=== all repo files"
find . -path '*/.git' -prune -o -type f -print | head -60
RSH
