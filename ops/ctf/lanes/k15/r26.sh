set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'RSH'
set +e
C=https://cloud-api.keplerops.test
BASIC=$(printf 'rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo' | base64 -w0)
W=$(curl -sS -m 15 -k -X POST -H "Authorization: Basic $BASIC" -H "Content-Type: application/json" -d '{}' "$C/api/workspaces/current/token-exchange" | python3 -c 'import json,sys;print(json.load(sys.stdin)["access_token"])')
for role in export export-reader reader writer runner report reconcile; do
  echo "=== $role"
  curl -sS -m 12 -k -X POST -H "Authorization: Bearer $W" -H "Content-Type: application/json" -d '{}' "$C/api/token-exchange/$role" > /tmp/re.json
  python3 - <<'PY'
import json,base64
d=json.load(open('/tmp/re.json'))
print({k:(v[:20]+'...' if k=='access_token' else v) for k,v in d.items()})
t=d.get('access_token','')
if t:
    p=t.split('.')[1]; p+='='*(-len(p)%4)
    print('JWT payload:', json.loads(base64.urlsafe_b64decode(p)))
PY
done
RSH
