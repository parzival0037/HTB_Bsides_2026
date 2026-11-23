set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'CA=$HOME/.local/share/keplerops/ca.crt
A="Authorization: Basic $(printf "rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo" | base64 -w0)"
G="https://source.keplerops.test/api/v1/repos/fieldkest/connector-archive/raw"
for f in README.md config/diagnostic.conf config/ordinary.conf internal/fieldlink/legacy-diagnostics/CRR-OG2/ENG-FLK-LEGACY-42.md internal/fieldlink/legacy-diagnostics/CRR-OG2/ENT-ARWC-DIAG-0698.json maps/fieldlink-connector-6.9.8.map notes/retained-diagnostic.md; do
echo "######## $f"
curl -sS -m 15 -H "$A" "$G/$f" --cacert $CA; echo
done' 2>&1 | tail -120
