set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
run(){ echo "===== $1 ====="; $S "$1" 2>&1; echo; }
CA=/home/rowan/.local/share/keplerops/ca.crt
run "curl -sS -m 8 -i --cacert $CA 'https://support.keplerops.test:8443/' | head -30"
run "curl -sS -m 8 -i --cacert $CA -H 'Authorization: Bearer fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b' 'https://support.keplerops.test:8443/scp/tickets.php' | head -30"
run "curl -sS -m 8 -i --cacert $CA 'https://staff.keplerops.test/' | head -30; echo ---; curl -sS -m 8 -i --cacert $CA 'https://staff.keplerops.test/api/' | head -20"
run "curl -sS -m 8 -i --cacert $CA -c /tmp/ck -b /tmp/ck 'https://support.keplerops.test/scp/login.php' | head -40"
