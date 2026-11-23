#!/bin/bash
set +e
echo "== id/host/ip"
id; hostname; ip -4 a 2>/dev/null | grep -E "inet |^[0-9]"
echo "== hosts"; cat /etc/hosts
echo "== MISSION desktop"; cat "/home/cinder/Desktop/MISSION - START HERE.txt"
echo "== MISSION home"; cat "/home/cinder/MISSION - START HERE.txt" 2>/dev/null
echo "== listening"; ss -ltnp 2>/dev/null
echo "== pivot"; tmux ls 2>&1
curl -sS -m 8 --socks5-hostname 127.0.0.1:1080 -k -o /dev/null -w "source:%{http_code}\n" https://source.keplerops.test/ 2>&1
echo "== 10.77.40.10:8000"
curl -sS -m 6 -o /tmp/p8000 -w "code=%{http_code} size=%{size_download}\n" http://10.77.40.10:8000/ 2>&1; head -c 500 /tmp/p8000; echo
ip route
