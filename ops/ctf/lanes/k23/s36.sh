#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"; K="-k -sS"; H="https://assistant.keplerops.test"
C="Cookie: fieldkest_support=fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b"
for u in \
 "/api/contexts/ctx-support-private-v4/conversations/CONV-SUP-2841-19/documents/DOC-RILL-442" \
 "/api/contexts/ctx-rill-support-v3/conversations/CONV-RILL-442-8/documents/DOC-RILL-442" ; do
 echo "===== $u"
 curl $P $K -H "$C" -D /tmp/h.txt "$H$u" --max-time 150 -o /tmp/d.json -w "http=%{http_code} size=%{size_download} time=%{time_total}\n"
 cat /tmp/h.txt | head -20
 head -c 3000 /tmp/d.json; echo
done
