#!/bin/bash
SSH="ssh -i $HOME/.ssh/keplerops-foothold -o BatchMode=yes -o StrictHostKeyChecking=accept-new -o ConnectTimeout=8 rowan-dev"
$SSH 'for ip in 10.77.53.1 10.77.54.1 10.77.55.1 10.77.56.1 10.77.50.20; do echo "===== $ip"; echo | timeout 8 openssl s_client -connect $ip:3389 2>/dev/null | openssl x509 -noout -subject -issuer -fingerprint 2>&1; done' 2>&1
