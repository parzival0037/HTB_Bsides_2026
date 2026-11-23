#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080"
show(){ echo "########## $1"; curl -sS $P -k --max-time 20 -i "$1" | head -c 1500; echo; }
show https://workboard.keplerops.test/
show https://staff.keplerops.test/
show https://tickets.keplerops.test/
show https://support.keplerops.test/scp/
