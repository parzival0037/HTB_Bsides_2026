#!/bin/bash
KO="ssh -i $HOME/.ssh/keplerops-foothold -p 2222 -o StrictHostKeyChecking=no -o ConnectTimeout=10 rowan@10.50.13.180"
$KO 'echo "===== rowan home"; ls -la ~; echo "===== README"; cat ~/README.md 2>/dev/null
echo "===== work tree"; find ~/work -maxdepth 3 -type f 2>/dev/null | grep -v node_modules | grep -v "/.git/" | head -200
echo "===== grep ARWC/OT terms"; timeout 90 grep -rilE "arwc|cairn|fuxa|opc\.tcp|modbus|historian|native register|CRR-" ~/work ~/README.md ~/.config ~/.npmrc ~/.aws 2>/dev/null | grep -v node_modules | head -60
echo "===== file contents grep snippets"; timeout 90 grep -rinE "arwc|cairn|fuxa|opc\.tcp|modbus|historian|CRR-" ~/work ~/README.md 2>/dev/null | grep -v node_modules | head -100' 2>&1
