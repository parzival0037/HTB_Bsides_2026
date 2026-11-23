SSH="ssh -o StrictHostKeyChecking=no -o BatchMode=yes -i $HOME/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
$SSH 'bash -s' <<'REMOTE'
CA=/home/rowan/.local/share/keplerops/ca.crt
for h in edge foundation cloud git jenkins registry delivery; do
 echo "##### $h"
 curl -sS --cacert $CA --resolve $h.keplerops.test:443:10.77.51.60 -i -m 10 "https://$h.keplerops.test/.well-known/fieldkest-client" | head -c 1200; echo
 curl -sS --cacert $CA --resolve $h.keplerops.test:443:10.77.51.60 -i -m 10 "https://$h.keplerops.test/" | head -c 600; echo
done
REMOTE
