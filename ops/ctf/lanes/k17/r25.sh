set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'INNER'
CA=/home/rowan/.local/share/keplerops/ca.crt
try(){ H=$1; U=$2; P=$3; J=/tmp/lj_$RANDOM.txt; rm -f $J
  curl -sS -m 8 --cacert $CA -c $J "https://$H.keplerops.test/login" -o /tmp/lg.html
  C=$(grep -oE 'name="csrf_token" value="[^"]+"' /tmp/lg.html | sed -E 's/.*value="([^"]+)".*/\1/')
  out=$(curl -sS -m 8 --cacert $CA -b $J -c $J -i -X POST "https://$H.keplerops.test/login/check" \
    --data-urlencode "csrf_token=$C" --data-urlencode "username=$U" --data-urlencode "password=$P" \
    --data-urlencode "remember_me=1" -o /tmp/lr.txt; head -1 /tmp/lr.txt)
  loc=$(grep -i '^location:' /tmp/lr.txt | tr -d '\r' | awk '{print $2}')
  body=$(tr -d '\n' < /tmp/lr.txt | grep -oE '(Invalid|incorrect|locked|error|denied)[^<"]{0,60}' | head -1)
  echo "H=$H U=$U P=${P:0:12}... -> $out LOC=$loc ERR=$body"
}
for H in staff workboard; do
 try $H rowan.ito fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo
 try $H rowan.ito fieldlink-dev-2841
 try $H maya.ranscombe sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk
 try $H talia.mornac K17r3v13wTalia2841
 try $H cinder cinder
done
echo "=== staff root/index with no auth ==="
curl -sS -m 8 --cacert $CA -i https://staff.keplerops.test/index.php 2>&1 | head -12
INNER
