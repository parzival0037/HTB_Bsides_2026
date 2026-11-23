#!/bin/bash
B=http://10.77.40.50:8080
cd /tmp
echo "=== field-guide full ==="
curl -sS --max-time 10 "$B/field-guide.md"
echo
echo "=== sealed downloads ==="
curl -sS -o vol.enc --max-time 10 "$B/captures/volume-sealed.enc"
curl -sS -o sta.enc --max-time 10 "$B/captures/status-sealed.enc"
curl -sS -o rep.enc --max-time 10 "$B/replay/report-sealed.enc"
ls -l vol.enc sta.enc rep.enc
sha256sum vol.enc sta.enc rep.enc
dec() {
  local finding="$1" rid="$2" f="$3"
  local pass
  pass=$(printf '%s' "$finding:$rid" | sha256sum | awk '{print $1}')
  echo "----- $rid pass=$pass"
  openssl enc -d -aes-256-cbc -pbkdf2 -nosalt -pass pass:"$pass" -in "$f" 2>&1
  echo
}
dec "1200.0" "VC-017" vol.enc
dec "service_hold" "SC-018" sta.enc
dec "green" "OR-042" rep.enc
