CA=$HOME/k25/ca.crt; P="--socks5-hostname 127.0.0.1:1080"
A="Authorization: Bearer fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b"
U="rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"
get(){ printf '%-70s ' "$1"; shift; curl -sS $P --cacert $CA -m 20 "$@" -w ' [%{http_code}]\n'; }
for j in JOB-BA11FC0CCB19 JOB-215D690E28A8 JOB-215D690E28A8; do
  get "support diag $j" -H "$A" "https://support.keplerops.test:8443/api/diagnostics/$j"
  get "review job $j" -u "$U" "https://review.keplerops.test/api/jobs/$j"
  get "review job basic sup $j" -H "$A" "https://review.keplerops.test/api/jobs/$j"
done
echo "=== handover with query"
get "handover current?include=attachments" -H "$A" "https://support.keplerops.test:8443/api/handovers/current?include=attachments"
get "handover current?view=dossier" -H "$A" "https://support.keplerops.test:8443/api/handovers/current?view=dossier"
