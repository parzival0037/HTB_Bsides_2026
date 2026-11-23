CA=$HOME/k25/ca.crt; P="--socks5-hostname 127.0.0.1:1080"; B=https://delivery.keplerops.test:8443
g(){ echo "=== GET $1"; curl -sS $P --cacert $CA -m 20 -w '\n[%{http_code}]\n' "$B$1"; }
g /api/package-meta/fieldlink-connector
for r in REL-FLK-6.9.8-ARCHIVE REL-FLK-7.4.2 REL-FLK-7.4.2-09 REL-FLK-7.3.1 REL-FLK-7.4.2-ARCHIVE; do g "/api/releases/$r"; done
echo "=== POST reconcile empty"
curl -sS $P --cacert $CA -m 20 -X POST -H 'Content-Type: application/json' -d '{}' -w '\n[%{http_code}]\n' "$B/api/reconcile/tenant-package"
echo "=== POST reconcile arwc"
curl -sS $P --cacert $CA -m 20 -X POST -H 'Content-Type: application/json' -d '{"tenant":"TEN-ARWC-047","package":"@keplerops/fieldlink-connector","version":"7.4.2"}' -w '\n[%{http_code}]\n' "$B/api/reconcile/tenant-package"
