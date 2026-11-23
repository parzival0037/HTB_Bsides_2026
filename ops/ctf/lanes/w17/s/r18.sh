#!/bin/bash
SSH="ssh -i $HOME/.ssh/keplerops-foothold -o BatchMode=yes -o StrictHostKeyChecking=accept-new -o ConnectTimeout=8 rowan-dev"
$SSH 'ls -la ~/.ssh; echo ===; for f in ~/.ssh/id_*; do [ -f "$f" ] && echo "--$f" && ssh-keygen -y -f "$f" 2>/dev/null | head -c 60 && echo; done
echo ===; which sshpass ssh-keygen nc host nslookup socat jq; echo ===
python3 -c "import paramiko; print(\"paramiko ok\")" 2>&1 | tail -1
echo === ; ssh -i ~/.ssh/keplerops-foothold -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=6 rowan@10.77.60.20 "hostname; id" 2>&1 | tail -3' 2>&1
