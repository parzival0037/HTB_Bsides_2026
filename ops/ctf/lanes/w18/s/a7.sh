#!/bin/bash
KO="ssh -i $HOME/.ssh/keplerops-foothold -p 2222 -o StrictHostKeyChecking=no -o ConnectTimeout=10 rowan@10.50.13.180"
$KO 'export KUBECONFIG=$HOME/.kube/config
echo "===== config"; kubectl config view --minify 2>&1 | head -30
echo "===== auth"; kubectl auth can-i --list 2>&1 | head -40
echo "===== namespaces"; kubectl get ns 2>&1 | head -20
echo "===== pods all"; kubectl get pods -A -o wide 2>&1 | head -40
echo "===== svc all"; kubectl get svc -A 2>&1 | head -40
echo "===== deploy all"; kubectl get deploy,sts,ds -A 2>&1 | head -40
' 2>&1
