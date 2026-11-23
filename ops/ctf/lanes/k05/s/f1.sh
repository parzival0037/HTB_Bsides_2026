set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'set +x
CA=$HOME/.local/share/keplerops/ca.crt
A="Authorization: Basic $(printf "rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo" | base64 -w0)"
D="https://delivery.keplerops.test:8443"
echo "===== WORK TREE ====="
find ~/work -maxdepth 3 -type f | sort
echo "===== REGISTRY FILES ====="
for f in $(find ~/work/registry -maxdepth 2 -type f | sort); do echo "----- $f"; if file "$f" | grep -qi text; then cat "$f"; else echo BINARY; xxd "$f" | head -20; fi; echo; done
echo "===== NPMRC ====="
cat ~/.npmrc 2>/dev/null | sed "s/\(_auth[^=]*=\).*/\1<redacted-locally>/"
echo "===== WELL-KNOWN ====="
for u in "$D/.well-known/fieldkest-client" "https://source-tools.keplerops.test:8443/.well-known/fieldkest-client" "https://support.keplerops.test:8443/.well-known/fieldkest-client"; do echo "--- $u"; curl -sS -m 20 -H "$A" "$u" --cacert $CA; echo; done
echo "===== RELEASES ====="
for r in release-742 release-7.4.2 REL-742 REL-7.4.2 BLD-REL-742 FLK-7.4.2 release-6.9.8 REL-6.9.8 742 7.4.2 6.9.8; do echo "--- $r"; curl -sS -m 15 -H "$A" "$D/api/releases/$r" --cacert $CA -w " [%{http_code}]"; echo; done
echo "===== PACKUMENT ====="
export NODE_EXTRA_CA_CERTS=$CA
npm view @keplerops/fieldlink-connector --json 2>/dev/null > /tmp/k05pack.json; wc -c /tmp/k05pack.json
python3 - <<"PY"
import json
d=json.load(open("/tmp/k05pack.json"))
def pr(k):
    v=d.get(k)
    print(k, "=", json.dumps(v)[:2000])
for k in ["name","dist-tags","versions","time","repository"]:
    pr(k)
PY
echo "===== DB ====="
export PGPASSWORD=lobf9Jt0SBW433in6wUVlkixnQreh5K-Z1LjbTofrqY
P="psql -h data.keplerops.test -U rowan_data -d fieldlink_data -At"
$P -c "select table_schema||'\''.'\''||table_name from information_schema.tables where table_schema not in ('\''pg_catalog'\'','\''information_schema'\'') order by 1"
for t in support.customer_records support.customer_migration_history export.partition_bindings; do echo "--- $t"; $P -c "select * from $t" 2>&1 | head -30; done
' 2>&1 | tail -400
