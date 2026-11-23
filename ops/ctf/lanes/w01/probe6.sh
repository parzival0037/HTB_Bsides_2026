#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
echo "########## support well-known"
curl -sS $P -k --max-time 20 https://support.keplerops.test/.well-known/fieldkest-client | python3 -m json.tool
echo "########## indexer well-known"
curl -sS $P -k --max-time 20 https://indexer.keplerops.test/.well-known/fieldkest-client | python3 -m json.tool
echo "########## cloud-api well-known"
curl -sS $P -k --max-time 20 https://cloud-api.keplerops.test/.well-known/fieldkest-client | python3 -m json.tool
