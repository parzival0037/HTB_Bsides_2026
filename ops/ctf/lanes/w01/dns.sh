#!/bin/bash
S="ssh -o StrictHostKeyChecking=no -o BatchMode=yes -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
$S 'cat > /tmp/dns.sh' <<'EOS'
#!/bin/bash
which dig nslookup host python3
for z in keplerops.test arwc.test; do
 echo "### AXFR $z @10.77.50.10"
 dig @10.77.50.10 +noall +answer +time=3 +tries=1 AXFR $z 2>&1 | head -40
 echo "### AXFR $z @127.0.0.11"
 dig @127.0.0.11 +noall +answer +time=3 +tries=1 AXFR $z 2>&1 | head -20
done
echo "### SOA"
dig @10.77.50.10 +short SOA keplerops.test 2>&1
dig @10.77.50.10 +short SOA arwc.test 2>&1
echo "### wildcard test"
for h in zzztest1.keplerops.test zzztest1.arwc.test; do echo "$h -> $(dig @10.77.50.10 +short A $h 2>&1)"; done
EOS
chmod +x /tmp/dns.sh
$S 'bash /tmp/dns.sh' 2>&1 | head -100
