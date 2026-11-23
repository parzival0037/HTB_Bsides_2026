#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
for h in portal docs planning supply procurement inspection appointment appointments gate access checkin outlet water reports api cairn cairnreach app source data www intranet records register contracts suppliers handover; do
  for scheme in https http; do
    code=$(curl -sS $P -k --max-time 8 -o /tmp/h.$$ -w '%{http_code}' "$scheme://$h.arwc.test/" 2>/dev/null)
    if [ -n "$code" ] && [ "$code" != "000" ]; then
      echo "### $scheme://$h.arwc.test -> $code"
      head -c 300 /tmp/h.$$; echo
    fi
  done
done
rm -f /tmp/h.$$
echo "### DNS via proxy (curl -v resolve error test)"
for h in portal.arwc.test docs.arwc.test planning.arwc.test connector.arwc.test; do
  echo "$h: $(timeout 8 curl -sS $P -k -o /dev/null -w '%{http_code}' https://$h/ 2>&1 | head -2)"
done
