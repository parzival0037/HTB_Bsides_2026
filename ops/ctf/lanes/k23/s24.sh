#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"; K="-k -sS -m 40"; H="https://assistant.keplerops.test"
curl $K $P $H/index.js -o /tmp/index.js
echo "=== local-files usage"
grep -o '.\{60\}local-files.\{260\}' /tmp/index.js | head -10
echo "=== by-docpaths"
grep -o '.\{100\}by-docpaths.\{200\}' /tmp/index.js | head -5
