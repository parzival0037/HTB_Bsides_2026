#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
K="-k -sS -m 20"
echo "== pivot check"
curl $K $P https://assistant.keplerops.test/ -o /tmp/a.html -w "root %{http_code} %{size_download}\n"
head -c 600 /tmp/a.html; echo
for u in /api/system/hello /api/workspaces /api/v1/workspaces /api/system/system-vectors /robots.txt /api/ping /api/setup-complete; do
  echo "== $u"
  curl $K $P "https://assistant.keplerops.test$u" -w "\n[%{http_code}]\n" | head -c 800; echo
done
