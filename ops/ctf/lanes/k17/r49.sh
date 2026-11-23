set +e
for h in 10.77.40.20; do
 for p in 8083; do
  echo "##### $h:$p root"
  curl -sS -m 6 -i "http://$h:$p/" 2>&1 | head -30
 done
done
echo "##### via socks 8083"
curl -sS -m 8 --socks5-hostname 127.0.0.1:1080 -i "http://workbench.training:8083/" 2>&1 | head -30
echo "##### diagnostics helper paths"
for p in / /health /status /packages /retained /manifest /api /api/packages /api/retained /api/diagnostics /packages/DIAG-CRR-MIXED-19 /DIAG-CRR-MIXED-19 /api/packages/DIAG-CRR-MIXED-19 /download/DIAG-CRR-MIXED-19 /api/diagnostics/DIAG-CRR-MIXED-19 /api/exercises/connector-archive/run; do
 echo "--- $p"
 curl -sS -m 8 --socks5-hostname 127.0.0.1:1080 -w '\n[%{http_code}]\n' "http://workbench.training:8083$p" | head -c 600; echo
done
