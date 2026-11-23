set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'CA=$HOME/.local/share/keplerops/ca.crt
A="Authorization: Basic $(printf "rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo" | base64 -w0)"
echo "=== grep reconcile in work"; grep -rIn "reconcile\|tenant-package\|selection" work 2>/dev/null | head -20
echo "=== gitea repos"; curl -sS -m 15 -H "$A" "https://source.keplerops.test/api/v1/user/repos" --cacert $CA | python3 -c "import json,sys; d=json.load(sys.stdin); [print(r[\"full_name\"], r.get(\"description\",\"\")) for r in d]" 2>&1 | head -20
echo "=== s3"; export AWS_CA_BUNDLE=$CA; aws --endpoint-url https://objects.keplerops.test s3 ls 2>&1 | head; echo "--"; aws --endpoint-url https://objects.keplerops.test s3 ls s3://fieldk-exports 2>&1 | head -20
echo "=== indexer well-known"; curl -sS -m 10 "https://indexer.keplerops.test/.well-known/fieldkest-client" --cacert $CA | head -c 800; echo
' 2>&1 | tail -50
