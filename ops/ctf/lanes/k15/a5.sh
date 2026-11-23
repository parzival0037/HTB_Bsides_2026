set +e
ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev 'bash -s' <<'RSH'
set +e
CA=$HOME/.local/share/keplerops/ca.crt
A="Authorization: Basic $(printf "rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo" | base64 -w0)"
B=https://source.keplerops.test/api/v1/repos/fieldkest
raw(){ curl -sS -m 15 --cacert $CA -H "$A" "$B/$1/raw/$2"; }
for f in README.md docs/report-provider.md review/FLK-7.4.2.md tests/test_crr_og2_report.py; do
 echo "########## $f"; raw fieldlink-connector "$f" | head -c 6000; echo
done
echo "########## branches/tags"
for r in fieldlink-connector connector-archive; do
 echo "-- $r branches"; curl -sS -m 15 --cacert $CA -H "$A" "$B/$r/branches" | python3 -c "import json,sys;[print(b['name'],b['commit']['id'][:10]) for b in json.load(sys.stdin)]" 2>&1
 echo "-- $r tags"; curl -sS -m 15 --cacert $CA -H "$A" "$B/$r/tags" | python3 -c "import json,sys;[print(t['name'],t['commit']['id'][:10]) for t in json.load(sys.stdin)]" 2>&1
 echo "-- $r commits"; curl -sS -m 15 --cacert $CA -H "$A" "$B/$r/commits?limit=30" | python3 -c "import json,sys;[print(c['sha'][:10],c['commit']['message'].split(chr(10))[0]) for c in json.load(sys.stdin)]" 2>&1
done
RSH
echo DONE_A5
