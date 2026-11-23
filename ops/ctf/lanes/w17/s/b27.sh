#!/bin/bash
SSH="ssh -i $HOME/.ssh/keplerops-foothold -o BatchMode=yes -o StrictHostKeyChecking=accept-new -o ConnectTimeout=8 rowan-dev"
$SSH 'echo "== mounts"; mount | head -30; echo "== ls /"; ls -la /; echo "== find all"; timeout 120 find / \( -iname "*cairn*" -o -iname "*crr*" -o -iname "*fuxa*" -o -iname "*openplc*" -o -iname "*hmi*" \) 2>/dev/null | grep -v -E "proc|sys|usr/share/(locale|zoneinfo|icons|fonts)|/usr/lib/python|node_modules" | head -50
echo "== media/mnt/run"; ls -la /mnt /media /run/user /run/media 2>&1 | head -40
echo "== recently modified"; find / -xdev -type f -newermt "2026-11-19 00:00" 2>/dev/null | grep -v -E "proc|sys|/tmp|/var/log|\.cache|\.npm|\.config|/home/rowan/\.local" | head -40' 2>&1 | tail -100
