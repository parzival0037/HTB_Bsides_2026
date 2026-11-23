#!/bin/bash
[ -s /tmp/wl.txt ] || curl -sSL -m 60 -o /tmp/wl.txt https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/raft-medium-directories.txt
wc -l /tmp/wl.txt
H='ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ConnectTimeout=8 -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180'
cat /tmp/wl.txt | $H 'cat > /tmp/wl.txt; wc -l /tmp/wl.txt'
