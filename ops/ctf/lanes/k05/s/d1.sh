set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'CA=$HOME/.local/share/keplerops/ca.crt
A="Authorization: Basic $(printf "rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo" | base64 -w0)"
G="https://source.keplerops.test/api/v1/repos/fieldkest/connector-archive/raw"
cd /tmp && rm -rf arch && mkdir arch && cd arch
for f in bin/fieldlink-connector config/diagnostic.conf config/ordinary.conf examples/bytes-00-0f.bin examples/empty.bin examples/fieldkest.bin; do mkdir -p $(dirname $f); curl -sS -m 30 -H "$A" -o $f "$G/$f" --cacert $CA; done
chmod +x bin/fieldlink-connector
echo "=== version strings"
strings -a bin/fieldlink-connector | grep -iE "6\.9\.8|7\.4\.[0-9]|FLK|version" | head -30
echo "=== build id"
readelf -n bin/fieldlink-connector 2>/dev/null | head -20
echo "=== run ordinary"
./bin/fieldlink-connector --config config/ordinary.conf --input examples/fieldkest.bin; echo "rc=$?"
echo "=== run diagnostic"
./bin/fieldlink-connector --config config/diagnostic.conf --input examples/fieldkest.bin; echo "rc=$?"
echo "=== help"
./bin/fieldlink-connector --help 2>&1 | head -30' 2>&1 | tail -80
