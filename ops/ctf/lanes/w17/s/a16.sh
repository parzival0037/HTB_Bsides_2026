#!/bin/bash
SSH="ssh -i $HOME/.ssh/keplerops-foothold -o BatchMode=yes -o StrictHostKeyChecking=accept-new -o ConnectTimeout=8 rowan-dev"
$SSH 'curl -sS -m 10 -k https://delivery.keplerops.test:8443/.well-known/fieldkest-client | python3 -m json.tool' 2>&1
