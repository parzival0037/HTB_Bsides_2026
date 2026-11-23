#!/bin/bash
H='ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ConnectTimeout=8 -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180'
$H 'export KUBECONFIG=~/.kube/config; kubectl get ns 2>&1 | head; echo "--- svc"; kubectl get svc -A 2>&1 | head -60; echo "--- ingress"; kubectl get ingress -A 2>&1 | head -40; echo "--- pods"; kubectl get pods -A 2>&1 | head -40'
