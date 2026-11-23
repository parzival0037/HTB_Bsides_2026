set +e
ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=8 rowan-dev 'bash -s' <<'RSH'
set +e
G=https://source.keplerops.test
U='rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo'
cd /tmp
for r in fieldkest/connector-archive fieldkest/policy-compiler fieldkest/release-signer-history fieldkest/fieldlink-connector; do
 n=$(basename $r)
 if [ ! -d /tmp/gr-$n ]; then
   git -c http.sslVerify=false clone -q "https://rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo@source.keplerops.test/$r.git" /tmp/gr-$n 2>&1 | head -3
 fi
done
echo "=== REPO FILES ==="
for d in /tmp/gr-*; do echo "### $d"; find $d -type f -not -path '*/.git/*' | head -40; done
echo "=== GREP TRUST/WORKLOAD/AUDIENCE ==="
grep -rIn -i -E 'trust|workload|audience|token-exchange|assume|oidc|exchange' /tmp/gr-* --exclude-dir=.git 2>/dev/null | head -80
echo "=== NPM SEARCH ==="
N=https://packages.keplerops.test
for q in fieldkest workload trust identity cloud; do
 echo "-- $q"; curl -sSk -m 8 -u "$U" "$N/-/v1/search?text=$q&size=20" | head -c 1200; echo
done
echo "=== NPM ALL PREFIXES ==="
curl -sSk -m 8 -u "$U" "$N/-/all" | head -c 2000; echo
RSH
echo DONE_K14_R8
