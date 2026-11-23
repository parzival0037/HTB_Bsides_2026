#!/bin/bash
echo "== date"; date -u
echo "== pivot"; curl -sS -m 15 --socks5-hostname 127.0.0.1:1080 -k -o /dev/null -w '%{http_code}\n' https://source.keplerops.test/ 2>&1
echo "== box hosts"; cat /etc/hosts
echo "== rowan hosts"; ssh -i $HOME/.ssh/keplerops-foothold -p 2222 -o StrictHostKeyChecking=no -o ConnectTimeout=8 rowan@10.50.13.180 'cat /etc/hosts; echo ---; cat /etc/resolv.conf; echo ---; getent hosts hmi.arwc.test plc.arwc.test historian.arwc.test connector.arwc.test opcua.arwc.test 2>&1; echo ---; ip -4 a; echo ---; ip route' 2>&1
