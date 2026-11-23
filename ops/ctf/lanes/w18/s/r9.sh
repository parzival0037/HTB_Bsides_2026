#!/bin/bash
echo "=== workbench index"
curl -sS --max-time 20 http://10.77.40.20:8080/ | head -120
echo "=== 8081"
curl -sS --max-time 15 -o /dev/null -w '%{http_code}\n' http://10.77.40.20:8081/
echo "=== 8082"
curl -sS --max-time 15 -o /dev/null -w '%{http_code}\n' http://10.77.40.20:8082/
echo "=== 8083"
curl -sS --max-time 15 -o /dev/null -w '%{http_code}\n' http://10.77.40.20:8083/
