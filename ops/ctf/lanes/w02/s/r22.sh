C="curl -sS --socks5-hostname 127.0.0.1:1080 -k --max-time 20"
for u in http://10.77.40.20:8080/ http://10.77.40.20:8081/ http://10.77.40.20:8082/ http://10.77.40.20:8083/; do echo "##### $u"; $C -i "$u" | head -c 2000; echo; done
