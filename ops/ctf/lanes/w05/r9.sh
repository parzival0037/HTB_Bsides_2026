#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
B=https://objects.keplerops.test/fieldkest-workspaces
echo "== no delim"; curl -sS $P -k -m 25 "$B?list-type=2" | head -c 3000; echo
echo "== v1 list"; curl -sS $P -k -m 25 "$B" | head -c 3000; echo
echo "== exports delim"; curl -sS $P -k -m 25 "$B?list-type=2&prefix=exports/&delimiter=/" | head -c 2000; echo
