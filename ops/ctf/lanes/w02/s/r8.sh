SSH="ssh -o StrictHostKeyChecking=no -o BatchMode=yes -i $HOME/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
$SSH 'bash -s' <<'REMOTE'
echo "### hosts"; cat /etc/hosts; echo "### resolv"; cat /etc/resolv.conf
echo "### arwc names"
getent hosts connector.arwc.test
for n in dispatch field fieldlink work orders supplier contractor inspection portal app api; do printf "%s.arwc.test " $n; getent hosts $n.arwc.test || echo "-"; done
echo "### dig any"
which dig nslookup
REMOTE
