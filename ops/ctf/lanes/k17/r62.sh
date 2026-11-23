set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
echo "===== psql service config ====="; cat /home/rowan/.pg_service.conf 2>/dev/null; ls -la /home/rowan/.pgpass 2>/dev/null
echo "===== tables ====="
psql "service=fieldlink" -c '\dt' 2>&1 | head -60
echo "===== schemas ====="
psql "service=fieldlink" -c '\dn' 2>&1 | head -20
echo "===== search tables for note/case/review ====="
psql "service=fieldlink" -At -c "select table_schema||'.'||table_name from information_schema.tables where table_name ~* '(note|case|review|hand|deleg|support|export|customer)' order by 1" 2>&1 | head -60
echo "===== all table names ====="
psql "service=fieldlink" -At -c "select table_schema||'.'||table_name from information_schema.tables where table_schema not in ('pg_catalog','information_schema') order by 1" 2>&1 | head -100
INNER
echo DONE_R62
