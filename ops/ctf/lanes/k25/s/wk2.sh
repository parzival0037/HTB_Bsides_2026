CA=$HOME/k25/ca.crt; P="--socks5-hostname 127.0.0.1:1080"
if [ ! -f $CA ]; then echo "NO CA"; fi
for url in https://support.keplerops.test/.well-known/fieldkest-client https://support.keplerops.test:8443/.well-known/fieldkest-client; do
  echo "########## $url"
  curl -sS $P --cacert $CA -m 20 -w '\n[HTTP:%{http_code}]\n' "$url" | tee -a /tmp/wk.txt
done
