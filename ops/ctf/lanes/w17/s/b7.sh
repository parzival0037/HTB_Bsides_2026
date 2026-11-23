#!/bin/bash
echo "== homes"; ls -la /home; echo
echo "== find cairn/crr/fuxa/opc"
timeout 120 sudo -n find / -xdev \( -iname "*cairn*" -o -iname "*crr*" -o -iname "*fuxa*" -o -iname "*openplc*" -o -iname "*ot_history*" \) 2>/dev/null | head -80
echo "== mounts"; mount | head -30; df -h | head
echo "== other containers?"; ls /var/lib/docker 2>/dev/null; ls /var/lib/containers 2>/dev/null
echo "== root home"; sudo -n ls -la /root 2>/dev/null
echo "== recent modified files in /home (non cinder)"; ls -la /opt /srv /mnt /media 2>/dev/null
echo "== grep fuxa in configs"
timeout 60 sudo -n grep -rIl "arwc.test\|FUXA\|ot_history" /etc /opt /srv /usr/local /var/lib 2>/dev/null | head -20
