set +e
R=/home/rowan/.local/share/keplerops/ca.crt
U=https://staff.keplerops.test/api/archive/delegation/probe
SPN="HTTP/staff.keplerops.test@KEPLEROPS.TEST"
try() { printf '%-70s ' "$1"; ssh -o BatchMode=yes rowan-dev "curl -sS -m 12 --cacert $R --cert /tmp/evan.calderoux.crt --key /tmp/evan.calderoux.key -X POST -H 'Content-Type: application/json' -d '$1' $U" | python3 -c "import sys,json;d=json.load(sys.stdin);print({k:(str(v)[:40] if k!='credential_cache' else 'cc') for k,v in d.items()})" 2>/dev/null; echo; }
try "{\"spn\":\"$SPN\",\"subject\":\"DIAG-CRR-MIXED-19\",\"reviewer\":\"cedar-run-diagnostic-session\"}"
try "{\"spn\":\"$SPN\",\"subject\":\"DIAG-CRR-MIXED-19\"}"
try "{\"spn\":\"$SPN\",\"reviewer\":\"cedar-run-diagnostic-session\"}"
try "{\"spn\":\"$SPN\",\"handover\":\"DIAG-CRR-MIXED-19\",\"reviewer\":\"cedar-run-diagnostic-session\"}"
