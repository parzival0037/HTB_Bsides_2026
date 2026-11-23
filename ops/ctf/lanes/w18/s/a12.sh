#!/bin/bash
KO="ssh -i $HOME/.ssh/keplerops-foothold -p 2222 -o StrictHostKeyChecking=no -o ConnectTimeout=10 rowan@10.50.13.180"
$KO '
echo "===== certs"; ls -la ~/work/certificates; for f in ~/work/certificates/*.crt; do echo "## $f"; openssl x509 -in "$f" -noout -subject -issuer -dates -ext subjectAltName 2>&1; done
echo "===== krb cache"; ls -la ~/work/krb5cc_evan 2>&1; KRB5CCNAME=$HOME/work/krb5cc_evan klist 2>&1 | head -20
echo "===== openssl client cert request"; echo | timeout 12 openssl s_client -connect 10.77.60.20:443 -servername connector.arwc.test 2>&1 | grep -iE "acceptable|client certificate|subject=|issuer=|verify" | head -20
echo "===== poll noauth"; curl -sS -k -m 10 -X POST -o /tmp/o -w "[%{http_code}] " https://connector.arwc.test/api/fieldlink/packages/poll; head -c 200 /tmp/o; echo
for C in rowan.ito evan.calderoux; do
 echo "===== poll mtls $C"
 curl -sS -k -m 12 --cert $HOME/work/certificates/$C.crt --key $HOME/work/certificates/$C.key -X POST -o /tmp/o -w "[%{http_code}] " https://connector.arwc.test/api/fieldlink/packages/poll; head -c 300 /tmp/o; echo
done
echo "===== diagnostics noauth"; curl -sS -k -m 10 -o /tmp/o -w "[%{http_code}] " https://connector.arwc.test/api/fieldlink/diagnostics; head -c 300 /tmp/o; echo
for C in rowan.ito evan.calderoux; do
 echo "===== diagnostics mtls $C"
 curl -sS -k -m 12 --cert $HOME/work/certificates/$C.crt --key $HOME/work/certificates/$C.key -o /tmp/o -w "[%{http_code}] " https://connector.arwc.test/api/fieldlink/diagnostics; head -c 500 /tmp/o; echo
done
echo "===== negotiate poll"; KRB5CCNAME=$HOME/work/krb5cc_evan curl -sS -k -m 15 --negotiate -u : -X POST -o /tmp/o -w "[%{http_code}] " https://connector.arwc.test/api/fieldlink/packages/poll; head -c 300 /tmp/o; echo
echo "===== negotiate diagnostics"; KRB5CCNAME=$HOME/work/krb5cc_evan curl -sS -k -m 15 --negotiate -u :  -o /tmp/o -w "[%{http_code}] " https://connector.arwc.test/api/fieldlink/diagnostics; head -c 300 /tmp/o; echo
' 2>&1
