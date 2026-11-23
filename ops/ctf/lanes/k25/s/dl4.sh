CA=$HOME/k25/ca.crt; P="--socks5-hostname 127.0.0.1:1080"; B=https://delivery.keplerops.test:8443
U="rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"
g(){ echo "=== GET $1"; curl -sS $P --cacert $CA -m 20 -u "$U" -w '\n[%{http_code}]\n' "$B$1"; }
g /api/releases/REL-FLK-7.4.2
for r in REL-FLK-7.4.0 REL-FLK-7.4.1 REL-FLK-7.3.1 REL-FLK-7.4.3-cinder.rset1 REL-FLK-7.4.2-09 REL-FLK-7.4.2-11; do g "/api/releases/$r"; done
for e in ENT-ARWC-DIAG-0698 ENT-ARWC-DIAG-698 ENT-DIAG-698; do g "/api/compatibility/entitlements/$e"; done
echo "=== reconcile probes"
p(){ echo "--- $1"; curl -sS $P --cacert $CA -m 20 -u "$U" -H 'Content-Type: application/json' -d "$1" -w '\n[%{http_code}]\n' "$B/api/reconcile/tenant-package"; }
p '{}'
p '{"tenant":"TEN-ARWC-019","version":"6.9.8"}'
p '{"tenant":"TEN-ARWC-019","version":"7.4.2"}'
p '{"tenant":"TEN-ARWC-047","version":"6.9.8"}'
p '{"tenant_id":"TEN-ARWC-019","version":"6.9.8"}'
p '{"tenant":"TEN-ARWC-019","connector_revision":"FLK-6.9.8"}'
p '{"tenant":"TEN-ARWC-019","version":"6.9.8","release_id":"REL-FLK-6.9.8-ARCHIVE"}'
