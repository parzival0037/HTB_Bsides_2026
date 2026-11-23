#!/bin/bash
KO="ssh -i $HOME/.ssh/keplerops-foothold -p 2222 -o StrictHostKeyChecking=no -o ConnectTimeout=10 rowan@10.50.13.180"
$KO 'export KUBECONFIG=$HOME/.kube/config
kubectl auth can-i --list 2>&1 | tail -30
echo "===== resources in fieldlink ns"
for r in pods services configmaps secrets deployments endpoints ingresses; do echo "## $r"; kubectl get $r 2>&1 | head -15; done
' 2>&1
