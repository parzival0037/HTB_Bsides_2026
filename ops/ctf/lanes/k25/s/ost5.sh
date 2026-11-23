sed -n '/<form/,/<\/form>/p' /tmp/k25-login.html
echo "=== error/notice"
grep -iE 'error|invalid|denied|disabled|locked|notice|banner' /tmp/k25-loginpost.html | head -20
