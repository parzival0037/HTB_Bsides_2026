#!/bin/bash
SSH="ssh -i $HOME/.ssh/keplerops-foothold -o BatchMode=yes -o StrictHostKeyChecking=accept-new -o ConnectTimeout=8 rowan-dev"
$SSH 'cd ~/repos/connector-archive 2>/dev/null && git log --oneline | head -5; find ~/repos/connector-archive -maxdepth 6 | head -80; echo ===; cat ~/repos/connector-archive/connector-archive/internal/fieldlink/legacy-diagnostics/CRR-OG2/ENG-FLK-LEGACY-42.md' 2>&1
