set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<"REMOTE" 2>&1 | tail -500
set +e
CA=$HOME/.local/share/keplerops/ca.crt
A="Authorization: Basic $(printf "rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo" | base64 -w0)"
echo "===== SERVICE NOTES ====="
for f in $HOME/work/service-notes.md $HOME/work/identity-access.md $HOME/work/platform-access.md $HOME/work/local-helper.md $HOME/work/build-operations/*.md $HOME/work/analysis/staging-decoder.ps1 $HOME/work/reproducers/indexer-client.json $HOME/work/samples/FK-SAMPLE-017.json; do echo "##### $f"; cat "$f"; echo; done
echo "===== GITEA ISSUES ====="
G=https://source.keplerops.test/api/v1/repos/fieldkest/fieldlink-connector
for n in 1 2 3 4 5 6; do echo "--- issue $n"; curl -sS -m 12 --cacert $CA -H "$A" "$G/issues/$n" | python3 -c "import json,sys
try:
 d=json.load(sys.stdin)
 print('TITLE:',d.get('title')); print(d.get('body'))
except Exception as e: print('ERR',e)"; done
echo "===== GITEA ISSUE COMMENTS 1-3 ====="
for n in 1 2 3; do echo "--- comments issue $n"; curl -sS -m 12 --cacert $CA -H "$A" "$G/issues/$n/comments" | python3 -c "import json,sys
try:
 d=json.load(sys.stdin)
 for c in d: print('USER:',c.get('user',{}).get('login')); print(c.get('body')); print('---')
except Exception as e: print('ERR',e)"; done
echo "===== GIT HISTORY FULL ====="
cd $HOME/work/fieldlink-connector
git log --all --stat --decorate | head -80
echo "--- tag contents"; git ls-tree -r fk-test-6d1e9f7 | head -40
echo "--- deleted fixture"; git show 80560bc:fixtures/report-crr-og2.json 2>&1 | head -60
echo "===== SELECTION RECORD SEARCH ====="
grep -rIn "SEL-\|selection\|selected_version\|selection_record\|manifest" $HOME/work 2>/dev/null | head -60
echo "===== SUPPORT SELECTION / DIAGNOSTICS ====="
B="Authorization: Bearer fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b"
for pth in /api/diagnostics/DIAG-ARWC-0214CB78 /api/diagnostics/DIAG-ARWC-0214CB78/package /api/diagnostics/JOB-215D690E28A8; do echo "--- $pth"; curl -sS -m 10 -H "$B" "https://support.keplerops.test:8443$pth" --cacert $CA -w " [%{http_code}]"; echo; done
REMOTE
