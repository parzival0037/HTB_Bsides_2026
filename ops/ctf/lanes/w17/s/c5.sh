#!/bin/bash
set +e
SSH="ssh -i $HOME/.ssh/keplerops-foothold -o BatchMode=yes -o StrictHostKeyChecking=accept-new -o ConnectTimeout=8 rowan-dev"
$SSH 'export KUBECONFIG=~/.kube/config
echo "== auth"; kubectl auth can-i --list -n fieldlink 2>&1 | head -40
echo "== pods"; kubectl get pods -n fieldlink -o wide 2>&1 | head -40
echo "== svc"; kubectl get svc -n fieldlink -o wide 2>&1 | head -40
echo "== ep"; kubectl get endpoints -n fieldlink 2>&1 | head -40
echo "== cm"; kubectl get cm -n fieldlink 2>&1 | head -40
echo "== deploy"; kubectl get deploy,sts,ds -n fieldlink 2>&1 | head -40
echo "== ingress"; kubectl get ingress -n fieldlink 2>&1 | head' 2>&1 | tail -140
