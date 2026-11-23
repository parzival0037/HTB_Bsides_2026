set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<"REMOTE" 2>&1 | tail -500
set +e
CA=$HOME/.local/share/keplerops/ca.crt
A="Authorization: Basic $(printf "rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo" | base64 -w0)"
D="https://delivery.keplerops.test:8443"
echo "===== ENC FILES ====="
for f in ~/work/registry/*.enc; do echo "----- $f"; ls -l "$f"; echo "[cat]"; cat "$f"; echo; echo "[od]"; od -An -tx1 "$f" | head -8; echo; done
echo "===== PACKAGE META (auth) ====="
curl -sS -m 20 -H "$A" "$D/api/package-meta/fieldlink-connector" --cacert $CA -w " [%{http_code}]"; echo
echo "===== PRIVATE META support-rehearsal ====="
NAUTH=$(sed -n "s|.*packages.keplerops.test/:_auth=||p" ~/.npmrc)
curl -sS -m 20 -H "Authorization: Basic $NAUTH" "https://packages.keplerops.test/@keplerops%2fsupport-rehearsal" --cacert $CA -w " [%{http_code}]"; echo
echo "===== NPM VERSION DETAIL ====="
export NODE_EXTRA_CA_CERTS=$CA
for v in 6.9.8 7.4.0 7.4.1 7.4.2 7.4.3-cinder.rset1; do echo "----- $v"; npm view @keplerops/fieldlink-connector@$v --json 2>/dev/null | python3 -c "import json,sys; d=json.load(sys.stdin); print(json.dumps({k:d.get(k) for k in [\"name\",\"version\",\"dist\",\"_npmVersion\",\"_nodeVersion\",\"gitHead\",\"fieldkest\",\"deprecated\"]},indent=1))" 2>&1; done
echo "===== GITEA REPO SEARCH ====="
for q in delivery reconcile fieldkest client policy; do echo "--- q=$q"; curl -sS -m 20 -H "$A" "https://source.keplerops.test/api/v1/repos/search?q=$q&limit=20" --cacert $CA | python3 -c "import json,sys; d=json.load(sys.stdin); [print(r[\"full_name\"],\"|\",r.get(\"description\",\"\")) for r in d.get(\"data\") or d.get(\"repos\") or []]" 2>&1; done
echo "===== CONSUMER CHECK ====="
curl -sS -m 30 -i -X POST "$D/api/consumer-checks" -H "$A" -H "Content-Type: application/json" --cacert $CA --data @$HOME/work/registry/consumer-request.json
echo
echo "===== DB GRANTS/ROLES ====="
export PGPASSWORD=lobf9Jt0SBW433in6wUVlkixnQreh5K-Z1LjbTofrqY
P="psql -h data.keplerops.test -U rowan_data -d fieldlink_data -At"
$P -c "select rolname from pg_roles order by 1"
$P -c "select table_schema||chr(46)||table_name||chr(9)||privilege_type from information_schema.role_table_grants where grantee = current_user order by 1" | head -40
$P -c "select * from export.partition_bindings"
REMOTE
