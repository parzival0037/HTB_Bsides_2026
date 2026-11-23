#!/bin/bash
B=http://10.77.40.50:8080
for p in field-guide.md captures/volume.json captures/volume-sealed.enc captures/status.json captures/status-sealed.enc replay/report.json replay/report-sealed.enc replay/requests.json replay/observations.csv practice; do
  echo "########## /$p"
  curl -sS -i --max-time 10 "$B/$p" | head -c 6000
  echo
done
