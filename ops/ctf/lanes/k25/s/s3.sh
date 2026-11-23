CA=$HOME/k25/ca.crt
P="--socks5-hostname 127.0.0.1:1080"
U='rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo'
get() { curl -sS $P --cacert $CA -m 25 -u "$U" "https://source.keplerops.test/api/v1/repos/fieldkest/$1/contents/$2?ref=main" | jq -r '.content' | base64 -d; }
for f in README.md config/diagnostic.conf config/ordinary.conf notes/retained-diagnostic.md internal/fieldlink/legacy-diagnostics/CRR-OG2/ENG-FLK-LEGACY-42.md internal/fieldlink/legacy-diagnostics/CRR-OG2/ENT-ARWC-DIAG-0698.json; do
  echo "########## connector-archive:$f"
  get connector-archive "$f"
  echo
done
echo "########## fieldlink-connector README.md"
get fieldlink-connector README.md
echo
echo "########## fieldlink-connector review/FLK-7.4.2.md"
get fieldlink-connector review/FLK-7.4.2.md
