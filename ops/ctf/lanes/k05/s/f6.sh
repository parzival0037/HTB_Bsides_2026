set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<"REMOTE" 2>&1
set +e
CA=$HOME/.local/share/keplerops/ca.crt
A="Authorization: Basic $(printf "rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo" | base64 -w0)"
cd $HOME/repos_k05 2>/dev/null || exit 0
echo "===== TREES ====="
find . -type f | sort
echo "===== TEXT FILES ====="
for f in $(find . -type f \( -name '*.md' -o -name '*.json' -o -name '*.txt' -o -name '*.yaml' -o -name '*.yml' -o -name '*.policy' -o -name '*.sh' \)); do echo "##### $f"; head -c 4000 "$f"; echo; done
echo "===== GREP ====="
grep -rIn "reconcile\|tenant-package\|selected_version\|selection_record\|partition_binding\|rollback_slot\|release_manifest\|reconciliation\|selection" --include='*.md' --include='*.json' --include='*.txt' --include='*.yaml' --include='*.yml' . 2>/dev/null | head -80
REMOTE
