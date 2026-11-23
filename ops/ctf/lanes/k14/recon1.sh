set +e
echo "=== BOX ==="
id; hostname; ip -4 -o a; cat /etc/hosts
echo "=== DNS ==="
getent hosts rowan-dev
echo "=== ROWAN ==="
ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev '
set +e
echo "-- id"; id
echo "-- hosts"; cat /etc/hosts
echo "-- ip"; ip -4 -o a
echo "-- home ls"; ls -la ~; ls -la ~/work 2>/dev/null
echo "-- kubeconfig"; cat ~/.kube/config 2>/dev/null | head -60
echo "-- env serviceacct"; ls -la /var/run/secrets/kubernetes.io/serviceaccount/ 2>/dev/null
echo "-- sa dir"; cat /var/run/secrets/kubernetes.io/serviceaccount/namespace 2>/dev/null
echo "-- jwt claims"; TOK=$(kubectl config view --raw -o jsonpath="{.users[0].user.token}" 2>/dev/null); echo "len=${#TOK}"; python3 -c "import sys,base64,json;t=sys.argv[1].split(\".\")[1];t+=\"=\"*(-len(t)%4);print(json.dumps(json.loads(base64.urlsafe_b64decode(t)),indent=1))" "$TOK" 2>/dev/null
echo "-- k8s contexts"; kubectl config get-contexts 2>&1 | head
echo "-- pods"; kubectl get pods -A 2>&1 | head -20
echo "-- sa"; kubectl get sa -A 2>&1 | head -20
echo "-- trust files search"; grep -rIl "trust" ~/work ~/notes ~/documents 2>/dev/null | head -20
echo "-- work files"; find ~ -maxdepth 3 -type f \( -name "*.md" -o -name "*.txt" -o -name "*.json" -o -name "*.yaml" -o -name "*.yml" \) 2>/dev/null | head -60
'
echo DONE_RECON1
