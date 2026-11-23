#!/bin/bash
KO="ssh -i $HOME/.ssh/keplerops-foothold -p 2222 -o StrictHostKeyChecking=no -o ConnectTimeout=10 rowan@10.50.13.180"
$KO '
echo "##### /etc/hosts"; cat /etc/hosts
echo "##### resolv"; cat /etc/resolv.conf
echo "##### listening"; (ss -lntup 2>/dev/null || netstat -lntup 2>/dev/null) | head -60
echo "##### localhost probes"
for p in 3350 8701 1881 4840 5432 8080 3000 8000 8443 9090; do
  echo "-- $p"; timeout 5 bash -c "exec 3<>/dev/tcp/127.0.0.1/$p; printf \"GET / HTTP/1.0\r\n\r\n\" >&3; timeout 3 head -c 300 <&3" 2>&1 | head -6
done
echo "##### browser prefs"
find ~/.mozilla ~/.config/chromium ~/.config/google-chrome -maxdepth 3 -name "prefs.js" -o -name "Preferences" 2>/dev/null | head
for f in $(find ~/.mozilla ~/.config/chromium ~/.config/google-chrome -maxdepth 3 -name "prefs.js" -o -name "Preferences" 2>/dev/null); do echo "## $f"; grep -iE "proxy|arwc|fuxa|hmi|plc|historian|dns" "$f" 2>/dev/null | head -20; done
echo "##### env/proxy files"
env | grep -i proxy; cat ~/.curlrc ~/.wgetrc /etc/environment 2>/dev/null | grep -i proxy
echo "##### /etc/hosts.d or dnsmasq"; ls -la /etc/dnsmasq* /etc/hosts.d 2>/dev/null; grep -rniE "arwc|fuxa|hmi|historian" /etc 2>/dev/null | head -20
echo "##### find cairn all"; timeout 60 sudo -n find / -xdev -iname "*cairn*" 2>/dev/null | head -20
echo "##### route"; ip route
' 2>&1
