set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'RSH'
set +e
CA=$HOME/.local/share/keplerops/ca.crt
JWT=$(kubectl config view --raw -o jsonpath='{.users[0].user.token}')
C=https://cloud-api.keplerops.test
B="Authorization: Bearer $JWT"
show(){ echo "--- $1"; shift; curl -sS -m 12 --cacert $CA -w '\n[%{http_code}]\n' "$@" | head -c 1600; echo; }
echo "###### workspace exchange GET"
show "GET exchange" -H "$B" "$C/api/workspaces/current/token-exchange"
echo "###### workspace exchange POST empty"
show "POST exchange {}" -X POST -H "$B" -H 'Content-Type: application/json' -d '{}' "$C/api/workspaces/current/token-exchange"
echo "###### workspace exchange POST bearer body"
show "POST exchange token" -X POST -H 'Content-Type: application/json' -d "{\"workspace_token\":\"$JWT\"}" "$C/api/workspaces/current/token-exchange"
echo "###### workspace exchange POST identity"
show "POST exchange identity" -X POST -H "$B" -H 'Content-Type: application/json' -d '{"audience":"data.keplerops.test","role":"export-reader"}' "$C/api/workspaces/current/token-exchange"
echo "###### kubectl auth"
kubectl auth can-i --list -n fieldlink 2>&1 | head -40
echo "###### k8s resources"
kubectl -n fieldlink get sa,role,rolebinding,cm,secret,job,cronjob,deploy 2>&1 | head -60
echo "###### s3 list"
export AWS_CA_BUNDLE=$CA
aws --endpoint-url https://objects.keplerops.test s3 ls s3://fieldlink-exports 2>&1 | head -40
aws --endpoint-url https://objects.keplerops.test s3api get-bucket-policy --bucket fieldlink-exports 2>&1 | head -20
aws --endpoint-url https://objects.keplerops.test sts get-caller-identity 2>&1 | head -20
RSH
echo DONE_S5
