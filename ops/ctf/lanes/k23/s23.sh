#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"; K="-k -sS -m 40"; H="https://assistant.keplerops.test"
curl $K $P $H/index.js -o /tmp/index.js
grep -o '${C}/[a-zA-Z0-9/:_${}.-]*' /tmp/index.js | sort -u
echo "=== parse usage"
grep -o '.\{80\}workspace/\${e}/parse.\{200\}' /tmp/index.js | head -3
echo "=== parsed-files usage"
grep -o '.\{100\}/parsed-files.\{200\}' /tmp/index.js | head -3
