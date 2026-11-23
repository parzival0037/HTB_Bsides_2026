#!/bin/bash
SSH="ssh -i $HOME/.ssh/keplerops-foothold -o BatchMode=yes -o StrictHostKeyChecking=accept-new -o ConnectTimeout=8 rowan-dev"
$SSH 'grep -ril "arwc\|fuxa\|opc.ua\|opcua" ~ --include="*.md" --include="*.json" --include="*.txt" --include="*.conf" 2>/dev/null | head -30; echo ===
grep -ri "arwc\|fuxa" ~/work/*.md 2>/dev/null | head -20; echo ===
cat ~/README.md; echo ===
ls ~/work/analysis ~/work/build-operations ~/work/repos 2>/dev/null' 2>&1
