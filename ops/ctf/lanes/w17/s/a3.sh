#!/bin/bash
SSH="ssh -i $HOME/.ssh/keplerops-foothold -o BatchMode=yes -o StrictHostKeyChecking=accept-new -o ConnectTimeout=8 rowan-dev"
$SSH 'echo ==KUBE; which kubectl; export KUBECONFIG=$(ls ~/.kube/config* 2>/dev/null|head -1); echo KUBECONFIG=$KUBECONFIG; timeout 30 kubectl get ns 2>&1 | head; echo ==; timeout 30 kubectl get all -A 2>&1 | head -60; echo ==SVC; timeout 30 kubectl get svc,ep -A 2>&1 | head -60; echo ==ING; timeout 30 kubectl get ingress -A 2>&1 | head -30; echo ==SECRETS; timeout 30 kubectl get secrets -A 2>&1 | head -30' 2>&1
