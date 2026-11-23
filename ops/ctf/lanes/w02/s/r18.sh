SSH="ssh -o StrictHostKeyChecking=no -o BatchMode=yes -i $HOME/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
$SSH 'bash -s' <<'REMOTE'
CA=/home/rowan/.local/share/keplerops/ca.crt
echo "### cert 51.60"; echo | openssl s_client -connect 10.77.51.60:443 -servername x 2>/dev/null | openssl x509 -noout -subject -ext subjectAltName 2>/dev/null
echo "### root 51.60"; curl -sS -k -i -m 10 https://10.77.51.60/ | head -c 2000; echo
echo "### with cafile"; curl -sS --cacert $CA -i -m 10 https://10.77.51.60/ | head -c 800; echo
echo "### cert 51.30:8443"; echo | openssl s_client -connect 10.77.51.30:8443 -servername x 2>/dev/null | openssl x509 -noout -subject -ext subjectAltName 2>/dev/null
echo "### 51.60 well-known"; curl -sS -k -m 10 https://10.77.51.60/.well-known/fieldkest-client | head -c 1500; echo
echo "### 51.60 robots"; curl -sS -k -m 10 https://10.77.51.60/robots.txt | head -c 500; echo
REMOTE
