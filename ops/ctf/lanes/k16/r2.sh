#!/bin/bash
set +e
R(){ echo "##### $1"; ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=10 rowan-dev "$1" 2>&1; }
R 'cat ~/.bash_history; echo ---; cat ~/README.md'
R 'cat ~/.kube/config'
R 'kubectl auth can-i --list 2>&1'
R 'kubectl get sa 2>&1; echo ---; kubectl get role,rolebinding 2>&1; echo ---; kubectl get secret 2>&1'
R 'grep -rilE "cron|schedul|shift|handover|support" ~/work ~/repos ~/k05arch 2>/dev/null | head -50'
R 'cat ~/work/service-notes.md | tail -60'
R 'ls -la ~/results ~/repos ~/k05arch 2>&1'
R 'ps aux 2>&1 | head -40; echo ---; ss -ltnp 2>&1 | head -30'
echo DONE_R2
