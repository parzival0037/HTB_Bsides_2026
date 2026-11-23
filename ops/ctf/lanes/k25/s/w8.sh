S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'RSH'
set +e
Q(){ psql service=fieldlink -At -F'|' -c "$1" 2>&1; }
echo "=== tables"
Q "select n.nspname||'.'||c.relname||' kind='||c.relkind::text||' sel='||has_table_privilege(current_user,c.oid,'SELECT')::text from pg_class c join pg_namespace n on n.oid=c.relnamespace where c.relkind in ('r','v','m','p') and n.nspname not in ('pg_catalog','information_schema') order by 1;"
echo "=== s3 list"
aws --endpoint-url https://objects.keplerops.test s3 ls s3://fieldlink-exports 2>&1 | head -40
echo "=== s3 list recursive"
aws --endpoint-url https://objects.keplerops.test s3 ls --recursive s3://fieldlink-exports 2>&1 | head -80
echo "=== s3api list"
aws --endpoint-url https://objects.keplerops.test s3api list-objects-v2 --bucket fieldlink-exports 2>&1 | head -60
echo "=== head guesses"
for k in backups/company-history.dump EXP-2841/dossier.json dossiers/SUP-2841.json SUP-2841/dossier.json exports/EXP-2841/dossier.json attachments/ATT-DIAG-698 export/EXP-2841/SUP-2841.json; do
  printf '%-45s ' "$k"; aws --endpoint-url https://objects.keplerops.test s3api head-object --bucket fieldlink-exports --key "$k" 2>&1 | tr -d '\n' | head -c 300; echo
done
echo "=== buckets"
aws --endpoint-url https://objects.keplerops.test s3 ls 2>&1 | head -20
RSH
