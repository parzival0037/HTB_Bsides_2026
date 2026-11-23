#!/bin/bash
set -x
# pivot sanity
curl -sS --socks5-hostname 127.0.0.1:1080 --max-time 15 -k https://source.keplerops.test/ -o /dev/null -w 'source:%{http_code}\n'
# ssh reachability
ssh -o BatchMode=yes -o StrictHostKeyChecking=no -p 2222 rowan@10.50.13.180 'hostname; id; cat /etc/hosts; ls ~' 2>&1 | head -50
