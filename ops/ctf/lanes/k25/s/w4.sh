CA=$HOME/k25/ca.crt; P="--socks5-hostname 127.0.0.1:1080"
U="rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"
B=https://delivery.keplerops.test:8443
echo "=== well-known reconcile route"
curl -sS $P --cacert $CA -m 25 -u "$U" "$B/.well-known/fieldkest-client" -o /tmp/dw.json
python3 - <<'PY'
import json
d=json.load(open('/tmp/dw.json'))
for r in d.get('routes',[]):
    if 'reconcil' in r.get('key','')+r.get('template','') or 'integration' in r.get('key',''):
        print(json.dumps(r,indent=1))
print('TOP KEYS',list(d))
PY
echo "=== reconcile probes"
post(){ printf '%-110s ' "$1"; curl -sS $P --cacert $CA -m 25 -u "$U" -H 'Content-Type: application/json' -X POST "$B/api/reconcile/tenant-package" -d "$1" -w ' [%{http_code}]\n' | head -c 600; echo; }
post '{}'
post '{"tenant_id":"TEN-ARWC-047","connector_revision":"FLK-7.4.2"}'
post '{"tenant_id":"TEN-ARWC-047","connector_revision":"FLK-7.4.2","record_id":"CUSTREC-047-R6"}'
post '{"record_id":"CUSTREC-047-R6"}'
post '{"tenant_id":"TEN-ARWC-047","connector_revision":"FLK-7.4.2","asset":"CRR-OG2","case_ref":"SUP-2841"}'
post '{"record":{"record_id":"CUSTREC-047-R6","tenant":"TEN-ARWC-047","connector_revision":"FLK-7.4.2","asset":"CRR-OG2","case_ref":"SUP-2841"}}'
post '{"customer_record":{"record_id":"CUSTREC-047-R6","tenant":"TEN-ARWC-047","connector_revision":"FLK-7.4.2"}}'
post '{"tenant":"TEN-ARWC-047","package":"@keplerops/fieldlink-connector","version":"7.4.2","asset":"CRR-OG2","case":"SUP-2841"}'
post '{"request":{"tenant_id":"TEN-ARWC-047","connector_revision":"FLK-7.4.2"}}'
post '{"record_id":"CUSTREC-047-R6","tenant":"TEN-ARWC-047","revision":"FLK-7.4.2","asset":"CRR-OG2","case_ref":"SUP-2841"}'
echo "=== probe other delivery records"
probe(){ printf '%-52s ' "$1"; curl -sS $P --cacert $CA -m 20 -u "$U" -w ' [%{http_code}]\n' "$1" | head -c 500; echo; }
probe "$B/api/customer-records/CUSTREC-047-R6"
probe "$B/api/customers/TEN-ARWC-047"
probe "$B/api/reconcile"
probe "$B/api/reconcile/tenant-package?tenant=TEN-ARWC-047"
probe "$B/api/reconcile/tenant-package?tenant_id=TEN-ARWC-047&connector_revision=FLK-7.4.2"
