set +e
B=https://cloud-api.keplerops.test
JWT=$(kubectl config view --raw -o jsonpath='{.users[0].user.token}')
echo "== JWT claims =="
python3 - "$JWT" <<'PY'
import sys,base64,json
t=sys.argv[1].split('.')[1]
t+='='*(-len(t)%4)
print(json.dumps(json.loads(base64.urlsafe_b64decode(t)),indent=1)[:2000])
PY
echo "== cloud-api sweep =="
for p in api/maintenance api/exports/EXP-2841 api/exports/EXP-2841/definition api/schedules/SCHED-2841 api/build-records/1842 api/trust-records/TR-1 api/policies/default api/workspaces api/workspaces/current; do
  code=$(curl -sSk -m 8 -o /tmp/c -w '%{http_code}' -H "Authorization: Bearer $JWT" "$B/$p")
  echo "-- $p -> $code $(head -c 300 /tmp/c)"
done
echo "== token-exchange full-subject role =="
for r in 'system:serviceaccount:fieldlink:rowan-workspace' 'system%3Aserviceaccount%3Afieldlink%3Arowan-workspace'; do
  code=$(curl -sSk -m 8 -o /tmp/t -w '%{http_code}' -X POST -H "Authorization: Bearer $JWT" -H 'Content-Type: application/json' -d '{}' "$B/api/token-exchange/$r")
  echo "-- $r -> $code $(head -c 300 /tmp/t)"
done
echo "== objects STS web identity =="
curl -sSk -m 10 -i -X POST "https://objects.keplerops.test/?Action=AssumeRoleWithWebIdentity&Version=2011-06-15&WebIdentityToken=$JWT&DurationSeconds=3600" | head -30
echo "== objects STS get =="
curl -sSk -m 10 "https://objects.keplerops.test/?Action=AssumeRoleWithWebIdentity&Version=2011-06-15&WebIdentityToken=$JWT" | head -c 1000; echo
echo "== k8s token attempts =="
for sa in workload fieldlink-workload default rowan-workspace; do echo "-- $sa"; kubectl -n fieldlink create token $sa 2>&1 | head -3; done
kubectl auth can-i create serviceaccounts/token -n fieldlink 2>&1
