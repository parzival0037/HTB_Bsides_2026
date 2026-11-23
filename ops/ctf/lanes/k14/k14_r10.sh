set +e
ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=8 rowan-dev 'bash -s' <<'RSH'
set +e
export AWS_CA_BUNDLE=/home/rowan/.local/share/keplerops/ca.crt
E=https://objects.keplerops.test
echo "=== ANON LIST fieldkest-workspaces ==="
curl -sSk -m 10 "$E/fieldkest-workspaces/?list-type=2" | head -c 4000; echo
echo "=== ANON V1 LIST ==="
curl -sSk -m 10 "$E/fieldkest-workspaces/" | head -c 4000; echo
echo "=== ANON HEAD ==="
curl -sSk -m 10 -I "$E/fieldkest-workspaces/" | head -20
echo "=== SIGNED LIST ==="
aws --endpoint-url $E s3 ls s3://fieldkest-workspaces/ --no-sign-request 2>&1 | head -40
aws --endpoint-url $E s3 ls s3://fieldkest-workspaces/ 2>&1 | head -40
aws --endpoint-url $E s3api list-objects-v2 --bucket fieldkest-workspaces --no-sign-request 2>&1 | head -c 4000; echo
RSH
echo DONE_K14_R10
