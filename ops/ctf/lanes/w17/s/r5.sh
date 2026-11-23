#!/bin/bash
SSH="ssh -i $HOME/.ssh/keplerops-foothold -o BatchMode=yes -o StrictHostKeyChecking=accept-new -o ConnectTimeout=8 rowan-dev"
$SSH 'which nmap dig getent curl psql; echo ===; getent hosts connector.arwc.test arwc.test fuxa.arwc.test hmi.arwc.test db.arwc.test; echo ===; cat /etc/resolv.conf; echo ===; timeout 120 nmap -sn -n 10.77.60.0/24 2>&1 | tail -40' 2>&1
