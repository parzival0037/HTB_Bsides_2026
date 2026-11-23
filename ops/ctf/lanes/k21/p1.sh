set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
A=https://assistant.keplerops.test
login(){ curl -sS -m 10 --cacert $CA -X POST -H 'Content-Type: application/json' -d "{\"username\":\"$1\",\"password\":\"$2\"}" "$A/api/request-token" | python3 -c 'import json,sys;d=json.load(sys.stdin);print(d.get("token") or "NONE")'; }
RT=$(login rowan.ito fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo)
MT=$(login maya.ranscombe sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk)
echo "RT=${#RT} MT=${#MT}"
echo "########## frontend doc routes"
[ -s /tmp/idx.js ] || curl -sS -m 25 --cacert $CA "$A/index.js" -o /tmp/idx.js
grep -oE '\$\{C\}/[a-zA-Z0-9:_/{}$.-]+' /tmp/idx.js | sort -u | head -120
echo "########## doc-related literals"
grep -oE '"/api/[a-zA-Z0-9:_/{}$.-]+"' /tmp/idx.js | sort -u | head -120
echo "########## UPDATE chatMode rowan"
curl -sS -m 10 --cacert $CA -H "Authorization: Bearer $RT" -H 'Content-Type: application/json' -X POST -d '{"chatMode":"chat"}' -w '\nHTTP:%{http_code}\n' "$A/api/workspace/support-private/update" | head -c 1200
echo
echo "########## read back"
curl -sS -m 10 --cacert $CA -H "Authorization: Bearer $RT" "$A/api/workspace/support-private" | python3 -c 'import json,sys;w=json.load(sys.stdin)["workspace"];print("chatMode=",w.get("chatMode"));print("prompt=",w.get("openAiPrompt"))'
echo "########## TRY /api/workspace/support-private/thread/new"
curl -sS -m 10 --cacert $CA -H "Authorization: Bearer $RT" -X POST "$A/api/workspace/support-private/thread/new" -w '\nHTTP:%{http_code}\n' | head -c 600
echo
echo "########## user list probes"
for p in /api/users /api/admin/users /api/admin/workspace-users /api/workspace/support-private/users; do
  echo "--- $p"; curl -sS -m 8 --cacert $CA -H "Authorization: Bearer $RT" -w '\nHTTP:%{http_code}\n' "$A$p" | head -c 600; echo
done
echo "########## roles of maya token via /api/users"
curl -sS -m 8 --cacert $CA -H "Authorization: Bearer $MT" -w '\nHTTP:%{http_code}\n' "$A/api/users" | head -c 800
INNER
echo DONE_MARK_$RANDOM
