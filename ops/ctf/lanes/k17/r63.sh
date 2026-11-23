set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
set +e
echo "===== all relations via pg_class ====="
psql "service=fieldlink" -At -c "select n.nspname||'.'||c.relname||' ('||c.relkind||')' from pg_class c join pg_namespace n on n.oid=c.relnamespace where n.nspname not in ('pg_catalog','information_schema') and c.relkind in ('r','v','m','p','f') order by 1" 2>&1 | head -80
echo "===== grants ====="
psql "service=fieldlink" -At -c "select table_schema,table_name,privilege_type from information_schema.role_table_grants where grantee in (current_user,'PUBLIC') order by 1,2" 2>&1 | head -40
echo "===== support schema describe attempt ====="
psql "service=fieldlink" -c '\d support.*' 2>&1 | head -40
echo "===== try support.case_notes candidates ====="
for t in support.case_notes support.notes support.cases support.support_notes support.handovers support.reviewers support.delegations support.case_note support.note support.case; do
 echo "--- $t"
 psql "service=fieldlink" -c "select * from $t limit 3" 2>&1 | head -8
done
echo "===== export schema relations ====="
psql "service=fieldlink" -c '\d export.partition_bindings' 2>&1 | head -20
psql "service=fieldlink" -At -c "select * from export.partition_bindings limit 10" 2>&1 | head -15
echo "===== workspace schema ====="
psql "service=fieldlink" -c "\dt workspace.*" 2>&1 | head -20
INNER
echo DONE_R63
