set +e
ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev 'bash -s' <<'RSH'
set +e
CA=$HOME/.local/share/keplerops/ca.crt
A="Authorization: Basic $(printf "rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo" | base64 -w0)"
B=https://source.keplerops.test/api/v1/repos/fieldkest
echo "###### delivery-operations tree"
curl -sS -m 20 --cacert $CA -H "$A" "$B/fieldlink-connector/git/trees/delivery-operations?recursive=true&per_page=200" -o /tmp/t2.json -w '[%{http_code}]\n'
python3 - <<'PY'
import json
d=json.load(open('/tmp/t2.json'))
for t in d.get('tree',[]):
    print(t['type'], t['path'])
PY
echo "###### delivery-operations commits"
curl -sS -m 20 --cacert $CA -H "$A" "$B/fieldlink-connector/commits?sha=delivery-operations&limit=30" | python3 -c "import json,sys;[print(c['sha'][:10],c['commit']['message'].replace(chr(10),' | ')[:150]) for c in json.load(sys.stdin)]" 2>&1
echo "###### review export path guess"
for p in review-exports/fieldlink-7.4.2-review.md fieldlink-7.4.2-review.md export/fieldlink-7.4.2-review.md; do
 for ref in main delivery-operations; do
  echo "-- $ref $p"; curl -sS -m 12 --cacert $CA -H "$A" -w ' [%{http_code}]' "$B/fieldlink-connector/raw/$p?ref=$ref" | head -c 400; echo
 done
done
RSH
echo DONE_A6
