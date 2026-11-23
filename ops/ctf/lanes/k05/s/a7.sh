set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'CA=$HOME/.local/share/keplerops/ca.crt
echo "=== results dir"; ls -la ~/results; for f in ~/results/*; do echo "--- $f"; head -c 600 "$f"; echo; done
D="https://delivery.keplerops.test:8443"
for auth in "Authorization: Bearer fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo" "Authorization: Basic $(printf "rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo" | base64 -w0)" "Authorization: Bearer fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b"; do
 echo "=== $auth"
 curl -sS -m 15 -H "$auth" "$D/api/package-meta/fieldlink-connector" --cacert $CA; echo
done' 2>&1 | tail -60
