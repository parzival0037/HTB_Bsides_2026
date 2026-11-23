#!/bin/bash
SSH="ssh -i $HOME/.ssh/keplerops-foothold -o BatchMode=yes -o StrictHostKeyChecking=accept-new -o ConnectTimeout=8 rowan-dev"
$SSH 'export KUBECONFIG=/home/rowan/.kube/config
for ns in fieldlink default arwc; do echo "##### ns=$ns"; timeout 25 kubectl get all,cm,secret,ingress,pvc -n $ns 2>&1 | head -80; done
echo "##### RBAC self"
timeout 20 kubectl auth can-i --list 2>&1 | head -60' 2>&1
