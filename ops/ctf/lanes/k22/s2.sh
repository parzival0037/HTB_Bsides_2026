set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
T="fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b"
B=https://support.keplerops.test:8443
pr(){ p="$1"; m="${2:-GET}"; echo "### $m $p"; curl -sS -m 10 --cacert $CA -H "Authorization: Bearer $T" -H 'Accept: application/json' -X "$m" -o /tmp/o.txt -w '%{http_code} %{content_type} %{size_download}\n' "$B$p"; head -c 2500 /tmp/o.txt; echo; echo; }
pr /.well-known/fieldkest-client
pr /
pr /health
pr /api
pr /api/tickets
pr /api/support/tickets
pr /api/support
pr /api/reviews
pr /api/reviews/REV-2841
pr /api/tickets/SUP-2841
pr /api/assistant
pr /api/assistant/chat POST
pr /api/chat POST
pr /api/conversations
pr /openapi.json
pr /api/docs
echo "===== staff workboard ====="
W=https://staff.keplerops.test
for p in / /api /api/reviews /api/reviews/REV-2841 /health; do echo "### $p"; curl -sS -m 10 --cacert $CA -H "Authorization: Bearer $T" -o /tmp/o.txt -w '%{http_code} %{content_type} %{size_download}\n' "$W$p"; head -c 800 /tmp/o.txt; echo; done
INNER
