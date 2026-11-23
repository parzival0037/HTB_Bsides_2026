set +e
ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev 'bash -s' <<'RSH'
set +e
CA=$HOME/.local/share/keplerops/ca.crt
A="Authorization: Basic $(printf "rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo" | base64 -w0)"
for repo in fieldkest/fieldlink-connector fieldkest/connector-archive fieldkest/policy-compiler fieldkest/release-signer-history; do
 echo "###### $repo"
 curl -sS -m 20 --cacert $CA -H "$A" "https://source.keplerops.test/api/v1/repos/$repo/git/trees/main?recursive=true&per_page=200" -o /tmp/tree.json -w '[%{http_code}]\n'
 python3 - <<'PY'
import json
try:
 d=json.load(open('/tmp/tree.json'))
 for t in d.get('tree',[]):
  if t['type']=='blob': print(t['path'])
except Exception as e: print('ERR',e,open('/tmp/tree.json').read()[:200])
PY
done
RSH
echo DONE_A4
