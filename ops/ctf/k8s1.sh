set +e
ssh -o BatchMode=yes rowan-dev 'export KUBECONFIG=~/.kube/config; kubectl config view --minify 2>/dev/null | head -20; echo "--- ns/perms"; kubectl auth can-i --list -n fieldlink 2>&1 | head -12'
echo "=== secrets in fieldlink ns ==="
ssh -o BatchMode=yes rowan-dev 'kubectl get secrets -n fieldlink 2>&1 | head -12; echo "--- try read one"; kubectl get secret -n fieldlink $(kubectl get secrets -n fieldlink -o name 2>/dev/null | head -1 | cut -d/ -f2) -o yaml 2>&1 | head -15'
