#!/bin/bash
set +e
echo "== /etc/hosts"; cat /etc/hosts
echo "== resolv"; cat /etc/resolv.conf
echo "== xsession"; cat ~/.xsession; echo; echo "== autostart"; ls -la ~/.config/autostart 2>/dev/null; cat ~/.config/autostart/* 2>/dev/null
echo "== entrypoint"; ls -la /usr/local/bin | head -30; cat /usr/local/bin/*participant* 2>/dev/null | head -60
echo "== firefox proxy prefs"; grep -rhoE '"(network\.proxy[^"]*)"[^,}]*' ~/.mozilla 2>/dev/null | head -20
grep -rioE "arwc|hmi\.|fuxa|proxy" ~/.mozilla/firefox/*/prefs.js 2>/dev/null | sort -u | head -20
echo "== firefox policies"; ls /etc/firefox/policies 2>/dev/null && cat /etc/firefox/policies/* 2>/dev/null
echo "== chromium policy"; ls /etc/chromium/policies 2>/dev/null; cat /etc/chromium/policies/*/* 2>/dev/null
echo "== side menu"; grep -rl "Ctrl+Alt+Shift" /opt /usr/local /etc 2>/dev/null | head
echo "== /opt"; ls -la /opt; find /opt -maxdepth 2 -type f | head -40
