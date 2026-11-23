#!/bin/bash
set +e
echo "== hostname/ip"
hostname; hostname -I; cat /etc/hostname
echo "== home dirs"
ls -la /home; ls -la /home/cinder | head -60
echo "== who serves 8000"
sudo -n ss -ltnp 2>/dev/null | head -20 || sudo -n netstat -ltnp 2>/dev/null | head -20 || cat /proc/net/tcp | head
for p in /proc/[0-9]*; do c=$(tr "\0" " " < $p/cmdline 2>/dev/null); case "$c" in *http.server*|*8000*|*python*serve*) echo "$p $c";; esac; done
echo "== ip addr"
command -v ip; command -v ifconfig; cat /proc/net/fib_trie 2>/dev/null | grep -A1 "32 host" | grep -E "^\s+/32" | head -20
