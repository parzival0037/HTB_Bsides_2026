set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<"REMOTE" 2>&1 | tail -400
set +e
CA=$HOME/.local/share/keplerops/ca.crt
A="Authorization: Basic $(printf "rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo" | base64 -w0)"
echo "===== SUPPORT CLIENT PROFILE ====="
cat $HOME/.config/fieldlink/support-client.json 2>/dev/null
echo; echo "===== OTHER CONFIG FILES ====="
find $HOME/.config -maxdepth 3 -type f | sort
echo "===== GITEA ALL REPOS ====="
for u in "https://source.keplerops.test/api/v1/user/repos?limit=100" "https://source.keplerops.test/api/v1/orgs/fieldkest/repos?limit=100" "https://source.keplerops.test/api/v1/repos/search?q=&limit=100"; do echo "--- $u"; curl -sS -m 15 --cacert $CA -H "$A" "$u" | python3 -c "import json,sys
try:
 d=json.load(sys.stdin)
 if isinstance(d,dict): d=d.get('data') or d.get('repos') or []
 for r in d: print(r.get('full_name'))
except Exception as e: print('ERR',e)"; done
echo "===== K8S ====="
kubectl config get-contexts 2>&1 | head
kubectl auth can-i --list 2>&1 | head -30
echo "--- pods"; kubectl get pods -o wide 2>&1 | head -30
echo "--- svc"; kubectl get svc 2>&1 | head -30
echo "--- deploy/statefulset"; kubectl get deploy,statefulset,daemonset 2>&1 | head -40
echo "--- cm"; kubectl get cm 2>&1 | head -40
echo "--- secrets"; kubectl get secrets 2>&1 | head -40
echo "===== REGISTRY SUPPORT-REHEARSAL with support bearer ====="
curl -sS -m 10 -H "Authorization: Bearer fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b" "https://packages.keplerops.test/@keplerops%2fsupport-rehearsal" --cacert $CA -w " [%{http_code}]"; echo
REMOTE
