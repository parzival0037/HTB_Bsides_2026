set +e
C="curl -sSk -m 20 --socks5-hostname 127.0.0.1:1080"
B=https://cloud-api.keplerops.test
K=https://cloud-api.keplerops.test:6443
U="rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"
WT=$($C -u "$U" -X POST -H 'Content-Type: application/json' -d '{}' "$B/api/workspaces/current/token-exchange" | python3 -c 'import sys,json;print(json.load(sys.stdin).get("access_token",""))')
EJ=$($C -X POST -H "Authorization: Bearer $WT" -H 'Content-Type: application/json' -d '{}' "$B/api/token-exchange/fieldkest-export-access" | python3 -c 'import sys,json;print(json.load(sys.stdin).get("access_token",""))')
echo "===== STS with RoleSessionName"
$C -m 15 -X POST "https://objects.keplerops.test/?Action=AssumeRoleWithWebIdentity&Version=2011-06-15&RoleSessionName=cinder&WebIdentityToken=$EJ&DurationSeconds=3600" > /tmp/sts.xml
head -c 2000 /tmp/sts.xml; echo
python3 - <<'PY'
import re
s=open('/tmp/sts.xml').read()
def g(t):
    m=re.search(r'<'+t+r'>([^<]+)</'+t+r'>',s); return m.group(1) if m else ''
creds=(g('AccessKeyId'),g('SecretAccessKey'),g('SessionToken'))
open('/tmp/sts.env','w').write('AK=%s\nSK=%s\nST=%s\n'%creds)
print('PARSED', 'yes' if creds[0] else 'no')
PY
. /tmp/sts.env 2>/dev/null
if [ -n "$AK" ]; then
  echo "===== AWS on rowan-dev with STS creds"
  ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev "AWS_ACCESS_KEY_ID='$AK' AWS_SECRET_ACCESS_KEY='$SK' AWS_SESSION_TOKEN='$ST' AWS_DEFAULT_REGION=us-east-1 aws --endpoint-url https://objects.keplerops.test --no-verify-ssl s3 ls s3://fieldkest-exports/ 2>&1 | head -30; echo ---; for k in EXP-2841-maya EXP-2841-rowan EXP-2841-maya/ EXP-2841-rowan/; do echo \"## \$k\"; AWS_ACCESS_KEY_ID='$AK' AWS_SECRET_ACCESS_KEY='$SK' AWS_SESSION_TOKEN='$ST' aws --endpoint-url https://objects.keplerops.test --no-verify-ssl s3 cp \"s3://fieldkest-exports/\$k\" - 2>&1 | head -c 500; echo; done" 2>&1 | head -80
fi
echo "===== PATCH ASSIGNMENT -> field-operator-b"
$C -m 12 -X PATCH -H "Authorization: Bearer $EJ" -H 'Content-Type: application/json-patch+json' \
 -d '[{"op":"replace","path":"/spec/jobTemplate/spec/template/spec/containers/0/env/2/value","value":"field-operator-b"}]' \
 -o /tmp/cj2 -w '[%{http_code}]\n' "$K/apis/batch/v1/namespaces/fieldlink/cronjobs/sched-2841"
head -c 300 /tmp/cj2; echo
echo "===== run after assignment change"
$C -m 20 -X POST -H "Authorization: Bearer $EJ" -H 'Content-Type: application/json' -d '{}' -w '\n[%{http_code}]\n' "$B/api/schedules/SCHED-2841/runs" | head -c 2000; echo
