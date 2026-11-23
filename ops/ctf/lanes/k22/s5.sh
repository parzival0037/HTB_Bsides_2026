set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
A=https://assistant.keplerops.test
TK=$(curl -sS -m 15 --cacert $CA -X POST -H 'Content-Type: application/json' -d '{"username":"maya.ranscombe","password":"sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk"}' $A/api/request-token | python3 -c "import sys,json;print(json.load(sys.stdin)['token'])")
echo "tokenlen ${#TK}"
ap(){ p="$1"; m="${2:-GET}"; echo "### $m $p"; curl -sS -m 15 --cacert $CA -H "Authorization: Bearer $TK" -X "$m" -H 'Content-Type: application/json' -o /tmp/a.out -w '%{http_code} %{content_type} %{size_download}\n' "$A$p"; head -c 3000 /tmp/a.out; echo; }
ap /api/workspace/fieldlink-operations
ap /api/workspace/support-private
ap /api/workspace/support-private/threads
ap /api/workspaces/1
ap /api/workspaces/2
ap /api/v1/workspaces
echo "===== docs (documents endpoint) ====="
for p in /api/workspace/support-private/documents /api/documents /api/workspace/fieldlink-operations/documents; do ap $p; done
INNER
