#!/usr/bin/env python3
"""Submit a flag: ./submit.py <challenge-uuid-or-name-prefix> <flag>"""
import sys, json, pathlib, uuid as U, requests

def sess():
    s = requests.Session()
    jar = {}
    for line in pathlib.Path('/home/kali/ctf/cookies.txt').read_text().splitlines():
        if line.startswith('#HttpOnly_'): line = line.replace('#HttpOnly_', '', 1)
        if line.startswith('#') or not line.strip(): continue
        p = line.split('\t')
        if len(p) == 7: jar[p[5]] = p[6]
    s.cookies.update(jar)
    return s

def resolve(key):
    ch = json.load(open('/home/kali/ctf/challenges.json'))
    for c in ch:
        if c['id'] == key or key.lower() in c['name'].lower():
            return c
    return None

if __name__ == '__main__':
    key, flag = sys.argv[1], sys.argv[2]
    c = resolve(key)
    if not c:
        sys.exit(f"no challenge matching {key}")
    s = sess()
    h = {"X-Request-ID": "submit", "X-CSRFToken": s.cookies.get('csrftoken', ''),
         "Referer": "https://bsides.keplerops.com/ctf/challenges/",
         "Origin": "https://bsides.keplerops.com"}
    r = s.post(f"https://bsides.keplerops.com/api/v1/ctf/challenges/{c['id']}/submit/",
               json={"flag": flag}, headers=h, timeout=30)
    print(c['name'], '->', r.status_code, r.text[:400])
