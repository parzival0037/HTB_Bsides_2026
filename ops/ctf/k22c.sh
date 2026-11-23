set +e
P="curl -sS -m 10 --socks5-hostname 127.0.0.1:1080 -k"
TOK=$($P -X POST -H 'Content-Type: application/json' -d '{"username":"rowan.ito","password":"fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"}' https://assistant.keplerops.test/api/request-token | python3 -c "import sys,json;print(json.load(sys.stdin).get('token',''))")
for slug in support-private rill-support fieldlink-operations; do
  echo "=== $slug"
  $P -H "Authorization: Bearer $TOK" "https://assistant.keplerops.test/api/workspace/$slug" | python3 -c "
import sys,json
d=json.load(sys.stdin)
w=d.get('workspace',d)
for k,v in w.items():
    if isinstance(v,str) and len(v)<600: print(f'  {k}: {v}')
" 2>/dev/null
done
