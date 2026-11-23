CA=$HOME/k25/ca.crt; P="--socks5-hostname 127.0.0.1:1080"; B=https://support.keplerops.test; CK=/tmp/k25-ck.txt
command -v pdftotext >/dev/null || sudo -n apt-get install -y poppler-utils >/dev/null 2>&1
rm -f $CK
curl -sS $P --cacert $CA -m 25 -c $CK -o /tmp/l.html "$B/scp/login.php"
TOK=$(grep -oE 'name="__CSRFToken__" value="[^"]+"' /tmp/l.html | head -1 | sed 's/.*value="//;s/"//')
curl -sS $P --cacert $CA -m 25 -c $CK -b $CK -o /dev/null -w 'login:%{http_code}\n' \
  --data-urlencode "__CSRFToken__=$TOK" --data-urlencode "do=scplogin" \
  --data-urlencode "userid=maya.ranscombe" \
  --data-urlencode "passwd=sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk" \
  --data-urlencode "dst=$B/scp/tickets.php" "$B/scp/login.php"
curl -sS $P --cacert $CA -m 60 -b $CK -o /tmp/t1.zip -w 'zip:%{http_code} size:%{size_download}\n' "$B/scp/tickets.php?id=1&a=zip"
rm -rf /tmp/t1z; mkdir -p /tmp/t1z; cd /tmp/t1z; unzip -o -q /tmp/t1.zip
echo "=== files"; ls -la /tmp/t1z
echo "=== pdftotext"; pdftotext -layout /tmp/t1z/*.pdf - 2>&1 | head -120
echo "=== grep dossier/attach in pdf text"; pdftotext /tmp/t1z/*.pdf - 2>/dev/null | grep -inE "dossier|attach|DOS-|ENT-|FLAG" | head -20
