#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
B=https://preview.keplerops.test
DEV="-u rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"
echo "===== GET docs/reviews with dev"
for u in /api/preview/documents /api/preview/reviews /api/preview/associations /api/preview/sources /api/preview/attachments; do
  echo "--- $u"; curl -sS $P -k -m 12 $DEV -w '\n[%{http_code}]\n' "$B$u" | head -c 600; echo
done
echo "===== association probes"
for s in ATT-DIAG-698 DOC-RILL-442 SEL-SUP-2841-12 DREV-2841-2 SUP-2841 CRR-OG2 TEN-ARWC-047 ARWC-2841 ATT-SUP-2841-1; do
  printf "%-22s " "$s"; curl -sS $P -k -m 10 $DEV -w ' [%{http_code}]\n' "$B/api/preview/association?source=$s" | head -c 300; echo
done
echo "===== attachment probes (headers)"
for s in ATT-DIAG-698 DOC-RILL-442 SUP-2841 1; do
  echo "--- $s"; curl -sS $P -k -m 10 $DEV -D - -o /tmp/at "$B/attachment/$s" | head -6; echo "size=$(stat -c%s /tmp/at)"; head -c 200 /tmp/at; echo
done
echo "===== POST documents variants (dev)"
for body in '{}' '{"source":"SUP-2841"}' '{"title":"x","content":"y"}' '{"source_id":"SUP-2841"}' '{"document_id":"DOC-RILL-442"}'; do
  echo "--- $body"; curl -sS $P -k -m 10 $DEV -X POST -H 'Content-Type: application/json' -d "$body" -w ' [%{http_code}]\n' "$B/api/preview/documents" | head -c 300; echo
done
