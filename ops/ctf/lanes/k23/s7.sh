#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
K="-k -sS -m 40"
H="https://assistant.keplerops.test"
curl $K $P $H/index.js -o /tmp/index.js -w "bundle %{http_code} %{size_download}\n"
echo "== /workspace strings"
grep -o '/workspace/[a-zA-Z0-9/:_${}.-]*' /tmp/index.js | sort -u | head -60
echo "== /api strings"
grep -o '/api/[a-zA-Z0-9/:_${}.-]*' /tmp/index.js | sort -u | head -80
echo "== workspace-ctx"
grep -o '.\{0,60\}vector-search.\{0,80\}' /tmp/index.js | head -5
grep -o '.\{0,60\}context.\{0,60\}' /tmp/index.js | grep -i 'inventory\|workspace' | head -10
echo "== version"
grep -o '"version":"[0-9.]*"' /tmp/index.js | head -3
grep -o '.\{0,30\}anythingllm.\{0,60\}' /tmp/index.js | head -5
