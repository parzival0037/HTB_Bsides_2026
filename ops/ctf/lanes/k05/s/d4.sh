set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'CA=$HOME/.local/share/keplerops/ca.crt
A="Authorization: Basic $(printf "rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo" | base64 -w0)"
cd ~ && rm -rf repos && mkdir repos && cd repos
for r in connector-archive fieldlink-connector release-signer-history policy-compiler; do
 curl -sS -m 30 -H "$A" -o $r.zip "https://source.keplerops.test/api/v1/repos/fieldkest/$r/archive/main.zip" --cacert $CA
 unzip -qo $r.zip -d $r 2>/dev/null || echo "unzip fail $r"
done
echo "=== grep reconcile/binding"; grep -rIn "reconcile\|binding\|selected_version\|release_manifest" . 2>/dev/null | head -30
echo "=== release-signer README"; find release-signer-history -name README.md -exec cat {} \;
echo "=== policy compiler README"; find policy-compiler -name README.md -exec cat {} \; | head -60' 2>&1 | tail -80
