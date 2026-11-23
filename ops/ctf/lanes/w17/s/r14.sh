#!/bin/bash
SSH="ssh -i $HOME/.ssh/keplerops-foothold -o BatchMode=yes -o StrictHostKeyChecking=accept-new -o ConnectTimeout=8 rowan-dev"
$SSH 'sudo -n true 2>/dev/null && echo SUDO_OK || echo NO_SUDO
timeout 60 grep -ril "fuxa\|historian\|opcua\|opc ua\|outlet b" /etc /opt /srv /usr/local /var/lib 2>/dev/null | head -20
echo ===
ls /opt /srv /usr/local 2>/dev/null
echo ===
find / -maxdepth 3 -iname "*arwc*" -o -maxdepth 3 -iname "*fuxa*" 2>/dev/null | head
echo ===
cat ~/work/service-notes.md' 2>&1
