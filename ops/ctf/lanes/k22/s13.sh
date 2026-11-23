set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
A=https://assistant.keplerops.test
TK=$(curl -sS -m 15 --cacert $CA -X POST -H 'Content-Type: application/json' -d '{"username":"maya.ranscombe","password":"sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk"}' $A/api/request-token | python3 -c "import sys,json;print(json.load(sys.stdin)['token'])")
ap(){ p="$1"; m="${2:-GET}"; echo "### $m $p"; curl -sS -m 20 --cacert $CA -H "Authorization: Bearer $TK" -X "$m" -o /tmp/x.out -w '%{http_code} %{content_type} %{size_download}\n' "$A$p"; head -c 2500 /tmp/x.out; echo; }
ap /api/system/workspace-chats
ap /api/system/local-files
ap '/api/system/local-files/search?q=DIAG'
ap /api/system/user
INNER
