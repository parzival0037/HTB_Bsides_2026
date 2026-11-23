C="curl -sS --socks5-hostname 127.0.0.1:1080 --cacert /tmp/ca.crt --max-time 25"
A="-u rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"
B=https://delivery.keplerops.test:8443
for i in INSP-2047; do
echo "### trace $i"
$C -i "$B/api/inspections/$i/trace" $A | head -c 4000; echo
echo "### no auth trace $i"
$C -i "$B/api/inspections/$i/trace" | head -c 800; echo
done
