CA=$HOME/k25/ca.crt; P="--socks5-hostname 127.0.0.1:1080"; B=https://support.keplerops.test:8443
A="Authorization: Bearer fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b"
get(){ printf '%-46s ' "$1"; curl -sS $P --cacert $CA -m 20 -H "$A" -w ' [%{http_code}]\n' "$B$1"; }
for j in DIAG-CRR-MIXED-19 DIAG-CRR-MIXED-1 DIAG-CRR-OG2-19 DIAG-ARWC-0214CB78 DIAG-ARWC-B608C281 DIAG-SUP-2841-19 DIAG-2841; do get "/api/diagnostics/$j"; done
echo "=== handovers"
for h in current SUP-2841 SUP-K-2841 CRR-OG2 TEN-ARWC-019 TEN-ARWC-047 HND-FLK-2026-09; do get "/api/handovers/$h"; done
echo "=== customer dossier variants"
for c in TEN-ARWC-047 TEN-ARWC-019; do get "/api/customers/$c/dossier"; get "/api/customers/$c/integrations"; get "/api/customers/$c/records"; done
