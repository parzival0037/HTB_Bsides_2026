set +e
ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=15 rowan-dev 'bash -s' <<'RSH'
set +e
echo "== tools"; which pg_restore psql
echo "== list"; pg_restore -l /tmp/ch.dump 2>&1 | head -40
echo "== data"; pg_restore -a -f - /tmp/ch.dump 2>&1 | head -120
RSH
