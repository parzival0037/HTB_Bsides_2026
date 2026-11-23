set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
set +e
cd /tmp/gt 2>/dev/null || { mkdir -p /tmp/gt; cd /tmp/gt; }
for r in connector-archive fieldlink-connector; do
  [ -d $r ] || git clone -q "https://rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo@source.keplerops.test/fieldkest/$r.git" $r
done
echo "===== connector-archive README ====="; cat connector-archive/README.md
echo "===== connector-archive notes ====="; cat connector-archive/notes/retained-diagnostic.md
echo "===== ENG-FLK-LEGACY-42 ====="; cat connector-archive/internal/fieldlink/legacy-diagnostics/CRR-OG2/ENG-FLK-LEGACY-42.md
echo "===== ENT-ARWC-DIAG-0698 ====="; cat connector-archive/internal/fieldlink/legacy-diagnostics/CRR-OG2/ENT-ARWC-DIAG-0698.json
echo "===== fieldlink-connector README ====="; cat fieldlink-connector/README.md
echo "===== report-provider ====="; cat fieldlink-connector/docs/report-provider.md
echo "===== review FLK-7.4.2 ====="; cat fieldlink-connector/review/FLK-7.4.2.md
echo "===== fixture report ====="; sed -n '1,80p' fieldlink-connector/fixtures/report-crr-og2.json 2>/dev/null
INNER
echo DONE_R48
