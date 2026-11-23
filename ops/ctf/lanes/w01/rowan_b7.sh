#!/bin/bash
S="ssh -o StrictHostKeyChecking=no -o BatchMode=yes -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
$S 'cat > /tmp/b7.sh' <<'EOS'
#!/bin/bash
C="curl -sS -k --max-time 20"
D="rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"
echo "### disk usage of bucket listing"
echo "### workspace exchange"
$C -u "$D" https://cloud-api.keplerops.test/api/workspaces/current/token-exchange; echo
echo "### POST exchange"
WT=$($C -u "$D" -X POST -H 'Content-Type: application/json' -d '{}' https://cloud-api.keplerops.test/api/workspaces/current/token-exchange | python3 -c 'import sys,json; print(json.load(sys.stdin).get("access_token",""))')
echo "token len ${#WT}"
echo "### maintenance with workload token"
$C -i -H "Authorization: Bearer $WT" https://cloud-api.keplerops.test/api/maintenance | head -c 2500; echo
echo "### anonymous bucket listing fieldkest-workspaces"
$C https://objects.keplerops.test/fieldkest-workspaces/ | head -c 3000; echo
echo "### list buckets anon"
$C https://objects.keplerops.test/ | head -c 1500; echo
echo "### s3 ls recursive fieldlink-exports (aws)"
aws --endpoint-url https://objects.keplerops.test s3 ls --recursive s3://fieldlink-exports 2>&1 | head -60
EOS
chmod +x /tmp/b7.sh
$S 'bash /tmp/b7.sh' 2>&1 | head -180
