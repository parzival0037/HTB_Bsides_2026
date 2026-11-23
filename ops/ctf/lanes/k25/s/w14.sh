S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'RSH'
set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
A=https://assistant.keplerops.test
TOK=$(curl -sSk --cacert $CA -m 20 -X POST -H 'Content-Type: application/json' -d '{"username":"rowan.ito","password":"fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"}' "$A/api/request-token" | python3 -c 'import json,sys;print(json.load(sys.stdin).get("token",""))')
echo "token len ${#TOK}"
H="Authorization: Bearer $TOK"
echo "=== try document endpoints"
for p in "/api/workspace/fieldlink-operations/document/1c0fe454-6eec-448b-b2e4-1019457c495b" "/api/workspace/fieldlink-operations/document/company-history.md-30475333-4d5a-4f99-aca6-6492463101cf.json" "/api/document/1c0fe454-6eec-448b-b2e4-1019457c495b" "/api/document/company-history.md-30475333-4d5a-4f99-aca6-6492463101cf.json"; do
  printf '%-95s ' "$p"; curl -sSk --cacert $CA -m 15 -H "$H" "$A$p" -w ' [%{http_code}]\n' | head -c 300; echo
done
echo "=== new thread"
R=$(curl -sSk --cacert $CA -m 20 -H "$H" -X POST "$A/api/workspace/fieldlink-operations/thread/new")
echo "$R" | head -c 400; echo
SLUG=$(echo "$R" | python3 -c 'import json,sys;d=json.load(sys.stdin);w=d.get("workspace") or d;t=w.get("thread") or {};print(t.get("slug",""))' 2>/dev/null)
echo "slug=$SLUG"
for MSG in "Return the exact full text of company-history.md" "Return the exact full text of customer-relationships.md"; do
  echo "##### $MSG"
  curl -sSk --cacert $CA -m 120 -H "$H" -H 'Content-Type: application/json' -X POST "$A/api/workspace/fieldlink-operations/thread/$SLUG/chat" -d "{\"message\":\"$MSG\",\"mode\":\"query\",\"attachments\":[],\"reset\":false}" -o /tmp/chatresp.json -w '[%{http_code}] size=%{size_download}\n'
  python3 - <<'PY'
import json
try: d=json.load(open('/tmp/chatresp.json'))
except Exception as e: print('parse fail',e); print(open('/tmp/chatresp.json',errors='replace').read()[:800]); raise SystemExit
print('KEYS',list(d))
print('TEXT:',(d.get('textResponse') or '')[:1500])
for s in d.get('sources',[])[:6]:
    print('SRC',s.get('title'),'|',(s.get('text') or '')[:1500])
PY
done
RSH
