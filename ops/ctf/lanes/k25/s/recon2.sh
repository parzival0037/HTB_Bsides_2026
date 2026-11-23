set -x
curl -sS --socks5-hostname 127.0.0.1:1080 --cacert /tmp/k25-ca.crt -m 20 https://support.keplerops.test/scp/ -o /tmp/k25-scp.html -w 'scp:%{http_code}\n'
head -c 600 /tmp/k25-scp.html; echo
echo "=== sample of /tmp uuid artifacts ==="
ls /tmp/*.meta.json 2>/dev/null | head -3
cat $(ls /tmp/*.meta.json | head -2)
echo; head -c 800 $(ls /tmp/[0-9a-f]*-* 2>/dev/null | grep -v meta | head -1)
echo "=== ls /tmp non-uuid ==="
ls -la /tmp | grep -v '^-rw------- 1 cinder' | head -60
