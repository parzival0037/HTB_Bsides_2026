#!/bin/bash
cat > /tmp/pc.conf <<'EOF'
strict_chain
proxy_dns
tcp_read_time_out 15000
tcp_connect_time_out 8000
[ProxyList]
socks5 127.0.0.1 1080
EOF
export PROXYCHAINS_CONF_FILE=/tmp/pc.conf
echo "== SANs 10.77.51.60 =="
timeout 30 proxychains4 -f /tmp/pc.conf openssl s_client -connect 10.77.51.60:443 -servername keplerops.test </dev/null 2>/dev/null | openssl x509 -noout -text 2>/dev/null | grep -A3 'Subject Alternative'
echo "== SANs 10.77.50.11 =="
timeout 30 proxychains4 -f /tmp/pc.conf openssl s_client -connect 10.77.50.11:443 -servername keplerops.test </dev/null 2>/dev/null | openssl x509 -noout -text 2>/dev/null | grep -A8 'Subject Alternative'
echo "== SANs 10.77.60.20 =="
timeout 30 proxychains4 -f /tmp/pc.conf openssl s_client -connect 10.77.60.20:443 -servername connector.arwc.test </dev/null 2>/dev/null | openssl x509 -noout -text 2>/dev/null | grep -A8 'Subject Alternative'
echo "== nmap 10.77.51.60 =="
timeout 280 proxychains4 -q -f /tmp/pc.conf nmap -sT -Pn -n -p- --min-rate 300 --max-retries 1 10.77.51.60 2>/dev/null | tail -30
echo "== nmap 10.77.60.20 =="
timeout 280 proxychains4 -q -f /tmp/pc.conf nmap -sT -Pn -n -p- --min-rate 300 --max-retries 1 10.77.60.20 2>/dev/null | tail -30
