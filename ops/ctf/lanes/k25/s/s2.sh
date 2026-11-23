CA=$HOME/k25/ca.crt
P="--socks5-hostname 127.0.0.1:1080"
U='rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo'
for repo in connector-archive fieldlink-connector policy-compiler release-signer-history; do
  echo "===== $repo"
  curl -sS $P --cacert $CA -m 25 -u "$U" "https://source.keplerops.test/api/v1/repos/fieldkest/$repo/git/trees/main?recursive=true&per_page=200" | jq -r '.tree[]? | "\(.type) \(.path) \(.sha[0:8])"' 2>&1 | head -60
done
