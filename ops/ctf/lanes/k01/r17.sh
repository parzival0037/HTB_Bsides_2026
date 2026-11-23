set +e
S="ssh -o BatchMode=yes -o StrictHostKeyChecking=no rowan-dev"
$S 'bash -s' <<'RSH'
set +e
CA=/home/rowan/.local/share/keplerops/ca.crt
for hp in 10.77.50.11:443 10.77.50.11:8443 10.77.51.20:443 10.77.51.20:8443 10.77.51.30:443 10.77.51.30:8443 10.77.51.40:443 10.77.51.41:443 10.77.51.50:443 10.77.51.60:443 10.77.51.70:443 10.77.60.20:443; do
  h=${hp%:*}; p=${hp#*:}
  echo "===== $hp ====="
  echo | timeout 5 openssl s_client -connect $hp -servername x -CAfile $CA 2>/dev/null | openssl x509 -noout -subject -ext subjectAltName 2>/dev/null
  curl -sS -m 6 -k -i "https://$hp/" 2>&1 | head -8
done
echo "===SSH BANNERS==="
for hp in 10.77.60.20:22 10.77.51.20:22 10.77.55.1:22 10.77.50.1:22; do echo -n "$hp: "; timeout 4 bash -c "exec 3<>/dev/tcp/${hp%:*}/${hp#*:}; head -1 <&3" 2>&1; done
RSH
