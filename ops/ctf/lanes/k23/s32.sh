#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"; K="-k -sS -m 30"; H="https://assistant.keplerops.test"
A(){ echo "===== $1"; curl $K $P -L "$H$1" -w "\n[%{http_code}]\n" | head -c 4000; echo; }
A /api/conversations/CONV-SUP-2841-19
A /api/conversations/CONV-RILL-442-8
A /api/selections/SEL-SUP-2841-12
A /api/contexts/ctx-support-private-v4/conversations/CONV-SUP-2841-19/documents/DOC-RILL-442
A /api/contexts/ctx-rill-support-v3/conversations/CONV-RILL-442-8/documents/DOC-RILL-442
A /api/completions/examples/COMP-JOB-17
A /api/selections/SEL-OTHER
