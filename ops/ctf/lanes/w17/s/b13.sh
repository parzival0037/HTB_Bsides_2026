#!/bin/bash
SSH="ssh -i $HOME/.ssh/keplerops-foothold -o BatchMode=yes -o StrictHostKeyChecking=accept-new -o ConnectTimeout=8 rowan-dev"
$SSH 'echo "== sudo"; sudo -n id 2>&1 | head -2
echo "== docker sock"; ls -la /var/run/docker.sock /run/docker.sock 2>&1
echo "== find"; timeout 90 sudo -n find / -xdev \( -iname "*cairn*" -o -iname "*crr*" -o -iname "*fuxa*" -o -iname "*openplc*" \) 2>/dev/null | head -40
echo "== hosts/caps"; cat /proc/1/cgroup; ls /; ls /opt /srv 2>/dev/null
echo "== network namespaces"; ls /var/run/netns 2>/dev/null; ip netns list 2>/dev/null
echo "== env"; env | grep -iE "proxy|arwc|host" | head
echo "== etc hosts of host?"; cat /etc/hostname
echo "== listening"; (ss -lnt 2>/dev/null || netstat -lnt 2>/dev/null) | head -30' 2>&1
