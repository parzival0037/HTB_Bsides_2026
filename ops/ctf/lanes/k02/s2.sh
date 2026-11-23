#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
CA=/tmp/keplerca.crt
echo LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUVLekNDQXBPZ0F3SUJBZ0lVYUtBNEZOa3ZNNlRUK3dWYXVnY1BpR1RTR2swd0RRWUpLb1pJaHZjTkFRRUwKQlFBd0hURWJNQmtHQTFVRUF3d1NTMlZ3YkdWeVQzQnpJRkpoYm1kbElFTkJNQjRYRFRJMk1URXhPVEEzTURZeQpNbG9YRFRNMk1URXhOakEzTURZeU1sb3dIVEViTUJrR0ExVUVBd3dTUzJWd2JHVnlUM0J6SUZKaGJtZGxJRU5CCk1JSUJvakFOQmdrcWhraUc5dzBCQVFFRkFBT0NBWThBTUlJQmlnS0NBWUVBeVB5N1RJaXp0YTFJN09oS1FMRFMKOXMxZkpOQnVUeHFNSXdLeHVOQzlmemlicHAwMjVzQ053Wi9xcWtQdXBLZnZzRUJCbjcwZEE0b09TSDZIWTNSVgpYLzBmV2VLM0tyL3poQXV4eEhLS3dldzRLdzlDcVJHbGJKUmwzcmNFS2dta1FPTitHbEVtK3ZORkp0Mnl0VW0rCnkrK0htOHNnNzhxNzJjUHZhcnVJRTRyQXpCdHRMOWZOcWpQc1lOUmgwRTF4dHFGSWk4dXphVEhvc1QraWRjNmoKVE0xM3RYVE0yVE5sK09HRFlUZlFHQ0UwN3UrSWdFRmJyOU1YSmlCdUxyMXBBMDV4elRuK25LNEhNT2RsN0IxRQpEOU8wTnd6dHRyb0tjYmdPRlZLSllzVlhhcnlyYmQ0S2tYeU9IYjM1aktBRmwraHBzU0UxOTBhUnNGL0wrSG5oCk12MG85NURKbldPenVFemtQbitrVEJKazBYWXE0M0p5SDZJQ0t0cVlac0x5K05xZ2pkVjZaRk50YTUzWDlWV0cKdGE4WXdUTHloOTB4L0xXZ2ZFZTlnS0hiRkZNNjZYSktmNE1SV1F0TzU3bU1QRkc1cXB1ZksvTmRiRVR3d3lhcgprMnZkeXBuZ1ByWEgzd2RBK2VubHhvbXFZdEl6b3FiQ21Zd3R2MDNhbElVVEFnTUJBQUdqWXpCaE1BOEdBMVVkCkV3RUIvd1FGTUFNQkFmOHdEZ1lEVlIwUEFRSC9CQVFEQWdFR01CMEdBMVVkRGdRV0JCU000THFtYmJYRHI3NUcKdXdwMEhRd3c0NmJ1NnpBZkJnTlZIU01FR0RBV2dCU000THFtYmJYRHI3NUd1d3AwSFF3dzQ2YnU2ekFOQmdrcQpoa2lHOXcwQkFRc0ZBQU9DQVlFQUtoRHozVkZ5d0xGNGE3YUFtYVFmYlhqNk9YSDgyaGlVMnBxSXBZMGpXMXB5CnR5Ymg0VVVzM0ZaTFJ4NUdHQXl3dGMrRk82ZHdwZFVMbDJyNXErcm55ZTJhUnQwZjgxR09iL2lvcVVBYWZVK0UKM3BFWkVyM2NweitBamZOSW5xNXdnTHUxRmg3Q0NSampncXhJQmZCTjFQMW5xMXVLcDlSUDdUVzYzTDhjV3ZlVAo2UDJPUDc5ZWFqSVNJWWZGMnJBSzd2RzNiQU5XOTRpamljQUR0dmdvTHpqM0R3ajZsSWZacGp1RGZ5U28vVlFOClQvWFVMdmowM0dmMW9vNVY4cTBDRW1wWTJPeWM1Y0I3QndYcGJHdXRZTHA5M1pkYTZUaUpld0lSdzJKUmttOGQKOHBYM3NER05hTnFhWVRFc0s5NnpUOHlUbTFjc1hCa2VudXcyY201aWxyVTlWdzRiVFZ0Q29vY01tbzlNRStsTgpLZ0xjVDNQRE1MOUdYcUNXYmVFMWxpYVJ6OThNbnlwZWJzaTV2ek5kU0Z2QitHWHM4MFNNRHlJV0ZDNHJnejBSCmVJNFpEcVFhZk1uTjhqOElkSVVZMTJRM2NlOGRZbG1ud2x5ZTJHclFTNXBpNEtCbC8xZlRTYyt1ZHJGSFBWUysKRENSM2M2SzdNeDFQeEw3dnd3UlgKLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo= | base64 -d > $CA
AUTH="rowan.ito:fk_developer_yUWTKSqrc16y3K5_5DfQ7qacft9b-9xo"
J="https://ci.keplerops.test/job/fieldlink-report"
mkdir -p /tmp/k02
for f in reports/integration-review-input-v3.json reports/ordinary-support-input-v1.json reports/REVNOTE-1842.json; do
  n=$(basename $f)
  curl -gsS $P --cacert $CA -m 30 -u "$AUTH" "$J/1842/artifact/$f" -o /tmp/k02/$n
  echo "=== $n ($(wc -c </tmp/k02/$n) bytes) ==="
  cat /tmp/k02/$n
  echo
done
echo "=== consoleText ==="
curl -gsS $P --cacert $CA -m 30 -u "$AUTH" "$J/1842/consoleText" -o /tmp/k02/console.txt
wc -c /tmp/k02/console.txt
tail -c 5000 /tmp/k02/console.txt
echo
echo "=== repo tree @c37effd ==="
curl -gsS $P --cacert $CA -m 30 -u "$AUTH" "https://source.keplerops.test/api/v1/repos/fieldkest/fieldlink-connector/git/trees/c37effd7cc86ae4d44f18e95f899b7557d65e0a9?recursive=true" | head -c 6000
echo
echo "=== repo commits ==="
curl -gsS $P --cacert $CA -m 30 -u "$AUTH" "https://source.keplerops.test/api/v1/repos/fieldkest/fieldlink-connector/commits?limit=20" | head -c 4000
echo
