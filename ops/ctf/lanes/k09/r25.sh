set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
run(){ echo "===== $1 ====="; $S "$1" 2>&1; echo; }
run 'cat work/identity-access.md; echo ===; cat work/platform-access.md; echo ===; cat work/registry/README.md; echo ===; cat .config/fieldlink/support-client.json 2>&1'
run 'grep -Ril "entitle" ~ 2>/dev/null | head -50; echo ---; grep -Ril "build.operations\|buildops" ~ 2>/dev/null | head -50'
run 'ls -la ~; ls -la ~/.local/share/keplerops 2>&1; find ~/.local/share/keplerops -maxdepth 2 -type f 2>/dev/null | head -50'
run 'grep -Rin "entitle\|buildops\|build-operations\|BLD-REC" work 2>/dev/null | head -80'
