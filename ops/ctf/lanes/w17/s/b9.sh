#!/bin/bash
SSH="ssh -i $HOME/.ssh/keplerops-foothold -o BatchMode=yes -o StrictHostKeyChecking=accept-new -o ConnectTimeout=8 rowan-dev"
$SSH 'echo "== README"; cat ~/README.md 2>/dev/null; echo; echo "== work files"; ls -la ~/work 2>/dev/null; for f in ~/work/*.md ~/work/*/*.md; do echo "##### $f"; cat "$f"; echo; done
echo "== bash_history"; cat ~/.bash_history 2>/dev/null
echo "== recent files"; find ~ -maxdepth 3 -type f -newermt "2026-11-19" 2>/dev/null | grep -v -E "\.cache|\.npm|node_modules|\.local/share" | head -40' 2>&1 | head -250
