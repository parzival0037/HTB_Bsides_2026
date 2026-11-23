#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
B=https://objects.keplerops.test
echo "== list root"
curl -sS $P -k -m 20 "$B/fieldkest-workspaces?list-type=2&delimiter=/" | python3 -c "
import sys,re
d=sys.stdin.read()
print(d[:3000])
"
