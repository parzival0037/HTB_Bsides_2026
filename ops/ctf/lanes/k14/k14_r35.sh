set +e
ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=8 rowan-dev 'bash -s' <<'RSH'
set +e
CA=$HOME/.local/share/keplerops/ca.crt
B=https://cloud-api.keplerops.test
U="rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"
WT=$(curl -sSk -m 10 -u "$U" -X POST -H 'Content-Type: application/json' -d '{}' "$B/api/workspaces/current/token-exchange" | python3 -c 'import sys,json;print(json.load(sys.stdin).get("access_token",""))')
EJ=$(curl -sSk -m 10 -X POST -H "Authorization: Bearer $WT" -H 'Content-Type: application/json' -d '{}' "$B/api/token-exchange/fieldkest-export-access" | python3 -c 'import sys,json;print(json.load(sys.stdin).get("access_token",""))')
export AWS_CA_BUNDLE=$CA
E=https://objects.keplerops.test
try(){ r="$1"; out=$(aws --endpoint-url $E sts assume-role-with-web-identity --role-session-name k14 --role-arn "arn:aws:iam::000000000000:role/$r" --web-identity-token "$EJ" 2>&1); if echo "$out" | grep -qi 'Credentials\|AccessKeyId'; then echo "FOUND $r"; echo "$out" | head -c 800; echo; else echo "no $r :: $(echo "$out" | grep -o 'role not found: [^ ]*\|An error occurred ([A-Za-z]*)' | head -1)"; fi; }
for r in \
 support-export-editor svc-fieldlink-export fieldkest-export fieldkest-exports fieldkest-export-access export-access support-export fieldlink-export fieldlink-export-access support-export-reader fieldkest-support-export support-export-editor-role role-support-export-editor fieldkest-role-support-export-editor k8s-svc-fieldlink-export \
 fieldkest/support-export-editor keplerops/support-export-editor fieldlink/support-export-editor service-role/support-export-editor k8s/support-export-editor workloads/support-export-editor \
 fieldkest/export fieldkest/export-access fieldkest/svc-fieldlink-export keplerops/svc-fieldlink-export fieldlink/svc-fieldlink-export k8s/svc-fieldlink-export \
 fieldkest/fieldkest-export-access fieldlink/fieldkest-export-access keplerops/fieldkest-export-access \
 fieldkest support exports export editor role/support-export-editor; do try "$r"; done
echo DONE_R35
RSH
echo FINISHED
