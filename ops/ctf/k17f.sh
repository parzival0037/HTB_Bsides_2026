set +e
R=/home/rowan/.local/share/keplerops/ca.crt
C="--cacert $R --cert /tmp/evan.calderoux.crt --key /tmp/evan.calderoux.key"
B=https://staff.keplerops.test
for p in /api/archive/delegation /api/archive/delegation/route /api/archive/delegation/route/DIAG-CRR-MIXED-19 /api/archive/delegations /api/archive/diagnostics /api/archive/handovers /api/archive /api/diagnostics /api/cases/SUP-2841; do
  printf '%-52s ' "$p"
  ssh -o BatchMode=yes rowan-dev "curl -sS -m 10 $C -o /tmp/r -w '%{http_code} ' $B$p; head -c 150 /tmp/r" | tr '\n' ' '; echo
done
echo "=== POST route variants ==="
ssh -o BatchMode=yes rowan-dev "for body in '{\"diagnostic\":\"DIAG-CRR-MIXED-19\",\"reviewer\":\"talia.mornac-review\"}' '{\"handover\":\"DIAG-CRR-MIXED-19\",\"reviewer\":\"talia.mornac-review\",\"spn\":\"HTTP/staff.keplerops.test@KEPLEROPS.TEST\"}'; do printf '%s -> ' \"\$body\"; curl -sS -m 10 $C -X POST -H 'Content-Type: application/json' -d \"\$body\" -w ' [%{http_code}] ' $B/api/archive/delegation | head -c 300; echo; done"
