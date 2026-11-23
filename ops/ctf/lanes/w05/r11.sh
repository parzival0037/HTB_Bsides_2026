#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
echo "###### id/identity well-known"
for h in id.keplerops.test identity.keplerops.test; do echo "=== $h"; curl -sS $P -k -m 12 https://$h/.well-known/fieldkest-client | head -c 2000; echo; done
echo "###### staff auth tests"
U=https://staff.keplerops.test/api/service-directory
for a in "" "-H 'Authorization: Bearer fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo'" ; do :; done
t(){ echo "--- $1"; shift; eval curl -sS $P -k -m 12 -i "$@" "$U" | head -c 400; echo; }
t none
t bearer-dev -H '"Authorization: Bearer fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"'
t basic-maya -u 'maya.ranscombe:sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk'
t basic-rowan -u 'rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo'
echo "###### kanboard"
C="curl -sS $P -k -m 20 -c /tmp/kbc -b /tmp/kbc"
rm -f /tmp/kbc
$C -o /tmp/kbl -w 'root:%{http_code}\n' https://workboard.keplerops.test/
head -c 600 /tmp/kbl; echo
CSRF=$(grep -oP 'name="csrf_token" value="\K[^"]+' /tmp/kbl | head -1); echo "csrf=$CSRF"
$C -o /tmp/kbl2 -w 'login:%{http_code}\n' -L -d "username=maya.ranscombe&password=sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk&csrf_token=$CSRF" "https://workboard.keplerops.test/?controller=AuthController&action=check"
$C -o /tmp/kbd -w 'dash:%{http_code}\n' "https://workboard.keplerops.test/?controller=DashboardController&action=show"
grep -oiE 'href="[^"]{3,80}"' /tmp/kbd | sort -u | head -40
$C -o /tmp/kbp -w 'proj:%{http_code}\n' "https://workboard.keplerops.test/?controller=ProjectController&action=index"
python3 - <<'PY'
import re,html
s=open('/tmp/kbp',errors='replace').read()
print(re.sub(r'<[^>]+>',' ',s)[:1500])
PY
