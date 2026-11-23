#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"; K="-k -sS -m 30"; H="https://assistant.keplerops.test"
for u in /.well-known/fieldkest-client /api/config /api/contexts /static/app.js /api/selections /api/conversations /api/completions; do
 echo "===== $u"
 curl $K $P "$H$u" -w "\n[%{http_code}]\n" | head -c 3000; echo
done
