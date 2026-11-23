set +e
ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev 'cat ~/work/platform-access.md; echo; echo "##### support dirs"; ls -la ~/work/analysis ~/work/build-operations ~/work/previews ~/work/reproducers ~/work/samples ~/work/registry 2>&1'
echo "=== AWS STS ==="
ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev 'AWS_CA_BUNDLE=/home/rowan/.local/share/keplerops/ca.crt aws --endpoint-url https://objects.keplerops.test sts get-caller-identity 2>&1; echo "--- list buckets"; AWS_CA_BUNDLE=/home/rowan/.local/share/keplerops/ca.crt aws --endpoint-url https://objects.keplerops.test s3 ls 2>&1; echo "--- iam probe"; AWS_CA_BUNDLE=/home/rowan/.local/share/keplerops/ca.crt aws --endpoint-url https://objects.keplerops.test iam list-roles 2>&1 | head -20'
echo DONE_RECON3
