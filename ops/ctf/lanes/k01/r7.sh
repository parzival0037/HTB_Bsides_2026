set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
run(){ echo "===== $1 ====="; $S "$1" 2>&1; echo; }
CA=/home/rowan/.local/share/keplerops/ca.crt
run "curl -sS -m 8 --cacert $CA -c /tmp/ck 'https://support.keplerops.test/scp/login.php' | grep -oE '<form[^>]*>|name=\"[^\"]+\"[^>]*|__CSRFToken__[^>]*' | head -20"
run "curl -sS -m 8 --cacert $CA 'https://staff.keplerops.test/login' | head -80"
