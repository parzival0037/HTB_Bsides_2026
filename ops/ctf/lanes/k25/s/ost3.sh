CA=$HOME/k25/ca.crt
P="--socks5-hostname 127.0.0.1:1080"
B=https://support.keplerops.test
echo "=== input fields"
grep -oE '<input[^>]*>' /tmp/k25-login.html | head
echo "=== headers of login page"
curl -sS $P --cacert $CA -m 25 -D - -o /dev/null "$B/scp/login.php" | head -20
