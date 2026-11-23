CA=$HOME/k25/ca.crt; P="--socks5-hostname 127.0.0.1:1080"
U="rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"
A="Authorization: Bearer fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b"
echo "=========== DELIVERY WELLKNOWN"
curl -sS $P --cacert $CA -m 25 -u "$U" "https://delivery.keplerops.test:8443/.well-known/fieldkest-client" | python3 -c "import json,sys;d=json.load(sys.stdin);print(json.dumps(d,indent=0))" 2>&1 | head -80
echo "=========== SUPPORT DOSSIER PROBES"
B=https://support.keplerops.test:8443
probe(){ printf '%-58s ' "$1"; shift; curl -sS $P --cacert $CA -m 20 -H "$A" -w ' [%{http_code}]\n' "$@" | head -c 900; echo; }
probe "/api/customers" "$B/api/customers"
for t in TEN-ARWC-047 TEN-ARWC-019; do
 probe "GET /api/customers/$t" "$B/api/customers/$t"
 probe "GET /api/customers/$t/dossier" "$B/api/customers/$t/dossier"
 probe "GET /api/customers/$t/records" "$B/api/customers/$t/records"
 probe "GET /api/customers/$t/integrations" "$B/api/customers/$t/integrations"
 probe "GET /api/customers/$t/history" "$B/api/customers/$t/history"
 probe "GET /api/customers/$t/attachment" "$B/api/customers/$t/attachment"
done
probe "GET /api/integrations" "$B/api/integrations"
probe "GET /api/dossiers" "$B/api/dossiers"
probe "GET /api/records" "$B/api/records"
probe "GET /api/handovers" "$B/api/handovers"
probe "GET /api/diagnostics" "$B/api/diagnostics"
probe "GET /api/customers/TEN-ARWC-047/diagnostics" "$B/api/customers/TEN-ARWC-047/diagnostics"
