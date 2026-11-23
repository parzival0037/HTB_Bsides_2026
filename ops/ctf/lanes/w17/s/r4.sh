#!/bin/bash
SSH="ssh -i $HOME/.ssh/keplerops-foothold -o BatchMode=yes -o StrictHostKeyChecking=accept-new -o ConnectTimeout=8 rowan-dev"
$SSH 'cat /etc/hosts; echo ===; ip -4 a; echo ===; ip route; echo ===; ls -la ~ ~/work 2>/dev/null | head -60; echo ===; cat ~/.ssh/config 2>/dev/null' 2>&1
