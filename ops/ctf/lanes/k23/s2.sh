#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
K="-k -sS -m 20"
echo "== ssh config"
cat ~/.ssh/config 2>/dev/null; ls ~/.ssh
echo "== rowan-dev home"
ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 -i ~/.ssh/keplerops-foothold -p 2222 rowan@rowan-dev \
 'id; ls -la ~; echo ---; ls -la ~/.config ~/.config/fieldlink 2>/dev/null; echo ---; cat ~/.config/fieldlink/support-client.json 2>/dev/null' 2>&1 | head -80
echo "== assistant login attempt (maya)"
curl $K $P -X POST https://assistant.keplerops.test/api/request-token -H 'Content-Type: application/json' \
  -d '{"username":"maya.ranscombe","password":"sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk"}' -w "\n[%{http_code}]\n"
