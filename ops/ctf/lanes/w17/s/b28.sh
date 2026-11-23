#!/bin/bash
SSH="ssh -i $HOME/.ssh/keplerops-foothold -o BatchMode=yes -o StrictHostKeyChecking=accept-new -o ConnectTimeout=8 rowan-dev"
$SSH 'echo "== /run/fieldkest-auth"; ls -la /run/fieldkest-auth; for f in /run/fieldkest-auth/*; do echo "### $f"; head -c 800 "$f"; echo; done
echo "== /opt"; ls -laR /opt | head -80
echo "== /var/lib/fieldkest-workbench"; find /var/lib/fieldkest-workbench -maxdepth 3 | head -40
echo "== grep arwc in /opt /var/lib"; grep -ril "arwc\|cairn\|hmi\|plc\|opc" /opt /var/lib/fieldkest-workbench 2>/dev/null | head -20' 2>&1 | tail -120
