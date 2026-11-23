#!/bin/bash
SSH="ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 -i $HOME/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
$SSH 'bash -s' <<'INNER'
CA=/home/rowan/.local/share/keplerops/ca.crt
A=https://assistant.keplerops.test
mkdir -p /tmp/al
curl -sS -m 30 --cacert $CA "$A/index.js" -o /tmp/al/index.js
ls -la /tmp/al/index.js
echo "===== api routes in bundle"
grep -oE '"/api/[^"]+"' /tmp/al/index.js | sort -u | head -100
echo "===== workspace routes"
grep -oE '/api/workspace[^"`]*' /tmp/al/index.js | sort -u | head -100
echo "===== chat-ish"
grep -oE '"/[a-z0-9/_-]*(chat|thread|query|document|source)[a-z0-9/_-]*"' /tmp/al/index.js | sort -u | head -100
INNER
