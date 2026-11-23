set +e
R=/home/rowan/.local/share/keplerops/ca.crt
U=https://staff.keplerops.test/api/archive/delegation/probe
SPN="HTTP/staff.keplerops.test@KEPLEROPS.TEST"
run() { ssh -o BatchMode=yes rowan-dev "curl -sS -m 12 --cacert $R --cert $2 --key ${2%.crt}.key -X POST -H 'Content-Type: application/json' -d '$1' -w ' [%{http_code}] ' $U" | head -c 500; echo; }
echo "--- spn only"; run "{\"spn\":\"$SPN\"}" /tmp/evan.calderoux.crt
echo "--- spn + reviewer"; run "{\"spn\":\"$SPN\",\"reviewer\":\"talia.mornac-review\"}" /tmp/evan.calderoux.crt
echo "--- spn + subject + reviewer"; run "{\"spn\":\"$SPN\",\"subject\":\"DIAG-CRR-MIXED-19\",\"reviewer\":\"talia.mornac-review\"}" /tmp/evan.calderoux.crt
echo "--- with maya cert"; run "{\"spn\":\"$SPN\",\"subject\":\"DIAG-CRR-MIXED-19\",\"reviewer\":\"talia.mornac-review\"}" /tmp/maya.ranscombe.crt
