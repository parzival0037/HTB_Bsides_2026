#!/bin/bash
# mk.sh <lane> <card-prefix> <extra guidance>
L=$1; CARD=$2; EXTRA=$3
D=/home/kali/ctf/lanes/micro/$L
mkdir -p "$D/sessions"
{
cat <<HDR
Solve exactly ONE card: $CARD. Do not work anything else. Time budget ~10 minutes.

ACCESS (already proven — do not re-derive):
- Run everything from the range box: /home/kali/ctf/box.py -f script.sh  (or 'box.py "cmd"')
- SOCKS pivot on the box: curl -sS --socks5-hostname 127.0.0.1:1080 -k https://HOST/...
- Support client bearer: fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b
- Working ARWC ingress (NOT connector.arwc.test, that 403s):
    https://delivery.keplerops.test:8443/api/package-meta/fieldlink-connector
    https://support.keplerops.test:8443/api/handovers/current
    https://support.keplerops.test:8443/api/customers/{tenant}/diagnostics
    https://support.keplerops.test:8443/api/diagnostics/{job}[/package|/deliver]
    https://cloud-api.keplerops.test/api/workspaces/current/token-exchange
- Gitea: source.keplerops.test  rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo
- Tenants: TEN-ARWC-047 (CRR-OG2), TEN-RILL-022 (RILL-PUMP-442)
- Full map: /home/kali/ctf/lanes/ARWC-FINDINGS.md and /home/kali/ctf/lanes/NETMAP.md

RULES: no hints (points), no guessing — submit only a flag you have literally read out of a
response. Submit with /home/kali/ctf/submit.py '$CARD' 'FLAG{...}'.
$EXTRA
HDR
echo
/home/kali/ctf/brief.py "^$CARD" 2>/dev/null | head -8
} > "$D/BRIEF.md"
( cd "$D" && setsid nohup pi -p "$(cat BRIEF.md)" --session-dir "$D/sessions" --no-extensions > run.log 2>&1 < /dev/null & )
echo "$(date +%H:%M:%S) micro $L -> $CARD"
