set +e
B64=aW1wb3J0IHNvY2tldCwgY29uY3VycmVudC5mdXR1cmVzCgpQT1JUUyA9IFsyMiwgODAsIDQ0MywgMzAwMCwgNDg0MCwgNTQzMiwgODA4MCwgODA4MSwgODA4MiwgODA4MywgODQ0MywgODcwMSwgOTA5MCwgNjQ0M10KCgpkZWYgcHJvYmUoaHApOgogICAgaCwgcCA9IGhwCiAgICBzID0gc29ja2V0LnNvY2tldCgpCiAgICBzLnNldHRpbWVvdXQoMC40KQogICAgdHJ5OgogICAgICAgIGlmIHMuY29ubmVjdF9leCgoaCwgcCkpID09IDA6CiAgICAgICAgICAgIHJldHVybiAoaCwgcCkKICAgIGV4Y2VwdCBFeGNlcHRpb246CiAgICAgICAgcGFzcwogICAgZmluYWxseToKICAgICAgICBzLmNsb3NlKCkKICAgIHJldHVybiBOb25lCgoKaG9zdHMgPSAoW2YiMTAuNzcuNTAue2l9IiBmb3IgaSBpbiByYW5nZSgxMCwgNDUpXQogICAgICAgICArIFtmIjEwLjc3LjUxLntpfSIgZm9yIGkgaW4gcmFuZ2UoMTAsIDgwKV0KICAgICAgICAgKyBbZiIxMC43Ny42MC57aX0iIGZvciBpIGluIHJhbmdlKDEsIDMwKV0KICAgICAgICAgKyBbZiIxMC41MC4xMy57aX0iIGZvciBpIGluIHJhbmdlKDE3NSwgMTg1KV0pCnJlcyA9IHt9CndpdGggY29uY3VycmVudC5mdXR1cmVzLlRocmVhZFBvb2xFeGVjdXRvcigyMDApIGFzIGV4OgogICAgZm9yIHIgaW4gZXgubWFwKHByb2JlLCBbKGgsIHApIGZvciBoIGluIGhvc3RzIGZvciBwIGluIFBPUlRTXSk6CiAgICAgICAgaWYgcjoKICAgICAgICAgICAgcmVzLnNldGRlZmF1bHQoclswXSwgW10pLmFwcGVuZChyWzFdKQpmb3IgaCBpbiBzb3J0ZWQocmVzKToKICAgIHByaW50KGgsIHNvcnRlZChyZXNbaF0pLCBmbHVzaD1UcnVlKQo=
echo "$B64" | base64 -d > /tmp/topoX.py
ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev 'cat > ~/topoX.py' < /tmp/topoX.py
echo "=== scan via rowan-dev ==="
ssh -o BatchMode=yes rowan-dev 'timeout 80 python3 ~/topoX.py'
echo "=== /etc/hosts (rowan-dev) ==="
ssh -o BatchMode=yes rowan-dev 'grep -v localhost /etc/hosts'
echo "=== listening (rowan-dev) ==="
ssh -o BatchMode=yes rowan-dev 'ss -ltn | tail -n +2 | awk {print\ $4} | sort -u'
