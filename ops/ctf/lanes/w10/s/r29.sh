#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080 -k -sS -m 10"
A=https://assistant.keplerops.test
C=https://connector.arwc.test
echo "===== assistant contexts variants"
for q in "" "?tenant_id=TEN-ARWC-047" "?tenant=TEN-ARWC-047" "?workspace=fieldlink-operations" "?published=true" "?all=true" "?include_hidden=true" "?context_id=ctx-report-v1"; do
  printf "%-45s " "$q"
  curl $P "$A/api/contexts$q" -o /tmp/a.$$ -w '%{http_code} %{size_download}' ; echo " :: $(head -c 200 /tmp/a.$$ | tr -d '\n')"
done
rm -f /tmp/a.$$
echo "===== assistant session-ish routes"
for p in /api/session /api/sessions /api/login /api/auth /api/auth/login /api/whoami /api/me /api/user /api/users /api/tenants /api/workspaces /api/v1/workspaces /api/documents /api/links /api/linked-documents /api/retrieval /api/search /api/query /api/answers/current /api/selections; do
  for m in GET POST; do
    printf "%-6s %-28s " "$m" "$p"
    curl $P -X $m -H 'Content-Type: application/json' -d '{}' "$A$p" -o /tmp/a.$$ -w '%{http_code} %{size_download}' 2>/dev/null; echo " :: $(head -c 160 /tmp/a.$$ | tr -d '\n')"
  done
done
rm -f /tmp/a.$$
echo "===== assistant known endpoints unauth status"
for p in /api/config /api/contexts /api/selections/SEL-SUP-2841-12 /api/conversations/CONV-SUP-2841-19 /api/contexts/ctx-support-private-v4/conversations/CONV-SUP-2841-19/documents/DOC-RILL-442 /api/completions/examples/COMP-JOB-17 /api/completions/context /api/completions/jobs /api/tools/accept-duplicate-review; do
  printf "%-90s " "$p"; curl $P "$A$p" -o /tmp/a.$$ -w '%{http_code} %{size_download}' 2>/dev/null; echo " :: $(head -c 140 /tmp/a.$$ | tr -d '\n')"
done
rm -f /tmp/a.$$
echo "===== keycloak discovery"
curl $P https://identity.keplerops.test/realms/keplerops/.well-known/openid-configuration -o /tmp/kc.$$ -w '%{http_code} %{size_download}\n'
head -c 800 /tmp/kc.$$; echo
rm -f /tmp/kc.$$
echo "===== connector route probes"
for p in /api/fieldlink /api/fieldlink/ /api/fieldlink/packages /api/fieldlink/reports /api/fieldlink/report /api/fieldlink/districts /api/fieldlink/planning /api/fieldlink/assistant /api/fieldlink/documents /api/fieldlink/retrieval /api/assistant /api/reports /api/report /api/districts /api/planning /api/documents /api/retrieval /api/selections /api/contexts /api/answers /report /reports /assistant /routes /_routes /api/routes; do
  for m in GET POST; do
    printf "%-6s %-28s " "$m" "$p"
    curl $P -X $m -H 'Content-Type: application/json' -d '{}' "$C$p" -o /tmp/c.$$ -w '%{http_code} %{size_download}' 2>/dev/null
    echo " :: $(head -c 160 /tmp/c.$$ | tr -d '\n')"
  done
done
rm -f /tmp/c.$$
