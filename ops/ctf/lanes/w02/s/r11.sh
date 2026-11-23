C="curl -sS --socks5-hostname 127.0.0.1:1080 --cacert /tmp/ca.crt --max-time 25"
for u in https://indexer.keplerops.test/.well-known/fieldkest-client https://indexer.keplerops.test/ https://preview.keplerops.test/ https://cloud-api.keplerops.test/.well-known/fieldkest-client; do
echo "##### $u"; $C -i "$u" | head -c 4500; echo; done
