#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080 -k -sS -m 20"
for h in workload objects tickets assistant staff data ca id identity support llm cert cloud-api workboard indexer preview packages ci review delivery source source-tools kerberos; do
  for port in 443 8443; do
    ep="https://$h.keplerops.test"
    [ "$port" = "8443" ] && ep="$ep:8443"
    out=$(curl $P "$ep/.well-known/fieldkest-client" -w '\n%{http_code}' 2>/dev/null)
    code=$(echo "$out" | tail -1)
    if [ "$code" = "200" ]; then echo "##### $ep"; echo "$out" | head -c 4000; echo; fi
  done
done
