#!/bin/bash
H=accounts.training
echo "=== getent ==="; getent hosts $H
echo "=== root ==="; curl -s -i --max-time 15 http://$H:8080/
echo; echo "=== robots ==="; curl -s -i --max-time 15 http://$H:8080/robots.txt
echo; echo "=== links from root ==="; curl -s --max-time 15 http://$H:8080/ | grep -oE '(href|src)="[^"]*"'
