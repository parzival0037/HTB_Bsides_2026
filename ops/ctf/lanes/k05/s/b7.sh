set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'CA=$HOME/.local/share/keplerops/ca.crt
echo "=== support client ref (bearer)"
curl -sS -m 10 -H "Authorization: Bearer fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b" "https://support.keplerops.test:8443/.well-known/fieldkest-client" --cacert $CA; echo
echo "=== support client ref (basic)"
curl -sS -m 10 -H "Authorization: Basic $(printf "rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo" | base64 -w0)" "https://support.keplerops.test:8443/.well-known/fieldkest-client" --cacert $CA; echo
echo "=== support scp login"
curl -sS -m 10 -i "https://support.keplerops.test/scp/" --cacert $CA | head -20' 2>&1 | tail -40
