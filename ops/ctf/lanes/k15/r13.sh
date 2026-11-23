set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'RSH'
set +e
CA=$HOME/.local/share/keplerops/ca.crt
A="Authorization: Basic $(printf 'rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo' | base64 -w0)"
for repo in fieldkest/connector-archive fieldkest/fieldlink-connector fieldkest/policy-compiler fieldkest/release-signer-history; do
echo "######## $repo"
curl -sS -m 15 -H "$A" --cacert "$CA" "https://source.keplerops.test/api/v1/repos/$repo/git/trees/main?recursive=true&per_page=200" | python3 -c "
import json,sys
try: d=json.load(sys.stdin)
except Exception as e: print('ERR',e); sys.exit()
for t in d.get('tree',[]): print(t['type'],t['path'])
" 2>&1 | head -40
done
echo "=== staff well-known"
curl -sS -m 10 --cacert "$CA" https://staff.keplerops.test/.well-known/fieldkest-client; echo
echo "=== workboard well-known"
curl -sS -m 10 --cacert "$CA" https://workboard.keplerops.test/.well-known/fieldkest-client; echo
RSH
