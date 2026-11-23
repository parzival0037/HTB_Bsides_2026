#!/bin/bash
S="ssh -o StrictHostKeyChecking=no -o BatchMode=yes -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
$S 'cat > /tmp/vh.sh' <<'EOS'
#!/bin/bash
hosts="portal.arwc.test docs.arwc.test records.arwc.test arwc.test www.arwc.test app.arwc.test fieldlink.arwc.test fieldkest.arwc.test customer.arwc.test customers.arwc.test supplier.arwc.test suppliers.arwc.test planning.arwc.test procurement.arwc.test purchasing.arwc.test inspections.arwc.test maintenance.arwc.test cairnreach.arwc.test cairn.arwc.test water.arwc.test arwc.keplerops.test portal.keplerops.test docs.keplerops.test records.keplerops.test arwc.internal portal.internal"
for h in $hosts; do
  for ip_port in 10.77.50.11:443 10.77.50.11:8443; do
    ip=${ip_port%:*}; port=${ip_port#*:}
    out=$(curl -sS -k --max-time 8 --resolve "$h:$port:$ip" -o /tmp/vh.out -w '%{http_code} %{size_download}' "https://$h:$port/" 2>&1)
    echo "$h $ip_port -> $out"
    if [ "$(echo $out | cut -d' ' -f1)" != "404" ] && [ "$(echo $out | cut -d' ' -f1)" != "000" ]; then
      head -c 300 /tmp/vh.out | tr -d '\n'; echo
    fi
  done
done
EOS
chmod +x /tmp/vh.sh
$S 'bash /tmp/vh.sh' 2>&1 | head -120
