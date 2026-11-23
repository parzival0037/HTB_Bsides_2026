set +e
ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev 'bash -s' <<'RSH'
set +e
CA=$HOME/.local/share/keplerops/ca.crt
A="Authorization: Basic $(printf "rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo" | base64 -w0)"
B=https://source.keplerops.test/api/v1/repos/fieldkest
for f in delivery/README.md delivery/.gitignore; do
 echo "###### $f"; curl -sS -m 15 --cacert $CA -H "$A" "$B/fieldlink-connector/raw/$f?ref=delivery-operations"; echo
done
echo "###### commits diff dfee65cf9e"
curl -sS -m 20 --cacert $CA -H "$A" "$B/fieldlink-connector/git/commits/dfee65cf9e" | python3 -m json.tool | head -60
echo "###### commit d1b7679f59"
curl -sS -m 20 --cacert $CA -H "$A" "$B/fieldlink-connector/git/commits/d1b7679f59" | python3 -m json.tool | head -80
RSH
echo DONE_A7
