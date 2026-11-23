#!/bin/bash
R() { ssh -o StrictHostKeyChecking=no -o ConnectTimeout=8 -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180 "$@"; }
G='-u rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo'
PX='--socks5-hostname 127.0.0.1:1080 -k -m 20'
for f in README.md docs/report-provider.md review/FLK-7.4.2.md tests/test_crr_og2_report.py; do
 echo "##### $f"
 curl -sS $PX $G "https://source.keplerops.test/api/v1/repos/fieldkest/fieldlink-connector/raw/$f" | head -60
done
echo "##### archive README"
curl -sS $PX $G "https://source.keplerops.test/api/v1/repos/fieldkest/connector-archive/raw/README.md"
echo "##### service-notes"
R 'cat ~/work/service-notes.md'
echo "##### platform-access"
R 'cat ~/work/platform-access.md'
echo "##### identity-access"
R 'cat ~/work/identity-access.md'
echo "##### grep fs for arwc/supply/district"
R 'grep -ril "arwc\|supply\|district\|procurement" ~/work ~/repos ~/k05arch ~/results 2>/dev/null | head -40'
