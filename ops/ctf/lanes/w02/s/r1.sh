set -x
P="--socks5-hostname 127.0.0.1:1080 -k -sS"
for u in https://connector.arwc.test/ https://connector.arwc.test/.well-known/fieldkest-client https://source.keplerops.test/api/v1/repos/search?q=arwc https://source.keplerops.test/api/v1/repos/search?q=outlet; do
echo "### $u"
timeout 25 curl $P "$u" | head -c 3000
echo
done
