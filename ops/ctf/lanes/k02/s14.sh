#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
CA=/tmp/keplerca.crt
echo LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUVLekNDQXBPZ0F3SUJBZ0lVYUtBNEZOa3ZNNlRUK3dWYXVnY1BpR1RTR2swd0RRWUpLb1pJaHZjTkFRRUwKQlFBd0hURWJNQmtHQTFVRUF3d1NTMlZ3YkdWeVQzQnpJRkpoYm1kbElFTkJNQjRYRFRJMk1URXhPVEEzTURZeQpNbG9YRFRNMk1URXhOakEzTURZeU1sb3dIVEViTUJrR0ExVUVBd3dTUzJWd2JHVnlUM0J6SUZKaGJtZGxJRU5CCk1JSUJvakFOQmdrcWhraUc5dzBCQVFFRkFBT0NBWThBTUlJQmlnS0NBWUVBeVB5N1RJaXp0YTFJN09oS1FMRFMKOXMxZkpOQnVUeHFNSXdLeHVOQzlmemlicHAwMjVzQ053Wi9xcWtQdXBLZnZzRUJCbjcwZEE0b09TSDZIWTNSVgpYLzBmV2VLM0tyL3poQXV4eEhLS3dldzRLdzlDcVJHbGJKUmwzcmNFS2dta1FPTitHbEVtK3ZORkp0Mnl0VW0rCnkrK0htOHNnNzhxNzJjUHZhcnVJRTRyQXpCdHRMOWZOcWpQc1lOUmgwRTF4dHFGSWk4dXphVEhvc1QraWRjNmoKVE0xM3RYVE0yVE5sK09HRFlUZlFHQ0UwN3UrSWdFRmJyOU1YSmlCdUxyMXBBMDV4elRuK25LNEhNT2RsN0IxRQpEOU8wTnd6dHRyb0tjYmdPRlZLSllzVlhhcnlyYmQ0S2tYeU9IYjM1aktBRmwraHBzU0UxOTBhUnNGL0wrSG5oCk12MG85NURKbldPenVFemtQbitrVEJKazBYWXE0M0p5SDZJQ0t0cVlac0x5K05xZ2pkVjZaRk50YTUzWDlWV0cKdGE4WXdUTHloOTB4L0xXZ2ZFZTlnS0hiRkZNNjZYSktmNE1SV1F0TzU3bU1QRkc1cXB1ZksvTmRiRVR3d3lhcgprMnZkeXBuZ1ByWEgzd2RBK2VubHhvbXFZdEl6b3FiQ21Zd3R2MDNhbElVVEFnTUJBQUdqWXpCaE1BOEdBMVVkCkV3RUIvd1FGTUFNQkFmOHdEZ1lEVlIwUEFRSC9CQVFEQWdFR01CMEdBMVVkRGdRV0JCU000THFtYmJYRHI3NUcKdXdwMEhRd3c0NmJ1NnpBZkJnTlZIU01FR0RBV2dCU000THFtYmJYRHI3NUd1d3AwSFF3dzQ2YnU2ekFOQmdrcQpoa2lHOXcwQkFRc0ZBQU9DQVlFQUtoRHozVkZ5d0xGNGE3YUFtYVFmYlhqNk9YSDgyaGlVMnBxSXBZMGpXMXB5CnR5Ymg0VVVzM0ZaTFJ4NUdHQXl3dGMrRk82ZHdwZFVMbDJyNXErcm55ZTJhUnQwZjgxR09iL2lvcVVBYWZVK0UKM3BFWkVyM2NweitBamZOSW5xNXdnTHUxRmg3Q0NSampncXhJQmZCTjFQMW5xMXVLcDlSUDdUVzYzTDhjV3ZlVAo2UDJPUDc5ZWFqSVNJWWZGMnJBSzd2RzNiQU5XOTRpamljQUR0dmdvTHpqM0R3ajZsSWZacGp1RGZ5U28vVlFOClQvWFVMdmowM0dmMW9vNVY4cTBDRW1wWTJPeWM1Y0I3QndYcGJHdXRZTHA5M1pkYTZUaUpld0lSdzJKUmttOGQKOHBYM3NER05hTnFhWVRFc0s5NnpUOHlUbTFjc1hCa2VudXcyY201aWxyVTlWdzRiVFZ0Q29vY01tbzlNRStsTgpLZ0xjVDNQRE1MOUdYcUNXYmVFMWxpYVJ6OThNbnlwZWJzaTV2ek5kU0Z2QitHWHM4MFNNRHlJV0ZDNHJnejBSCmVJNFpEcVFhZk1uTjhqOElkSVVZMTJRM2NlOGRZbG1ud2x5ZTJHclFTNXBpNEtCbC8xZlRTYyt1ZHJGSFBWUysKRENSM2M2SzdNeDFQeEw3dnd3UlgKLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo= | base64 -d > $CA
rm -f /tmp/k02cj
curl -gsS $P --cacert $CA -m 25 -c /tmp/k02cj -b /tmp/k02cj "https://support.keplerops.test/scp/login.php" -o /tmp/k02login.html -w 'login page: %{http_code}\n'
head -c 3000 /tmp/k02login.html
echo
echo "=== try login ==="
TOK=$(grep -o 'name="__CSRFToken__" value="[^"]*"' /tmp/k02login.html | head -1 | sed 's/.*value="//;s/"//')
echo "token=$TOK"
curl -gsS $P --cacert $CA -m 25 -c /tmp/k02cj -b /tmp/k02cj -L \
  --data-urlencode "__CSRFToken__=$TOK" \
  --data-urlencode "username=maya.ranscombe" \
  --data-urlencode "password=sWQa31085FTQekZhHTxUyf_9E1marq0ur8WNCKmTtnk" \
  --data-urlencode "dologin=1" \
  "https://support.keplerops.test/scp/login.php" -o /tmp/k02after.html -w 'after login: %{http_code} -> %{url_effective}\n'
grep -o '<title>[^<]*' /tmp/k02after.html | head -3
grep -oE 'href="(tickets|index)\.php[^"]*"' /tmp/k02after.html | head -10
echo "=== tickets ==="
curl -gsS $P --cacert $CA -m 25 -b /tmp/k02cj "https://support.keplerops.test/scp/tickets.php" -o /tmp/k02t.html -w 'tickets: %{http_code}\n'
grep -oE 'tickets\.php\?id=[0-9]+[^"]*' /tmp/k02t.html | sort -u | head -20
grep -oE '<td[^>]*>[^<]{0,80}' /tmp/k02t.html | head -40
