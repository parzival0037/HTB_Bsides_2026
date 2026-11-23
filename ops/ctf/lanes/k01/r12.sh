set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'RSH'
set +e
U='rowan.ito'; P='fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo'
CA=/home/rowan/.local/share/keplerops/ca.crt
api(){ curl -sS -m 15 --cacert $CA -u "$U:$P" -H 'Content-Type: application/json' -d "$1" 'https://staff.keplerops.test/jsonrpc.php'; }
echo "---TASK1---"; api '{"jsonrpc":"2.0","method":"getTask","id":1,"params":{"task_id":1}}'
echo; echo "---COMMENTS---"; api '{"jsonrpc":"2.0","method":"getAllComments","id":1,"params":{"task_id":1}}'
echo; echo "---FILES---"; api '{"jsonrpc":"2.0","method":"getAllTaskFiles","id":1,"params":{"task_id":1}}'
echo; echo "---PROJECT1---"; api '{"jsonrpc":"2.0","method":"getProjectById","id":1,"params":{"project_id":1}}'
RSH
