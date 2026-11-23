set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'RSH'
set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
for id in 1 2 3 4 5; do
echo "########## TICKET $id ##########"
curl -sS -m 10 --cacert $CA -b /tmp/ck "https://support.keplerops.test/scp/tickets.php?id=$id" | python3 -c "
import sys,re,html
t=sys.stdin.read()
t=re.sub(r'(?is)<script.*?</script>','',t)
t=re.sub(r'(?is)<style.*?</style>','',t)
t=re.sub(r'(?s)<[^>]+>','\n',t)
t=html.unescape(t)
lines=[l.strip() for l in t.splitlines() if l.strip()]
print('\n'.join(lines))
"
done
RSH
