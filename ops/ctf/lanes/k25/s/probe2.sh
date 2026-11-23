CA=$HOME/k25/ca.crt; P="--socks5-hostname 127.0.0.1:1080"; D=https://delivery.keplerops.test:8443
U="rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"
echo "=== discovery"
for path in /openapi.json /api/openapi.json /api/docs /docs /api/routes /api/schema /api /api/ /robots.txt /api/reconcile /api/reconcile/tenant-package; do
  printf '%-34s ' "$path"; curl -sS $P --cacert $CA -m 10 -u "$U" -o /tmp/o -w '%{http_code} %{content_type} ' "$D$path"; head -c 200 /tmp/o; echo
done
echo "=== reconcile GET"
curl -sS $P --cacert $CA -m 10 -u "$U" -w ' [%{http_code}]\n' "$D/api/reconcile/tenant-package"
echo "=== reconcile query"
curl -sS $P --cacert $CA -m 10 -u "$U" -w ' [%{http_code}]\n' "$D/api/reconcile/tenant-package?tenant_id=TEN-ARWC-019&version=7.4.2"
echo "=== reconcile form"
curl -sS $P --cacert $CA -m 10 -u "$U" -d 'tenant_id=TEN-ARWC-019&version=7.4.2' -w ' [%{http_code}]\n' "$D/api/reconcile/tenant-package"
echo "=== reconcile minimal pairs"
for body in '{"tenant":"TEN-ARWC-019","package":"@keplerops/fieldlink-connector","version":"7.4.2"}' '{"tenant":"TEN-ARWC-047","package":"@keplerops/fieldlink-connector","version":"7.4.2"}' '{"tenant_id":"TEN-ARWC-019","release":"FLK-7.4.2"}' '{"tenant_id":"TEN-ARWC-019","release_id":"REL-FLK-7.4.2-09"}'; do
  printf '%-100s ' "$body"; curl -sS $P --cacert $CA -m 15 -u "$U" -H 'Content-Type: application/json' -d "$body" -w ' [%{http_code}]\n' "$D/api/reconcile/tenant-package"
done
