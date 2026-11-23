set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'CA=$HOME/.local/share/keplerops/ca.crt
A="Authorization: Basic $(printf "rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo" | base64 -w0)"
G="https://source.keplerops.test/api/v1/repos/fieldkest/connector-archive/raw"
for f in README.md config/diagnostic.conf config/ordinary.conf internal/fieldlink/legacy-diagnostics/CRR-OG2/ENG-FLK-LEGACY-42.md internal/fieldlink/legacy-diagnostics/CRR-OG2/ENT-ARWC-DIAG-0698.json; do
echo "######## $f"
curl -sS -m 15 -H "$A" "$G/$f" --cacert $CA; echo
done
echo "######## map head"; curl -sS -m 15 -H "$A" "$G/maps/fieldlink-connector-6.9.8.map" --cacert $CA | head -60
echo "######## bin size"; curl -sS -m 15 -H "$A" -o /tmp/fc.bin "$G/bin/fieldlink-connector" --cacert $CA; ls -la /tmp/fc.bin; file /tmp/fc.bin' 2>&1 | tail -100
