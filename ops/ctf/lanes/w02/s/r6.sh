C="curl -sS --socks5-hostname 127.0.0.1:1080 --cacert /tmp/ca.crt --max-time 25"
A="-u rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"
B=https://delivery.keplerops.test:8443
echo "### inspections basic"
$C -i -X POST "$B/api/inspections" $A -H 'Content-Type: application/json' -d '{"action":"inspect_public_manifest","package":"@keplerops/fieldlink-connector","request_id":"release-742","schema":"fieldkest.inspection/v1","version":"7.4.2"}' | head -c 2500
echo; echo "### repos list"
$C $A "https://source.keplerops.test/api/v1/user/repos?limit=100" | python3 -c "import sys,json;[print(r['full_name'],r.get('description')) for r in json.load(sys.stdin)]" 2>&1 | head -50
echo "### orgs repos"
for o in fieldkest fieldlink arwc cinder; do echo "-- $o"; $C $A "https://source.keplerops.test/api/v1/orgs/$o/repos?limit=100" | head -c 2000; echo; done
