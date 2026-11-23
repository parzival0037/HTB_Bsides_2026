S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'RSH'
echo "=== ns"; kubectl get ns 2>&1 | head
echo "=== all fieldlink"; kubectl -n fieldlink get all 2>&1 | head -40
echo "=== cm"; kubectl -n fieldlink get cm 2>&1 | head -60
echo "=== secrets"; kubectl -n fieldlink get secrets 2>&1 | head -40
RSH
