set +e
ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev '
set +e
export AWS_CA_BUNDLE=/home/rowan/.local/share/keplerops/ca.crt
B=https://objects.keplerops.test
JWT=$(kubectl config view --raw -o jsonpath="{.users[0].user.token}")
echo "===== S3 deep list ====="
aws --endpoint-url $B s3 ls s3://fieldlink-exports/ 2>&1 | head -40
aws --endpoint-url $B s3api list-object-versions --bucket fieldlink-exports 2>&1 | head -60
echo "===== bucket policy ====="
aws --endpoint-url $B s3api get-bucket-policy --bucket fieldlink-exports 2>&1 | head -40
aws --endpoint-url $B s3api get-bucket-acl --bucket fieldlink-exports 2>&1 | head -30
echo "===== STS assume-role guesses ====="
for r in rowan.ito support-export support-export-reader fieldlink-export-reader export-reader fieldlink-support support analyst workload rowan-workspace fieldlink-workload; do
  for arn in "arn:aws:iam::000000000000:role/$r" "$r"; do
    o=$(aws --endpoint-url $B sts assume-role --role-arn "$arn" --role-session-name probe 2>&1 | head -c 200)
    case "$o" in *AccessDenied*|*InvalidClientTokenId*|*ValidationError*|*NoSuchEntity*|*NotFound*) ;; *) echo "-- $arn => $o";; esac
  done
done
echo "===== STS web identity ====="
aws --endpoint-url $B sts assume-role-with-web-identity --role-arn arn:aws:iam::000000000000:role/rowan-workspace --role-session-name probe --web-identity-token "$JWT" 2>&1 | head -20
curl -sSk -m 10 "$B/?Action=AssumeRoleWithWebIdentity&Version=2011-06-15&RoleArn=arn:aws:iam::000000000000:role/rowan-workspace&RoleSessionName=probe&WebIdentityToken=$JWT" | head -c 800; echo
echo "===== IAM probes ====="
for op in get-role list-roles list-users get-user list-attached-role-policies list-role-policies; do
  echo "-- $op"; aws --endpoint-url $B iam $op 2>&1 | head -6
done
echo "===== cloud-api ====="
C=https://cloud-api.keplerops.test
for p in api/trust-records api/trust-records/TR-1 api/trust-records/TR-1/policy api/trust-records/current api/policies api/policies/default api/workspaces api/workspaces/current api/roles api/iam/roles api/token-exchange; do
  code=$(curl -sSk -m 8 -o /tmp/c -w "%{http_code}" -H "Authorization: Bearer $JWT" "$C/$p")
  echo "-- GET $p -> $code :: $(head -c 300 /tmp/c | tr "\n" " ")"
done
echo "===== k8s resources ====="
kubectl get all -n fieldlink 2>&1 | head -30
kubectl get cm,secret -n fieldlink 2>&1 | head -40
kubectl get sa,role,rolebinding -n fieldlink 2>&1 | head -40
kubectl auth can-i --list -n fieldlink 2>&1 | head -30
'
echo DONE_PROBE1
