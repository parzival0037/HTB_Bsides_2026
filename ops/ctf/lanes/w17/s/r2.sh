ls -la ~/.ssh/ 2>&1
echo ---
ls -la /home/kali/.ssh 2>&1 | head
echo ---
find / -maxdepth 4 -name 'keplerops*' 2>/dev/null | head
