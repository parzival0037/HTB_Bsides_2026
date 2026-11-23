#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
B=https://preview.keplerops.test
DEV="-u rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"
SUP="-H Authorization:Bearer\ fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b"
echo "===== indexer doc"
curl -sS $P -k -m 15 "https://indexer.keplerops.test/.well-known/fieldkest-client" | python3 -m json.tool
echo "===== review doc tail"
curl -sS $P -k -m 15 "https://review.keplerops.test/.well-known/fieldkest-client" | python3 -m json.tool | tail -40
echo "===== preview probes (no auth)"
for u in "/api/preview/association" "/api/preview/association?source=1" "/api/preview/association?source=SUP-2841" "/api/preview/association?source=attachment:1" "/attachment/1" "/attachment/SUP-2841" "/api/preview/reviews/1" "/api/preview/release/1" "/api/preview/documents" "/api/preview/render"; do
  echo "--- GET $u"
  curl -sS $P -k -m 10 -w '\n[%{http_code}]\n' "$B$u" | head -c 400; echo
done
echo "===== preview with dev basic"
for u in "/api/preview/association?source=1" "/attachment/1"; do
  echo "--- GET $u"
  curl -sS $P -k -m 10 $DEV -w '\n[%{http_code}]\n' "$B$u" | head -c 400; echo
done
echo "===== support handover current"
curl -sS $P -k -m 15 -H 'Authorization: Bearer fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b' -w '\n[%{http_code}]\n' "https://support.keplerops.test:8443/api/handovers/current"
echo "===== POST preview documents empty/json"
curl -sS $P -k -m 10 -X POST -H 'Content-Type: application/json' -d '{}' -w '\n[%{http_code}]\n' "$B/api/preview/documents"
curl -sS $P -k -m 10 -X POST -H 'Content-Type: application/json' -d '{"source":"SUP-2841"}' -w '\n[%{http_code}]\n' "$B/api/preview/documents"
curl -sS $P -k -m 10 -X POST -H 'Content-Type: application/json' -d '{"document":"hello","format":"markdown"}' -w '\n[%{http_code}]\n' "$B/api/preview/render"
