#!/bin/bash
S="ssh -o StrictHostKeyChecking=no -o BatchMode=yes -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
echo "===== rowan home tree ====="
$S 'ls -la ~; echo ---; find ~ -maxdepth 3 -not -path "*/.cache/*" -not -path "*/.git/*" 2>/dev/null | head -150'
echo "===== history ====="
$S 'cat ~/.bash_history 2>/dev/null | tail -80; ls -la ~/.local/share 2>/dev/null'
echo "===== grep keywords ====="
$S 'timeout 90 grep -rilE "supply|procurement|district|quote|catalog|arwc" ~ /opt /srv /etc /var/lib 2>/dev/null | grep -v -e "\.cache" -e "\.git/" | head -60'
echo "===== other homes / passwd ====="
$S 'ls -la /home; getent passwd | head -30'
