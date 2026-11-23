#!/bin/bash
set -x
id
ls -la /tmp/*.py /tmp/*.sh 2>/dev/null
cat /tmp/ca.crt 2>/dev/null | head -2
curl -sS --max-time 15 --socks5-hostname 127.0.0.1:1080 -k https://source.keplerops.test/ -o /dev/null -w 'SOURCE:%{http_code}\n'
curl -sS --max-time 15 --socks5-hostname 127.0.0.1:1080 -k https://connector.arwc.test/ -o /tmp/conn_root.txt -w 'CONNECTOR:%{http_code} size=%{size_download}\n'
head -c 800 /tmp/conn_root.txt
echo
curl -sS --max-time 15 --socks5-hostname 127.0.0.1:1080 -k https://assistant.keplerops.test/ -o /dev/null -w 'ASSIST:%{http_code}\n'
# DNS resolution through proxy to enumerate names
for h in connector.arwc.test api.arwc.test portal.arwc.test water.arwc.test reports.arwc.test data.keplerops.test; do
  echo -n "$h: "
  curl -sS --max-time 10 --socks5-hostname 127.0.0.1:1080 -k "https://$h/" -o /dev/null -w '%{http_code} %{remote_ip}\n' || echo fail
done
