CA=$HOME/k25/ca.crt; P="--socks5-hostname 127.0.0.1:1080"; D=https://delivery.keplerops.test:8443
U="rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"
p(){ printf '%-100s ' "$1"; curl -sS $P --cacert $CA -m 15 -u "$U" -H 'Content-Type: application/json' -d "$1" -w ' [%{http_code}]\n' "$D/api/reconcile/tenant-package"; }
p '{}'
p '{"tenant_id":"TEN-ARWC-019","version":"7.4.2"}'
p '{"tenant_id":"TEN-ARWC-019","connector_revision":"FLK-7.4.2"}'
p '{"tenant_id":"TEN-ARWC-047","connector_revision":"FLK-7.4.2"}'
p '{"customer_id":"TEN-ARWC-019","package_revision":"FLK-7.4.2"}'
p '{"tenant_id":"TEN-ARWC-019","package":"@keplerops/fieldlink-connector","version":"7.4.2"}'
p '{"tenant_id":"TEN-ARWC-019","selected_version":"7.4.2","package":"@keplerops/fieldlink-connector"}'
p '{"export_id":"EXP-2841","partition_id":"PART-ARWC-01","tenant_id":"TEN-ARWC-019","release":"FLK-7.4.2","revision":6}'
p '{"binding":{"export_id":"EXP-2841","tenant_id":"TEN-ARWC-019","partition_id":"PART-ARWC-01","release":"FLK-7.4.2","revision":6}}'
p '{"dossier":"SUP-2841","revision":4}'
echo "=== source-tools wellknown"
curl -sS $P --cacert $CA -m 15 -w '\n[%{http_code}]\n' https://source-tools.keplerops.test:8443/.well-known/fieldkest-client | head -c 2000
echo "=== gitea repos search"
for q in delivery reconcile registry support dossier integration tenant; do echo "--- q=$q"; curl -sS $P --cacert $CA -m 20 -u "$U" "https://source.keplerops.test/api/v1/repos/search?q=$q&limit=30&uid=0" | python3 -c "import json,sys
try: d=json.load(sys.stdin)
except: print('ERR'); raise SystemExit
for r in (d.get('data') or []): print(' ',r['full_name'],'|',r.get('description'))" 2>&1; done
