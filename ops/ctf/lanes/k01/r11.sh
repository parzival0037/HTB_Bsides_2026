set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'RSH'
set +e
U='rowan.ito'
P='fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo'
api(){ curl -sS -m 15 --cacert /home/rowan/.local/share/keplerops/ca.crt -u "$U:$P" -H 'Content-Type: application/json' -d "$1" 'https://staff.keplerops.test/jsonrpc.php'; }
api '{"jsonrpc":"2.0","method":"getAllProjects","id":1}'
echo; echo "---BOARD 1---"
api '{"jsonrpc":"2.0","method":"getBoard","id":1,"params":{"project_id":1}}' | head -c 4000
echo; echo "---PROJECTS2---"
api '{"jsonrpc":"2.0","method":"getProjects","id":1,"params":{"status":1}}' | head -c 2000
RSH
