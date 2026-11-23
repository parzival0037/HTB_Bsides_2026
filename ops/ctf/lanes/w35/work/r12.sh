#!/bin/bash
S="ssh -o StrictHostKeyChecking=no -o BatchMode=yes -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
echo "===== find prior scripts ====="
$S 'find / -xdev \( -name "scan_arwc.py" -o -name "getkey.py" -o -name "arwc_key" -o -name "scan3.py" -o -name "*support-private*" -o -name "arwcpkg" \) 2>/dev/null | head -40; echo ---; ls -la /tmp 2>/dev/null | head -60'
echo "===== core arwcpkg context ====="
$S 'LC_ALL=C timeout 200 grep -aoE ".{0,250}arwcpkg.{0,250}" ~/core 2>/dev/null | tr -d "\000" | sort -u | head -40'
echo "===== core arwc_key context ====="
$S 'LC_ALL=C timeout 200 grep -aoE ".{0,250}arwc_key.{0,350}" ~/core 2>/dev/null | tr -d "\000" | sort -u | head -40'
