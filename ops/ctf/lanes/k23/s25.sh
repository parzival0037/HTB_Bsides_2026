#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"; K="-k -sS -m 40"; H="https://assistant.keplerops.test"
TOK=$(curl $K $P -X POST $H/api/request-token -H 'Content-Type: application/json' \
  -d '{"username":"maya.ranscombe","password":"sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk"}' \
  | python3 -c 'import sys,json;print(json.load(sys.stdin)["token"])')
echo "== local-files list"
curl $K $P -H "Authorization: Bearer $TOK" "$H/api/system/local-files?limit=50" -w "\n[%{http_code}]\n" | head -c 2000
echo; echo "== by-docpaths"
curl $K $P -X POST "$H/api/system/local-files/by-docpaths" -H "Authorization: Bearer $TOK" -H 'Content-Type: application/json' \
 -d '{"docpaths":["custom-documents/ESC-SUP-2841-R3.md-cbab6ed8-098e-426f-8f43-f7a91a8ba564.json","custom-documents/ATT-DIAG-698.md-e0e1ca8f-7974-49e9-9637-8747909b8005.json","custom-documents/COMP-JOB-17.md-5a99de5c-9428-412a-ba41-598883f3de3f.json","custom-documents/ESC-SUP-2841-R3.md-8362fc86-281d-4a24-b6d6-a9e71bb1404c.json"]}' \
 -w "\n[%{http_code}]\n" | head -c 12000
