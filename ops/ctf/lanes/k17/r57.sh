set +e
W=http://10.77.40.20
H='Authorization: Bearer courier_DL204_CR17_4N7Q2M9K'
for p in /site.webmanifest /manifest.json /manifest.webmanifest /client.json /client-profile.json /content-index.json /content.json /index.json /static/client.json /static/manifest.json /workspace/ /workspace/delivery-tracker.csv /retired-client/ /retired-client/profile.json /retired-client/request-history.txt; do
 for port in 8080 8081; do
  echo "--- $port$p"
  curl -sS -m 6 -w '\n[%{http_code}]\n' "$W:$port$p" | head -c 700; echo
 done
done
echo "===== 8081 guesses ====="
for p in /rehearsal /rehearsal/ /rehearsal.md /rehearsal-page /case-note.md /cases/ /cases/CINDER.md /cinder.md /archive/ /private/ /static/ /pages/ /content/ /current/ /retired/ /client/ /dispatch/; do
 echo "--- $p"
 curl -sS -m 6 -w '\n[%{http_code}]\n' "$W:8081$p" | head -c 400; echo
done
echo "===== 8082 with token ====="
for p in / /manifest /manifest/DL-204 /delivery/DL-204 /deliveries /deliveries/DL-204 /history /request-history.txt /requests /api /api/manifest /api/deliveries /parcels /parcels/DL-204; do
 echo "--- $p"
 curl -sS -m 6 -H "$H" -w '\n[%{http_code}]\n' "$W:8082$p" | head -c 500; echo
done
