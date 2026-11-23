#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
CA=/tmp/w01ca.crt
echo "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUVLekNDQXBPZ0F3SUJBZ0lVYUtBNEZOa3ZNNlRUK3dWYXVnY1BpR1RTR2swd0RRWUpLb1pJaHZjTkFRRUwKQlFBd0hURWJNQmtHQTFVRUF3d1NTMlZ3YkdWeVQzQnpJRkpoYm1kbElFTkJNQjRYRFRJMk1URXhPVEEzTURZeQpNbG9YRFRNMk1URXhOakEzTURZeU1sb3dIVEViTUJrR0ExVUVBd3dTUzJWd2JHVnlUM0J6SUZKaGJtZGxJRU5CCk1JSUJvakFOQmdrcWhraUc5dzBCQVFFRkFBT0NBWThBTUlJQmlnS0NBWUVBeVB5N1RJaXp0YTFJN09oS1FMRFMKOXMxZkpOQnVUeHFNSXdLeHVOQzlmemlicHAwMjVzQ053Wi9xcWtQdXBLZnZzRUJCbjcwZEE0b09TSDZIWTNSVgpYLzBmV2VLM0tyL3poQXV4eEhLS3dldzRLdzlDcVJHbGJKUmwzcmNFS2dta1FPTitHbEVtK3ZORkp0Mnl0VW0rCnkrK0htOHNnNzhxNzJjUHZhcnVJRTRyQXpCdHRMOWZOcWpQc1lOUmgwRTF4dHFGSWk4dXphVEhvc1QraWRjNmoKVE0xM3RYVE0yVE5sK09HRFlUZlFHQ0UwN3UrSWdFRmJyOU1YSmlCdUxyMXBBMDV4elRuK25LNEhNT2RsN0IxRQpEOU8wTnd6dHRyb0tjYmdPRlZLSllzVlhhcnlyYmQ0S2tYeU9IYjM1aktBRmwraHBzU0UxOTBhUnNGL0wrSG5oCk12MG85NURKbldPenVFemtQbitrVEJKazBYWXE0M0p5SDZJQ0t0cVlac0x5K05xZ2pkVjZaRk50YTUzWDlWV0cKdGE4WXdUTHloOTB4L0xXZ2ZFZTlnS0hiRkZNNjZYSktmNE1SV1F0TzU3bU1QRkc1cXB1ZksvTmRiRVR3d3lhcgprMnZkeXBuZ1ByWEgzd2RBK2VubHhvbXFZdEl6b3FiQ21Zd3R2MDNhbElVVEFnTUJBQUdqWXpCaE1BOEdBMVVkCkV3RUIvd1FGTUFNQkFmOHdEZ1lEVlIwUEFRSC9CQVFEQWdFR01CMEdBMVVkRGdRV0JCU000THFtYmJYRHI3NUcKdXdwMEhRd3c0NmJ1NnpBZkJnTlZIU01FR0RBV2dCU000THFtYmJYRHI3NUd1d3AwSFF3dzQ2YnU2ekFOQmdrcQpoa2lHOXcwQkFRc0ZBQU9DQVlFQUtoRHozVkZ5d0xGNGE3YUFtYVFmYlhqNk9YSDgyaGlVMnBxSXBZMGpXMXB5CnR5Ymg0VVVzM0ZaTFJ4NUdHQXl3dGMrRk82ZHdwZFVMbDJyNXErcm55ZTJhUnQwZjgxR09iL2lvcVVBYWZVK0UKM3BFWkVyM2NweitBamZOSW5xNXdnTHUxRmg3Q0NSampncXhJQmZCTjFQMW5xMXVLcDlSUDdUVzYzTDhjV3ZlVAo2UDJPUDc5ZWFqSVNJWWZGMnJBSzd2RzNiQU5XOTRpamljQUR0dmdvTHpqM0R3ajZsSWZacGp1RGZ5U28vVlFOClQvWFVMdmowM0dmMW9vNVY4cTBDRW1wWTJPeWM1Y0I3QndYcGJHdXRZTHA5M1pkYTZUaUpld0lSdzJKUmttOGQKOHBYM3NER05hTnFhWVRFc0s5NnpUOHlUbTFjc1hCa2VudXcyY201aWxyVTlWdzRiVFZ0Q29vY01tbzlNRStsTgpLZ0xjVDNQRE1MOUdYcUNXYmVFMWxpYVJ6OThNbnlwZWJzaTV2ek5kU0Z2QitHWHM4MFNNRHlJV0ZDNHJnejBSCmVJNFpEcVFhZk1uTjhqOElkSVVZMTJRM2NlOGRZbG1ud2x5ZTJHclFTNXBpNEtCbC8xZlRTYyt1ZHJGSFBWUysKRENSM2M2SzdNeDFQeEw3dnd3UlgKLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo=" | base64 -d > $CA
SSH="ssh -i /home/cinder/.ssh/keplerops-foothold -p 2222 -o StrictHostKeyChecking=no rowan@10.50.13.180"
echo "=== support-client.json ==="
$SSH 'cat ~/.config/fieldlink/support-client.json' 2>/dev/null
echo "=== handovers/current (no auth) ==="
curl -sS $P --cacert $CA --max-time 20 -i https://support.keplerops.test:8443/api/handovers/current | head -40
TOK=$($SSH 'python3 -c "import json;print(json.load(open(\"/home/rowan/.config/fieldlink/support-client.json\"))[\"bearer\"])"' 2>/dev/null)
echo "TOKLEN=${#TOK}"
echo "=== handovers/current (auth) ==="
curl -sS $P --cacert $CA --max-time 20 -i -H "Authorization: Bearer $TOK" https://support.keplerops.test:8443/api/handovers/current | head -60
echo "=== connector receipt 7.4.2 ==="
curl -sS $P --cacert $CA --max-time 20 -i https://connector.arwc.test/api/fieldlink/packages/7.4.2/receipt | head -40
echo "=== connector poll ==="
curl -sS $P --cacert $CA --max-time 20 -i -X POST https://connector.arwc.test/api/fieldlink/packages/poll | head -40
echo "=== delivery package-meta ==="
curl -sS $P --cacert $CA --max-time 20 -i https://delivery.keplerops.test:8443/api/package-meta/fieldlink-connector | head -30
