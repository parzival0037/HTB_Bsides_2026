#!/bin/bash
set +e
P="--socks5-hostname 127.0.0.1:1080 -k -sS -m 8"
for h in assistant staff workboard tickets data ca identity id support llm cert cloud-api corporate planning allocation reports records documents archive water arwc delivery indexer objects workloads source source-tools packages ci review preview; do
  for port in 443 8443; do
    url="https://$h.keplerops.test:$port/.well-known/fieldkest-client"
    out=$(curl $P -w '\n%{http_code}' "$url" 2>/dev/null)
    code=$(echo "$out" | tail -1)
    body=$(echo "$out" | sed '$d' | head -c 400)
    if [ "$code" = "200" ]; then echo "OK $h:$port $body"; fi
  done
done
echo "== arwc hosts"
for h in connector planning allocation corporate records docs reports api portal water cairn hmi; do
  out=$(curl $P -w '\n%{http_code}' "https://$h.arwc.test/.well-known/fieldkest-client" 2>/dev/null)
  echo "$h.arwc.test $(echo "$out"|tail -1) $(echo "$out"|sed '$d'|head -c 150)"
done
echo DONE_R13
