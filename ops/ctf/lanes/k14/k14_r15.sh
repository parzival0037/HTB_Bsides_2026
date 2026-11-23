set +e
ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=8 rowan-dev 'bash -s' <<'RSH'
set +e
echo "=== CURRENT/ROLES ==="
psql service=fieldlink -Atc "select current_user, session_user" 2>&1
for r in fieldlink_identity fieldlink_staff fieldlink_data_owner fieldlink_admin; do
 echo "-- set role $r"; psql service=fieldlink -Atc "set role $r; select current_user; show role;" 2>&1 | head -5
done
echo "=== PG_CLASS TABLES ==="
psql service=fieldlink -Atc "select n.nspname||'.'||c.relname||'('||c.relkind||')' from pg_class c join pg_namespace n on n.oid=c.relnamespace where n.nspname in ('public','workspace','export','support') and c.relkind in ('r','v','m','p') order by 1" 2>&1 | head -100
echo "=== PG_ATTRIBUTE workspace ==="
psql service=fieldlink -Atc "select n.nspname||'.'||c.relname||'.'||a.attname from pg_attribute a join pg_class c on c.oid=a.attrelid join pg_namespace n on n.oid=c.relnamespace where n.nspname in ('public','workspace','export','support') and a.attnum>0 and not a.attisdropped order by 1" 2>&1 | head -150
echo "=== DUMP LIST ==="
which pg_restore; pg_restore -l /tmp/ch.dump 2>&1 | head -60
echo "=== DUMP PY ==="
python3 - <<'PY'
d=open('/tmp/ch.dump','rb').read()
print(len(d), d[:16])
import re
for m in re.finditer(rb'[ -~]{6,}', d):
    print(m.group().decode())
PY
RSH
echo DONE_K14_R15
