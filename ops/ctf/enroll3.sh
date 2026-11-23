set +e
T="fk_cert_enrollment_Um9U1sNZQ5b_Cb08iirD4H-BKfz8aMF9"
R="/home/rowan/.local/share/keplerops/ca.crt"
for subj in evan.calderoux@keplerops.test arwc-connector-consumer@19f43d2; do
  echo "===== $subj"
  ssh -o BatchMode=yes rowan-dev "cd /tmp && rm -f c.crt c.key && step ca certificate '$subj' c.crt c.key --ca-url https://ca.keplerops.test --root $R --provisioner fieldkest-enrollment --token '$T' 2>&1 | tail -6; [ -f c.crt ] && openssl x509 -in c.crt -noout -subject -issuer -dates -ext extendedKeyUsage 2>/dev/null"
done
