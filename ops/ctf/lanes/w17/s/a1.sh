#!/bin/bash
echo "== pivot check"
curl -sS -m 8 --socks5-hostname 127.0.0.1:1080 -k -o /dev/null -w "source:%{http_code}\n" https://source.keplerops.test/ 2>&1
timeout 8 bash -c 'exec 3<>/dev/tcp/127.0.0.1/1080 && echo "socks open"' 2>&1
tmux ls 2>&1
echo "== rowan-dev hosts + scan"
SSH="ssh -i $HOME/.ssh/keplerops-foothold -o BatchMode=yes -o StrictHostKeyChecking=accept-new -o ConnectTimeout=8 rowan-dev"
$SSH 'hostname; cat /etc/hosts; echo ===; which nmap dig curl psql python3; echo ===; ip -4 a | grep inet' 2>&1
