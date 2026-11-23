C="curl -sS --socks5-hostname 127.0.0.1:1080 --cacert /tmp/ca.crt --max-time 25"
SB="fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b"
A="-u rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"
echo "### diagnostics list/tenant"
for u in "https://support.keplerops.test:8443/api/customers/TEN-ARWC-047/diagnostics" "https://support.keplerops.test:8443/api/diagnostics" "https://support.keplerops.test:8443/api/handovers/current"; do
 echo "-- $u"; $C -i -H "Authorization: Bearer $SB" "$u" | head -c 2500; echo; done
echo "### staff directory + notes"
$C -i $A "https://staff.keplerops.test/api/service-directory" | head -c 2000; echo
$C -i $A "https://staff.keplerops.test/api/notes/NOTE-SUP-2841-7" | head -c 2500; echo
echo "### archive handovers rowan"
$C -i $A "https://staff.keplerops.test/api/archive/handovers/rowan.ito" | head -c 2000; echo
