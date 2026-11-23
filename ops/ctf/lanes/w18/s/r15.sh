#!/bin/bash
KO="-i ~/.ssh/keplerops-foothold -p 2222 -o StrictHostKeyChecking=no -o ConnectTimeout=10"
ssh $KO rowan@10.50.13.180 '
export KUBECONFIG=$HOME/.kube/config
echo "=== ns"; kubectl get ns 2>&1 | head -20
echo "=== all pods"; kubectl get pods -A -o wide 2>&1 | head -60
echo "=== svc"; kubectl get svc -A 2>&1 | head -60
echo "=== ingress"; kubectl get ingress -A 2>&1 | head -40
echo "=== deploy"; kubectl get deploy -A 2>&1 | head -40
' 2>&1
