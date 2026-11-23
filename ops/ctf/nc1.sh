set +e
P="curl -sS -m 10 --socks5-hostname 127.0.0.1:1080 -k"
U="rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"
echo "=== identify ==="; $P -o /tmp/n1 -w '[%{http_code}] ' https://cloud.keplerops.test/status.php; head -c 200 /tmp/n1; echo
echo "=== webdav with rowan ==="
$P -u "$U" -X PROPFIND -H 'Depth: 1' -o /tmp/n2 -w '[%{http_code}]\n' https://cloud.keplerops.test/remote.php/dav/files/rowan.ito/
head -c 600 /tmp/n2; echo
echo "=== dav roots ==="
for u in rowan rowan.ito maya.ranscombe; do printf '%-16s ' $u; $P -u "$U" -X PROPFIND -H 'Depth: 0' -o /dev/null -w '%{http_code}\n' "https://cloud.keplerops.test/remote.php/dav/files/$u/"; done
