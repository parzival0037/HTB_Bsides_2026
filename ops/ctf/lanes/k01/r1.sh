set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
run(){ echo "===== $1 ====="; $S "$1" 2>&1; echo; }
run 'cat .bash_history; echo ---; cat .gitconfig; echo ---; cat .npmrc; echo ---; cat .pg_service.conf; echo ---; cat .pgpass; echo ---; cat README.md; echo ---; cat .xsession'
run 'ls -laR work 2>/dev/null | head -200'
run 'ls -la .ssh; echo ---; cat .ssh/config; echo ---; ls -la .aws .kube; echo ---; test -f .aws/credentials && cat .aws/credentials'
run 'ip a; echo ---; ip r; echo ---; cat /etc/hosts; echo ---; cat /etc/resolv.conf; echo ---; hostname; cat /etc/os-release'
