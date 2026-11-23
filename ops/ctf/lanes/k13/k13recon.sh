set +e
E=https://objects.keplerops.test
C="curl -sSk -m 15 --socks5-hostname 127.0.0.1:1080"
echo "== buckets =="
$C "$E/" | head -c 1500; echo
echo "== list workspaces =="
$C "$E/fieldkest-workspaces?list-type=2" | head -c 4000; echo
echo "== versions =="
$C "$E/fieldkest-workspaces?versions" | head -c 6000; echo
