set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<"REMOTE" 2>&1 | tail -300
cd $HOME/repos_k05/policy-compiler/policy-compiler
echo "===== README ====="
cat README.md
echo "===== API TEMPLATES ====="
for f in api/*.json examples/*; do echo "##### $f"; cat "$f"; echo; done
REMOTE
