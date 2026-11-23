set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'CA=$HOME/.local/share/keplerops/ca.crt
A="Authorization: Basic $(printf "rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo" | base64 -w0)"
G="https://source.keplerops.test/api/v1/repos"
for repo in fieldkest/connector-archive fieldkest/fieldlink-connector fieldkest/release-signer-history fieldkest/policy-compiler; do
echo "######## $repo"
curl -sS -m 15 -H "$A" "$G/$repo/git/trees/main?recursive=true" --cacert $CA | python3 -c "
import json,sys
d=json.load(sys.stdin)
for t in d.get(\"tree\",[]): print(t[\"type\"], t[\"path\"])
" 2>&1 | head -40
done' 2>&1 | tail -80
