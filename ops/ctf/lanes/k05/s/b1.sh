set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'CA=$HOME/.local/share/keplerops/ca.crt
echo "=== kubectl ctx"; kubectl config get-contexts; echo; kubectl get ns 2>&1 | head
echo "=== pods"; kubectl get pods -o wide 2>&1 | head -40
echo "=== svc"; kubectl get svc 2>&1 | head -30
echo "=== secrets"; kubectl get secrets 2>&1 | head -30
echo "=== configmaps"; kubectl get cm 2>&1 | head -30
echo "=== grep sealed on hosts fs"; grep -rl "sealed_flag\|k05-1-check\|Salted__" /opt /usr/local /srv /etc 2>/dev/null | head -20' 2>&1 | tail -80
