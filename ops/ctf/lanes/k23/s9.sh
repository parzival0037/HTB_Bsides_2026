#!/bin/bash
SSH="ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 -i /root/.ssh/keplerops-foothold -p 2222 rowan@rowan-dev"
echo "== kubectl"
$SSH 'export KUBECONFIG=$HOME/.kube/config; kubectl config current-context 2>&1; kubectl get ns 2>&1 | head; echo ---; kubectl get pods -A 2>&1 | head -40; echo ---; kubectl get secrets -n fieldlink 2>&1 | head -30' 2>&1 | head -90
echo "== grep assistant refs"
$SSH 'grep -ril "anythingllm\|assistant.keplerops" ~/work ~/repos ~/.config 2>/dev/null | head -20; echo ---; find ~ -maxdepth 3 -iname "*assistant*" 2>/dev/null | head' 2>&1 | head -50
