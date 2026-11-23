#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080 -k -sS -m 20"
T=fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo
mkdir -p /tmp/art
for f in integration-review-input-v3.json ordinary-support-input-v1.json REVNOTE-1842.json; do
  echo "===== $f"
  curl $P -u rowan.ito:$T "https://ci.keplerops.test/job/fieldlink-report/1842/artifact/reports/$f" -o /tmp/art/$f -w '%{http_code}\n'
  head -c 3000 /tmp/art/$f; echo
done
echo "===== connector route scan"
cat > /tmp/words.txt <<'EOF'
api
api/v1
v1
exports
export
ledger
ledgers
allocation
allocations
allocations/current
allocation-ledger
meter
meters
meter-export
meter-exports
reserve
reserves
district
districts
customer
customers
asset
assets
report
reports
process
process-data
feed
feeds
observations
observation
live
current
planning
dry-period
commitments
water
supply
readings
read
data
status
version
health
schema
docs
openapi.json
swagger.json
.well-known/fieldkest-client
.well-known/fieldkest-relay
api/exports
api/exports/current
api/ledger
api/allocation
api/meter
api/reserve
api/districts
api/reports
api/process
api/feed
api/observations
api/readings
api/customers
api/assets
api/v1/exports
api/v1/ledger
api/v1/meters
api/v1/reserves
api/v1/districts
api/v1/reports
api/v1/process
api/v1/feed
api/v1/observations
EOF
while read w; do
  code=$(curl $P -o /tmp/rout.txt -w '%{http_code}' "https://connector.arwc.test/$w")
  sz=$(wc -c < /tmp/rout.txt)
  if [ "$code" != "404" ]; then echo "FOUND $code $sz /$w"; head -c 400 /tmp/rout.txt; echo; fi
done < /tmp/words.txt
echo "===== done"
