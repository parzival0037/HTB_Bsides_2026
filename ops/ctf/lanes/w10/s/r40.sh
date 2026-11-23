#!/bin/bash
P="--socks5-hostname 127.0.0.1:1080 -k -sS -m 40"
A=https://assistant.keplerops.test
SUP=fk_support_rowan_2fxtXNkUjKMbcvPBlAot0Jp0vVNppL9b
g(){ echo; echo "##### GET $1 (auth=$2)"; if [ "$2" = "c" ]; then curl $P -H "Cookie: fieldkest_support=$SUP" "$A$1" -w '\n[%{http_code}]\n'; else curl $P "$A$1" -w '\n[%{http_code}]\n'; fi; }
g /api/config
g /api/contexts
g /api/contexts c
g /api/selections c
g /api/conversations c
