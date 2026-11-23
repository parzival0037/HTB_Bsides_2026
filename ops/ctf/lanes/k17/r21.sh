set +e
rm -rf /tmp/handover
git clone -q http://workbench.training:8080/git/handover.git /tmp/handover 2>&1
cd /tmp/handover || exit
echo "=== FILES ==="; find . -type f -not -path './.git/*' | sort
echo "=== LOG ==="; git log --all --oneline --decorate --stat | head -80
echo "=== GREP ==="; grep -rniE 'cinder|delegat|reviewer|talia|mornac|arwc|note' . --exclude-dir=.git | head -60
echo "=== ALL OBJECTS GREP ==="
for o in $(git rev-list --objects --all | awk '{print $1}'); do git cat-file -p $o 2>/dev/null; done | grep -iE 'cinder|delegat|reviewer|talia|mornac|note' | head -40
echo "=== notice ==="
curl -sS -m 6 http://workbench.training:8081/notice-DL-204.md; echo
echo "=== retired client ==="
curl -sS -m 6 http://workbench.training:8080/retired-client/profile.json; echo
