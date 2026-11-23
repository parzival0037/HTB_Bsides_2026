set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
G=https://source.keplerops.test
T='rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo'
mkdir -p /tmp/gt && cd /tmp/gt
for r in connector-archive fieldlink-connector policy-compiler release-signer-history; do
  rm -rf $r
  git clone -q "https://rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo@source.keplerops.test/fieldkest/$r.git" $r 2>&1 | tail -2
  echo "=== $r files ==="; (cd $r && find . -type f -not -path './.git/*' | sort | head -40)
done
echo "===== GREP cinder/alternate/reviewer/handover across repos ====="
grep -rniE 'cinder|alternate|reviewer|delegat|case note|casenote' /tmp/gt --exclude-dir=.git 2>/dev/null | cut -c1-300 | head -60
echo "===== git log all for each repo ====="
for r in connector-archive fieldlink-connector policy-compiler release-signer-history; do
 echo "### $r"; (cd /tmp/gt/$r && git log --all --oneline --stat | head -40)
done
echo "===== all blob grep for cinder (history) ====="
for r in connector-archive fieldlink-connector policy-compiler release-signer-history; do
 (cd /tmp/gt/$r && for o in $(git rev-list --objects --all | awk '{print $1}'); do git cat-file -p $o 2>/dev/null; done) | grep -iE 'cinder|alternate reviewer|delegat' | cut -c1-400 | head -20
done
INNER
echo DONE_R46
