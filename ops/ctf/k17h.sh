set +e
R=/home/rowan/.local/share/keplerops/ca.crt
C="--cacert $R --cert /tmp/evan.calderoux.crt --key /tmp/evan.calderoux.key"
export KRB5CCNAME=FILE:/tmp/evan.ccache
B=https://staff.keplerops.test
for p in /api/archive/handovers/DIAG-CRR-MIXED-19 /api/archive/handovers/evan.calderoux@keplerops.test /api/archive/reviews /api/reviews /api/archive/routes; do
  printf '%-54s ' "$p"
  ssh -o BatchMode=yes rowan-dev "KRB5CCNAME=FILE:/tmp/evan.ccache curl -sS -m 10 --negotiate -u : $C -o /tmp/r -w '%{http_code} ' $B$p; head -c 200 /tmp/r" | tr '\n' ' '; echo
done
echo "=== negotiate on the diagnostic handover with cert too ==="
ssh -o BatchMode=yes rowan-dev "KRB5CCNAME=FILE:/tmp/evan.ccache curl -sS -m 10 --negotiate -u : --cacert $R --cert /tmp/maya.ranscombe.crt --key /tmp/maya.ranscombe.key -w ' [%{http_code}]\n' $B/api/archive/handovers/DIAG-CRR-MIXED-19 | head -c 500"
