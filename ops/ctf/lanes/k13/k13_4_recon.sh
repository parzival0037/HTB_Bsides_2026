set +e
C="curl -sSk -m 20 --socks5-hostname 127.0.0.1:1080"
echo "===== PIVOT CHECK ====="
$C -o /dev/null -w '%{http_code}\n' https://source.keplerops.test/
echo "===== CLOUD-API WELL-KNOWN ====="
$C -i https://cloud-api.keplerops.test/.well-known/fieldkest-client; echo
echo "===== CLOUD-API ROOT ====="
$C -i https://cloud-api.keplerops.test/ | head -30
echo "===== NOTEBOOK LATEST FULL ====="
$C "https://objects.keplerops.test/fieldkest-workspaces/notebooks/deploy-2026-09.json"; echo
echo "===== HANDOVER LATEST FULL ====="
$C "https://objects.keplerops.test/fieldkest-workspaces/exports/EXP-2841/handover.json"; echo
echo "===== BUCKET LIST ====="
$C "https://objects.keplerops.test/fieldkest-workspaces?list-type=2" | sed 's/></>\n</g'
echo "===== BUCKET VERSIONS ====="
$C "https://objects.keplerops.test/fieldkest-workspaces?versions" | sed 's/></>\n</g'
echo "===== BUCKET LIST all buckets ====="
$C "https://objects.keplerops.test/" | sed 's/></>\n</g'
