set +e
cd /tmp && rm -rf hb && git clone -q http://workbench.training:8080/git/handover.git hb 2>&1
echo "=== LOG ==="; git -C hb log --all --oneline --stat | head -60
echo "=== FILES ==="; find hb -type f -not -path '*/.git/*' | head -40
echo "=== TRACKER ==="; curl -sS -m 8 http://workbench.training:8080/workspace/delivery-tracker.csv | head -20
echo "=== PROFILE ==="; curl -sS -m 8 http://workbench.training:8080/retired-client/profile.json
echo "=== 8083 root ==="; curl -sS -m 8 -i http://workbench.training:8083/ | head -30
echo "=== 8081 root ==="; curl -sS -m 8 -i http://workbench.training:8081/ | head -40
