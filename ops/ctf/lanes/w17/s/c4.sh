#!/bin/bash
set +e
SSH="ssh -i $HOME/.ssh/keplerops-foothold -o BatchMode=yes -o StrictHostKeyChecking=accept-new -o ConnectTimeout=8 rowan-dev"
$SSH 'export KUBECONFIG=~/.kube/config; which kubectl; kubectl config get-contexts 2>&1 | head; echo "== ns"; kubectl get ns 2>&1 | head -30; echo "== svc"; kubectl get svc -A -o wide 2>&1 | head -60; echo "== pods"; kubectl get pods -A -o wide 2>&1 | head -60' 2>&1 | tail -140
