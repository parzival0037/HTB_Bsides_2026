set +e
C="curl -sSk -m 20 --socks5-hostname 127.0.0.1:1080"
B=https://cloud-api.keplerops.test
K=https://cloud-api.keplerops.test:6443
U="rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"
WT=$($C -u "$U" -X POST -H 'Content-Type: application/json' -d '{}' "$B/api/workspaces/current/token-exchange" | python3 -c 'import sys,json;print(json.load(sys.stdin).get("access_token",""))')
EJ=$($C -X POST -H "Authorization: Bearer $WT" -H 'Content-Type: application/json' -d '{}' "$B/api/token-exchange/fieldkest-export-access" | python3 -c 'import sys,json;print(json.load(sys.stdin).get("access_token",""))')
echo "===== STS with export JWT"
$C -m 15 -X POST "https://objects.keplerops.test/?Action=AssumeRoleWithWebIdentity&Version=2011-06-15&WebIdentityToken=$EJ&DurationSeconds=3600" -w '\n[%{http_code}]\n' | head -c 2500; echo
echo "===== PATCH cronjob add MARKER=cinder"
$C -m 12 -X PATCH -H "Authorization: Bearer $EJ" -H 'Content-Type: application/json-patch+json' \
 -d '[{"op":"add","path":"/spec/jobTemplate/spec/template/spec/containers/0/env/-","value":{"name":"MARKER","value":"cinder"}}]' \
 -w '\n[%{http_code}]\n' "$K/apis/batch/v1/namespaces/fieldlink/cronjobs/sched-2841" | head -c 600; echo
echo "===== env after patch"
$C -m 12 -H "Authorization: Bearer $EJ" "$K/apis/batch/v1/namespaces/fieldlink/cronjobs/sched-2841" | python3 -c 'import sys,json; d=json.load(sys.stdin); c=d["spec"]["jobTemplate"]["spec"]["template"]["spec"]["containers"][0]; print(json.dumps({k:c.get(k) for k in ("name","image","command","env")},indent=1))' 2>&1 | head -60
echo "===== schedule record after patch (EJ)"
$C -m 12 -H "Authorization: Bearer $EJ" -w '\n[%{http_code}]\n' "$B/api/schedules/SCHED-2841" | head -c 1200; echo
echo "===== rehearsal run POST (EJ, {})"
$C -m 20 -X POST -H "Authorization: Bearer $EJ" -H 'Content-Type: application/json' -d '{}' -w '\n[%{http_code}]\n' "$B/api/schedules/SCHED-2841/runs" | head -c 2000; echo
echo "===== rowan-dev marker grep"
ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev "grep -rniE 'marker|cinder' ~/work ~/repos /opt/fieldkest-workbench 2>/dev/null | head -30" 2>&1 | head -40
