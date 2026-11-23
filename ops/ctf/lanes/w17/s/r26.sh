#!/bin/bash
id; sudo -n id
echo "--- ping test"
timeout 20 sudo -n nmap -n -p 8080 --open 10.77.40.20 2>&1 | head -20
echo "--- sn"
timeout 30 sudo -n nmap -sn -n 10.77.40.20 2>&1 | head -20
echo "--- no sudo"
timeout 30 nmap -n -p 8080 --open 10.77.40.20 2>&1 | head -20
