#!/bin/bash
nmap -sn -n 10.77.40.0/24 10.77.41.0/24 2>&1 | grep -E "Nmap scan|MAC|Host is up" | head -60
echo === 
nmap -n -p 22,80,443,1881,4840,5432,8080,8443,3000,502 --open -T4 10.77.40.0/24 10.77.41.0/24 2>&1 | grep -E "Nmap scan report|open" | head -60
