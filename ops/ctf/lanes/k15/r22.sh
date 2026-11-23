set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'RSH'
set +e
CA=$HOME/.local/share/keplerops/ca.crt
echo "=== full cloud-api well-known"
curl -sS -m 10 --cacert "$CA" https://cloud-api.keplerops.test/.well-known/fieldkest-client | python3 -m json.tool
RSH
