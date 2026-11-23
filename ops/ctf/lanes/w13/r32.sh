#!/bin/bash
echo "=== nmap single ==="
sudo -n nmap -sT -Pn -n --open -p 8080 10.77.40.20 2>&1 | tail -20
echo "=== nmap subnet 10.77.40.0/24 8080 ==="
sudo -n nmap -sT -Pn -n --open -p 8080 10.77.40.0/24 2>&1 | tail -40
echo "=== ip ==="; ip -4 addr 2>&1 | head; ip route 2>&1 | head
