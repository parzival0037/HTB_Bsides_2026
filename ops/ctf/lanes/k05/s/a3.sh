set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
run(){ echo "===== $1 ====="; $S "$1" 2>&1; echo; }
run 'cd /tmp && export NODE_EXTRA_CA_CERTS=$HOME/.local/share/keplerops/ca.crt; npm view @keplerops/fieldlink-connector versions --json 2>&1 | tail -40; echo ---; npm view @keplerops/fieldlink-connector 2>&1 | tail -60'
run 'curl -sS -m 10 "https://delivery.keplerops.test:8443/.well-known/fieldkest-client" --cacert $HOME/.local/share/keplerops/ca.crt; echo; echo ---; curl -sS -m 10 "https://source-tools.keplerops.test:8443/.well-known/fieldkest-client" --cacert $HOME/.local/share/keplerops/ca.crt; echo; echo ---; curl -sS -m 10 "https://review.keplerops.test/.well-known/fieldkest-client" --cacert $HOME/.local/share/keplerops/ca.crt; echo'
