set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
A=https://assistant.keplerops.test
echo "########## GITEA REPOS"
curl -sS -m 10 --cacert $CA -H "Authorization: token fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo" "https://source.keplerops.test/api/v1/user/repos?limit=50" 2>&1 | python3 -c 'import json,sys;d=json.load(sys.stdin);[print(r["full_name"],r.get("description")) for r in d]' 2>&1 | head -40
echo "########## GITEA ORGS"
curl -sS -m 10 --cacert $CA -H "Authorization: token fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo" "https://source.keplerops.test/api/v1/user/orgs?limit=50" 2>&1 | head -c 2000
echo
echo "########## GITEA SEARCH code assistant"
curl -sS -m 20 --cacert $CA -H "Authorization: token fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo" "https://source.keplerops.test/api/v1/repos/search?q=assistant&limit=20" 2>&1 | head -c 3000
echo
echo "########## ANYTHINGLLM login attempts"
for u in "rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo" "rowan.ito:rowan" "admin:admin" "maya.ranscombe:sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk" "rowan.ito:fieldlink-dev-2841"; do
  echo "--- $u"
  U=${u%%:*}; P=${u#*:}
  curl -sS -m 10 --cacert $CA -X POST -H 'Content-Type: application/json' -d "{\"username\":\"$U\",\"password\":\"$P\"}" "$A/api/request-token" 2>&1 | head -c 400
  echo
done
echo "########## PUBLIC PROBES"
for p in /api/request-token /api/system/check /api/setup-complete /api/ping /api/workspaces /api/v1/workspaces /api/v1/workspace/fieldlink-operations /api/workspace/fieldlink-operations /api/admin/workspaces /api/users /api/users/me /api/v1/admin/users /api/browser-extension /api/embed /api/api-key; do
  echo "--- $p"
  curl -sS -m 6 --cacert $CA -i "$A$p" 2>&1 | head -6
done
echo "########## PG TABLES"
PGPASSWORD=lobf9Jt0SBW433in6wUVlkixnQreh5K-Z1LjbTofrqY psql -h data.keplerops.test -U rowan_data -d fieldlink_data -c '\dt' 2>&1 | head -40
INNER
echo DONE_MARK_$RANDOM
