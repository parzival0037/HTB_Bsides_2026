C="curl -sS --socks5-hostname 127.0.0.1:1080 --cacert /tmp/ca.crt --max-time 20"
for u in \
 https://delivery.keplerops.test:8443/.well-known/fieldkest-client \
 https://delivery.keplerops.test:8443/ \
 https://staff.keplerops.test/.well-known/fieldkest-client \
 https://staff.keplerops.test/api/service-directory \
 https://workboard.keplerops.test/.well-known/fieldkest-client \
 ; do echo "##### $u"; $C "$u" | head -c 4000; echo; done
