#!/bin/bash
echo "== routes"; ip route; ip -4 a | grep -E 'inet '
echo "== tools"; which nmap dig nc curl jq python3
echo "== direct 10.77.60.20"; timeout 5 bash -c 'exec 3<>/dev/tcp/10.77.60.20/443 && echo OPEN443'; timeout 5 bash -c 'exec 3<>/dev/tcp/10.77.60.20/22 && echo OPEN22'
echo "== tcp 10.77.50.11:443"; timeout 5 bash -c 'exec 3<>/dev/tcp/10.77.50.11/443 && echo OPEN'
