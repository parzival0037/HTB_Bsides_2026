set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
CA=/home/rowan/.local/share/keplerops/ca.crt
$S 'bash -s' <<'RSH'
set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
rm -f /tmp/ck
TOK=$(curl -sS -m 10 --cacert $CA -c /tmp/ck 'https://support.keplerops.test/scp/login.php' | grep -oP '__CSRFToken__" value="\K[^"]+')
echo "TOK=$TOK"
curl -sS -m 10 -i --cacert $CA -b /tmp/ck -c /tmp/ck -d "__CSRFToken__=$TOK&do=scplogin&userid=maya.ranscombe&passwd=sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk&submit=Sign+In" 'https://support.keplerops.test/scp/login.php' | head -20
echo "---TICKETS---"
curl -sS -m 10 --cacert $CA -b /tmp/ck 'https://support.keplerops.test/scp/tickets.php' | grep -oiE '<title>[^<]*|SUP-[0-9]+|tickets.php\?id=[0-9]+|error[^<]{0,80}' | head -40
echo "---SEARCH---"
curl -sS -m 10 --cacert $CA -b /tmp/ck --get --data-urlencode 'a=search' --data-urlencode 'keywords=SUP-2841' 'https://support.keplerops.test/scp/tickets.php' | grep -oiE 'tickets.php\?id=[0-9]+|SUP-[0-9]+|<title>[^<]*' | head -20
RSH
