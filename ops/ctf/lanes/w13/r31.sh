#!/bin/bash
echo "== which nmap =="; which nmap
echo "== scan 10.77.40.0/23 common =="
nmap -sT -Pn -n --open -T4 -p 22,80,443,3000,5000,8000,8080,8081,8082,8083,8084,8085,8443,8888,9090,1881,4840,502,102,9000,7000,8001,3001,4000 10.77.40.0/23 2>/dev/null | grep -E 'Nmap scan|^[0-9]|open' | head -80
echo "== scan 10.77.42.0/23 common =="
nmap -sT -Pn -n --open -T4 -p 22,80,443,3000,5000,8000,8080,8081,8082,8083,8443,8888,9090,1881,4840,502,102,9000 10.77.42.0/23 2>/dev/null | grep -E 'Nmap scan|^[0-9]|open' | head -80
