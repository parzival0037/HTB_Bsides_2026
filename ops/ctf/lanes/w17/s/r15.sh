#!/bin/bash
SSH="ssh -i $HOME/.ssh/keplerops-foothold -o BatchMode=yes -o StrictHostKeyChecking=accept-new -o ConnectTimeout=8 rowan-dev"
$SSH 'sudo -n true 2>/dev/null && echo SUDO_OK || echo NO_SUDO
echo === opts; ls /opt /srv /usr/local 2>/dev/null
echo === grep
timeout 90 grep -rIl "FUXA\|fuxa\|OPC UA\|opcua\|historian" /etc /opt /srv /usr/local /home/rowan 2>/dev/null | head -20
echo === find
find / -xdev -maxdepth 4 \( -iname "*arwc*" -o -iname "*fuxa*" -o -iname "*opcua*" \) 2>/dev/null | head -20' 2>&1
