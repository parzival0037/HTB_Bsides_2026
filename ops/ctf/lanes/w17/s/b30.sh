#!/bin/bash
echo "== /home"; ls -la /home
echo "== find /home"; timeout 120 sudo -n find /home -maxdepth 5 \( -iname "*cairn*" -o -iname "*crr*" -o -iname "*fuxa*" -o -iname "*openplc*" -o -iname "*engineer*" \) 2>/dev/null | head -60
echo "== dirs in homes"; for d in /home/*; do echo "-- $d"; sudo -n ls -la "$d" 2>/dev/null | head -25; done
echo "== passwd"; cat /etc/passwd | grep -v nologin | head -30
