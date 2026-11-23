#!/bin/bash
export ALL_PROXY=socks5h://127.0.0.1:1080
export GIT_SSL_NO_VERIFY=true
U='rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo'
cd /tmp && rm -rf g_* 2>/dev/null
for r in fieldlink-connector connector-archive release-signer-history policy-compiler; do
  timeout 60 git clone -q "https://$U@source.keplerops.test/fieldkest/$r.git" "g_$r" 2>&1 | tail -2
  echo "== $r: $(ls g_$r 2>/dev/null | tr '\n' ' ')"
done
echo "########## grep token/integration/relay"
grep -rniI 'integration\|token\|relay\|appointment\|gate\|checkin\|contractor\|cinder\|roster' /tmp/g_* --include='*' -l 2>/dev/null | head -40
echo "########## connector docs"
for f in /tmp/g_fieldlink-connector/README.md /tmp/g_fieldlink-connector/docs/report-provider.md /tmp/g_fieldlink-connector/review/FLK-7.4.2.md /tmp/g_fieldlink-connector/tests/test_crr_og2_report.py; do echo "###### $f"; cat "$f" 2>/dev/null | head -100; done
