set +e
echo "== pg_restore list =="
pg_restore -l /tmp/ch.dump 2>&1 | head -60
echo "== pg_restore plain =="
pg_restore -f - /tmp/ch.dump 2>&1 | head -300
