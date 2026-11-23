#!/bin/bash
echo "== localhost:8000"; curl -sS -m 5 -i http://127.0.0.1:8000/ | head -30
echo "== 10.77.40.10:8000"; curl -sS -m 5 -i http://10.77.40.10:8000/ | head -20
echo "== ss"; ss -lntp 2>/dev/null | head -20
echo "== env"; env | grep -iE "url|host|proxy|range|desk" | head
echo "== home dotfiles"; ls -la ~/.config | head -30
