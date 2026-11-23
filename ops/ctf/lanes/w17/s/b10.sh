#!/bin/bash
echo "== route"; cat /proc/net/route | awk 'NR==1||$2!="00000000"{print}'
echo "== ipv4 addrs"; sudo -n ifconfig -a 2>/dev/null | grep -E "^[a-z]|inet" | head -40
echo "== fib"; sudo -n head -60 /proc/net/fib_trie
echo "== arp"; cat /proc/net/arp
echo "== resolv"; cat /etc/resolv.conf
