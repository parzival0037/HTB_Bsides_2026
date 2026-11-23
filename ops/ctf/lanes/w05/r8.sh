#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
B=https://objects.keplerops.test/fieldkest-workspaces
for pre in exports/ notebooks/; do
 echo "=== $pre"
 curl -sS $P -k -m 20 "$B?list-type=2&prefix=$pre" | python3 -c "
import sys,re
d=sys.stdin.read()
for m in re.finditer(r'<Key>(.*?)</Key><LastModified>(.*?)</LastModified>.*?<Size>(\d+)</Size>',d,re.S):
    print(m.group(3), m.group(1))
"
done
