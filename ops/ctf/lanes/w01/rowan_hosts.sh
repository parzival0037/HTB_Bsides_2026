#!/bin/bash
S="ssh -o StrictHostKeyChecking=no -o BatchMode=yes -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
echo "### hosts"
$S 'cat /etc/hosts'
echo "### resolv"
$S 'cat /etc/resolv.conf; cat /etc/nsswitch.conf | head -20'
echo "### route"
$S 'ip route'
echo "### arwc references in home"
$S 'grep -ril "arwc" ~ --include="*" 2>/dev/null | grep -v "\.cache\|\.npm\|node_modules" | head -40'
