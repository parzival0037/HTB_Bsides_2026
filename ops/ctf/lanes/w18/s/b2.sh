#!/bin/bash
echo "===== state.training root"
curl -sS -m 10 -i http://state.training:8080/ | head -60
echo; echo "===== state.training paths"
for p in / /index.html /robots.txt /sitemap.xml /api /api/status /health /outlet /outlets /scada /desk /login; do
  printf '%-16s ' "$p"; curl -sS -m 6 -o /tmp/o -w '[%{http_code}] ' "http://state.training:8080$p"; head -c 200 /tmp/o | tr '\n' ' '; echo
done
echo; echo "===== workbench root"
curl -sS -m 10 http://workbench.training:8080/ | head -60
echo; echo "===== 10.77.40.50 ports"
for p in 22 80 443 3000 4840 5432 8000 8080 8081 8443 1881; do (echo >/dev/tcp/10.77.40.50/$p) 2>/dev/null && echo "OPEN $p"; done
echo "===== 10.77.40.10:8000"
curl -sS -m 6 -i http://10.77.40.10:8000/ | head -30
echo "===== mission file"
cat "$HOME/MISSION - START HERE.txt"
