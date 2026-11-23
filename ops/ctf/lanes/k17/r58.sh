set +e
W=http://10.77.40.20
H='Authorization: Bearer courier_DL204_CR17_4N7Q2M9K'
echo "===== manifest ====="
curl -sS -m 6 -i -H "$H" "$W:8082/api/deliveries/DL-204/manifest" | head -40
echo; echo "===== manifest pretty ====="
curl -sS -m 6 -H "$H" "$W:8082/api/deliveries/DL-204/manifest" | python3 -m json.tool 2>&1 | head -120
echo "===== object fetch guesses ====="
for u in "/api/objects/manifest/DL-204" "/api/deliveries/DL-204" "/api/deliveries/DL-204/parcels" "/api/deliveries/DL-204/objects" "/api/deliveries/DL-219/manifest"; do
 echo "--- $u"
 curl -sS -m 6 -H "$H" -w '\n[%{http_code}]\n' "$W:8082$u" | head -c 800; echo
done
