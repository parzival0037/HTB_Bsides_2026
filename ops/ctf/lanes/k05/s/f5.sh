set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<"REMOTE" 2>&1 | tail -500
set +e
CA=$HOME/.local/share/keplerops/ca.crt
A="Authorization: Basic $(printf "rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo" | base64 -w0)"
cd $HOME && rm -rf repos_k05 && mkdir repos_k05 && cd repos_k05
for r in policy-compiler release-signer-history connector-archive; do
  curl -sS -m 30 --cacert $CA -H "$A" -o $r.zip "https://source.keplerops.test/api/v1/repos/fieldkest/$r/archive/main.zip"
  mkdir -p $r; unzip -qo $r.zip -d $r 2>/dev/null || echo "unzip fail $r"
  echo "===== TREE $r ====="
  find $r -type f | sed "s#^$r/##" | sort
done
echo "===== ALL TEXT GREP reconcile/selection/tenant/binding/manifest ====="
grep -rIn "reconcile\|tenant-package\|selected_version\|selection_record\|partition_binding\|rollback_slot\|release_manifest\|reconciliation" . 2>/dev/null | head -80
echo "===== POLICY COMPILER FILES ====="
for f in $(find policy-compiler -type f | sort); do echo "##### $f"; cat "$f"; echo; done
echo "===== RELEASE SIGNER FILES ====="
for f in $(find release-signer-history -type f | sort); do echo "##### $f"; cat "$f"; echo; done
echo "===== CLOUD BUILD RECORD BLD-REL-742 ====="
JWT=$(kubectl config view --raw -o jsonpath='{.users[0].user.token}')
for b in BLD-REL-742 BLD-1842 BLD-REL-741 BLD-REL-698; do echo "--- $b"; curl -sS -m 10 --cacert $CA -H "Authorization: Bearer $JWT" "https://cloud-api.keplerops.test/api/build-records/$b" -w " [%{http_code}]"; echo; done
echo "===== CLOUD EXPORTS ====="
for e in EXP-2841; do for suf in "" /definition /revisions /handover; do echo "--- $e$suf"; curl -sS -m 10 --cacert $CA -H "Authorization: Bearer $JWT" "https://cloud-api.keplerops.test/api/exports/$e$suf" -w " [%{http_code}]"; echo; done; done
REMOTE
