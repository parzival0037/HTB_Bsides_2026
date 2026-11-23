#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080 -k -sS -m 15"
U="rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"
J=https://ci.keplerops.test
g(){ echo; echo "##### $1"; shift; curl $P -u "$U" "$@" -o /tmp/j.$$ -w '%{http_code} %{size_download}\n'; head -c 3000 /tmp/j.$$; echo; }
g runner "$J/job/fieldlink-runner-operations/api/json"
g pkg "$J/job/fieldlink-package-check/api/json"
g rev1 "$J/job/fieldlink-report-review/1/api/json"
g rev1log "$J/job/fieldlink-report-review/1/consoleText"
echo "##### review service route probes"
R=https://review.keplerops.test
for p in / /api/jobs /api/jobs/1 /api/reviews /api/contexts /api/selections /api/documents /api/assistant /api/report /api/reports /api/sources /api/retrieval /api/planning /api/districts /api/review-jobs /api/runs /openapi.json /.well-known/fieldkest-client; do
  for m in GET POST; do
    code=$(curl $P -X $m -H 'Content-Type: application/json' -d '{}' "$R$p" -o /tmp/r.$$ -w '%{http_code}')
    echo "$m $p -> $code $(head -c 100 /tmp/r.$$ | tr -d '\n')"
  done
done
echo "##### preview service route probes"
V=https://preview.keplerops.test
for p in / /api/preview/association?source=DOC-RILL-442 /api/preview/documents /api/preview/association?source=ATT-DIAG-698 /api/preview/reviews/DREV-2841-2 /attachment/ATT-DIAG-698 /.well-known/fieldkest-client /openapi.json; do
  code=$(curl $P "$V$p" -o /tmp/p.$$ -w '%{http_code}')
  echo "GET $p -> $code $(head -c 200 /tmp/p.$$ | tr -d '\n')"
done
rm -f /tmp/j.$$ /tmp/r.$$ /tmp/p.$$
