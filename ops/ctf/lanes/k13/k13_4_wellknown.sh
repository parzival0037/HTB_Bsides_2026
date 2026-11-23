set +e
C="curl -sSk -m 20 --socks5-hostname 127.0.0.1:1080"
echo "===== WORKLOADS WELL-KNOWN ====="
$C -i https://workloads.keplerops.test/.well-known/fieldkest-client; echo
echo "===== DATA WELL-KNOWN ====="
$C -i https://data.keplerops.test/.well-known/fieldkest-client; echo
echo "===== IDENTITY WELL-KNOWN ====="
$C -i https://identity.keplerops.test/.well-known/fieldkest-client; echo
echo "===== OBJECTS WELL-KNOWN ====="
$C -i https://objects.keplerops.test/.well-known/fieldkest-client; echo
echo "===== WORKLOADS ROOT ====="
$C -i https://workloads.keplerops.test/ | head -20
echo "===== DATA ROOT ====="
$C -i https://data.keplerops.test/ | head -20
