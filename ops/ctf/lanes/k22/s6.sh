set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
set +e
cd ~
echo "===== kubectl config ====="
kubectl config current-context 2>&1
kubectl get ns 2>&1 | head
echo "===== pods ====="
kubectl get pods -o wide 2>&1 | head -40
echo "===== svc ====="
kubectl get svc 2>&1 | head -40
echo "===== secrets names ====="
kubectl get secrets 2>&1 | head -40
echo "===== deploy ====="
kubectl get deploy 2>&1 | head -40
echo "===== whoami ====="
kubectl auth can-i --list 2>&1 | head -30
INNER
