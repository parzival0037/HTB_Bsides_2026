#!/usr/bin/env python3
"""Unlock hints for unsolved challenges, within a point budget.
Usage: ./hints.py <budget> <name-prefix> [<name-prefix> ...]"""
import json, sys, pathlib, requests

CTF = pathlib.Path('/home/kali/ctf')
s = requests.Session()
jar = {}
for line in (CTF / 'cookies.txt').read_text().splitlines():
    if line.startswith('#HttpOnly_'):
        line = line.replace('#HttpOnly_', '', 1)
    if line.startswith('#') or not line.strip():
        continue
    p = line.split('\t')
    if len(p) == 7:
        jar[p[5]] = p[6]
s.cookies.update(jar)
H = {"X-Request-ID": "hints", "X-CSRFToken": s.cookies.get('csrftoken', ''),
     "Referer": "https://bsides.keplerops.com/ctf/challenges/",
     "Origin": "https://bsides.keplerops.com"}

if True:  # HINTS DISABLED by operator — points must not be spent
    if '--force' not in sys.argv:
    print("refusing to spend points: hints.py now requires --force (score penalty)")
    raise SystemExit(1)
sys.argv.remove('--force')
budget = int(sys.argv[1])
prefixes = tuple(x.upper() for x in sys.argv[2:])
ch = json.loads((CTF / 'challenges.json').read_text())
targets = [c for c in ch if not c['solved'] and c['name'].upper().startswith(prefixes)]
spent = 0
out = []
for c in sorted(targets, key=lambda x: x['order']):
    d = s.get(f"https://bsides.keplerops.com/api/v1/ctf/me/challenges/{c['id']}/", headers=H, timeout=30).json()
    while True:
        nh, cost = d.get('next_hint_id'), d.get('next_hint_cost') or 0
        if not nh or spent + cost > budget:
            break
        r = s.post(f"https://bsides.keplerops.com/api/v1/ctf/challenges/{c['id']}/hint/",
                   json={"hint_id": nh}, headers=H, timeout=30)
        if r.status_code != 200:
            out.append(f"- {c['name']}: hint unlock failed {r.status_code} {r.text[:120]}")
            break
        spent += cost
        d = s.get(f"https://bsides.keplerops.com/api/v1/ctf/me/challenges/{c['id']}/", headers=H, timeout=30).json()
    got = [h['text'] for h in d.get('hints', []) if h.get('unlocked') and h.get('text')]
    if got:
        out.append(f"### {c['name']}  ({c['points']}p {c['difficulty']})\n" +
                   "\n".join(f"  - {t}" for t in got))
print(f"spent {spent} points")
(CTF / 'lanes/HINTS.md').write_text("# Unlocked hints\n\n" + "\n\n".join(out) + "\n")
print("\n\n".join(out))
