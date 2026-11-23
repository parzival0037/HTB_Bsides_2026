set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'RSH'
set +e
CA=$HOME/.local/share/keplerops/ca.crt
for h in workloads workload cloud-api delivery indexer tickets workboard id cert; do
  echo "=== $h"
  for port in "" ":8443"; do
    out=$(curl -sS -m 8 --cacert "$CA" "https://$h.keplerops.test$port/.well-known/fieldkest-client" 2>&1 | head -c 1200)
    echo "-- $h$port: $out"
  done
done
echo "=== PG privs"
export PGPASSWORD=lobf9Jt0SBW433in6wUVlkixnQreh5K-Z1LjbTofrqY
P="psql -h data.keplerops.test -U rowan_data -d fieldlink_data -At"
$P -c "select current_user, session_user, current_database()"
$P -c "select table_schema,table_name,privilege_type from information_schema.role_table_grants where grantee=current_user"
$P -c "select nspname,pg_get_userbyid(nspowner) from pg_namespace"
$P -c "select schemaname,tablename,tableowner from pg_tables where schemaname in ('export','support')"
$P -c "select relname,relacl from pg_class c join pg_namespace n on n.oid=c.relnamespace where n.nspname in ('export','support')"
RSH
