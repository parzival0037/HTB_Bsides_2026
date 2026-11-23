#!/bin/bash
SSH="ssh -i $HOME/.ssh/keplerops-foothold -o BatchMode=yes -o StrictHostKeyChecking=accept-new -o ConnectTimeout=8 rowan-dev"
$SSH 'find /opt/fieldkest-workbench /opt/keplerops-workbench -maxdepth 3 2>/dev/null | head -80; echo ===; ls -la /opt/fieldkest-workbench /opt/keplerops-workbench 2>&1' 2>&1
