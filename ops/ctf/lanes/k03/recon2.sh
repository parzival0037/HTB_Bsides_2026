#!/bin/bash
CA=$HOME/k25/ca.crt
TOK='fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b'
BAS='rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo'
C="curl --socks5-hostname 127.0.0.1:1080 -sS -m 25 --cacert $CA"
echo "### preview client ref"
$C https://preview.keplerops.test/.well-known/fieldkest-client | python3 -m json.tool
echo "### review client ref"
$C https://review.keplerops.test/.well-known/fieldkest-client | python3 -m json.tool
echo "### support client ref :8443"
$C https://support.keplerops.test:8443/.well-known/fieldkest-client | python3 -m json.tool
echo "### preview assoc ATT-DIAG-698 (bearer support)"
$C -H "Authorization: Bearer $TOK" 'https://preview.keplerops.test/api/preview/association?source=ATT-DIAG-698'; echo
echo "### preview assoc ATT-DIAG-698 (no auth)"
$C 'https://preview.keplerops.test/api/preview/association?source=ATT-DIAG-698'; echo
echo "### preview assoc ATT-DIAG-698 (basic rowan)"
$C -u "$BAS" 'https://preview.keplerops.test/api/preview/association?source=ATT-DIAG-698'; echo
echo "### preview documents (bearer support) {}"
$C -H "Authorization: Bearer $TOK" -H 'Content-Type: application/json' -d '{}' https://preview.keplerops.test/api/preview/documents; echo
echo "### preview documents (no auth) {}"
$C -H 'Content-Type: application/json' -d '{}' https://preview.keplerops.test/api/preview/documents; echo
echo "### review jobs (bearer support)"
$C -H "Authorization: Bearer $TOK" https://review.keplerops.test/api/jobs; echo
echo "### review jobs (basic rowan)"
$C -u "$BAS" https://review.keplerops.test/api/jobs; echo
echo "### support handovers current"
$C -H "Authorization: Bearer $TOK" https://support.keplerops.test:8443/api/handovers/current | head -c 1500; echo
