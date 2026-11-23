#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080 -k -sS -m 12"
A=https://assistant.keplerops.test
SUP=fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b
echo "===== DNS candidates on rowan-dev"
SSH="ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 -i $HOME/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
$SSH 'for h in report reports report-assistant reportassistant reports-assistant district districts planning planner plans data data-api linked linked-docs documents docs docstore retrieval retrieve search assistant assistant-report assistant-reports arwc-report arwc-reports arwc assistant.arwc report.arwc reports.arwc planning.arwc districts.arwc linked.arwc docs.arwc; do for d in keplerops.test arwc.test; do n="$h.$d"; case "$h" in *."$d") n="$h";; esac; r=$(getent hosts "$n" | head -1 | awk "{print \$1}"); echo "$n -> ${r:-NODNS}"; done; done' 2>&1 | grep -v NODNS
echo "===== OPTIONS fuzz overlays on assistant"
paths="report reports report-assistant report_assistant assistant assistants district districts planning plans plan source-sources source-selection source_selections selections selection sources source retrieval retrieve search query queries answer answers contexts context conversations conversation documents document linked-documents links link completion completions examples jobs tools tools/accept-duplicate-review api/answers api/selections api/contexts api/reports api/districts api/planning api/sources api/retrieval api/search api/documents api/linked-documents api/report-assistant api/source-selection reports/current reports/districts districts/current planning/current"
for p in $paths; do
  code=$(curl $P -o /tmp/o.$$ -w '%{http_code}' -X OPTIONS -H "Cookie: fieldkest_support=$SUP" "$A/api/$p")
  if [ "$code" != "404" ] && [ "$code" != "200" ]; then echo "OPT $code /api/$p :: $(head -c 120 /tmp/o.$$ | tr -d '\n')"; fi
done
rm -f /tmp/o.$$
echo "===== Host header overlay fuzz on 10.77.50.11 (OPTIONS / expects 501 for custom app)"
for h in report reports report-assistant district districts planning planner data linked documents docs docstore retrieval search assistant source sources arwc arwc-reports assistant-report; do
  for d in keplerops.test arwc.test; do
    n="$h.$d"
    out=$(curl $P -o /tmp/h.$$ -w '%{http_code}' -X OPTIONS --resolve "$n:443:10.77.50.11" "https://$n/")
    b=$(head -c 80 /tmp/h.$$ | tr -d '\n')
    echo "$n -> $out :: $b"
  done
done
rm -f /tmp/h.$$
