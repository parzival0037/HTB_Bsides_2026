set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'RSH'
set +e
CA=$HOME/.local/share/keplerops/ca.crt
A="Authorization: Basic $(printf 'rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo' | base64 -w0)"
G="https://source.keplerops.test/api/v1/repos/fieldkest/connector-archive/raw/main"
for f in README.md notes/retained-diagnostic.md config/diagnostic.conf config/ordinary.conf internal/fieldlink/legacy-diagnostics/CRR-OG2/ENG-FLK-LEGACY-42.md; do
echo "######## $f"; curl -sS -m 15 -H "$A" --cacert "$CA" "$G/$f"; echo
done
echo "######## ENT json"; curl -sS -m 15 -H "$A" --cacert "$CA" "$G/internal/fieldlink/legacy-diagnostics/CRR-OG2/ENT-ARWC-DIAG-0698.json" | head -c 3000; echo
echo "=== S3 policy/versions"
export AWS_CA_BUNDLE=$CA
E="--endpoint-url https://objects.keplerops.test"
aws $E s3api get-bucket-policy --bucket fieldlink-exports 2>&1 | head -20
aws $E s3api get-bucket-acl --bucket fieldlink-exports 2>&1 | head -20
for p in exports/ export/ support/ handover/ handovers/ EXP-2841/ SCHED-2841/ collections/ arwc/ TEN-ARWC-019/ TEN-ARWC-047/; do
 echo "-- prefix $p"; aws $E s3api list-objects-v2 --bucket fieldlink-exports --prefix "$p" 2>&1 | head -12
done
echo "=== indexer well-known"
curl -sS -m 10 --cacert "$CA" https://indexer.keplerops.test/.well-known/fieldkest-client; echo
RSH
