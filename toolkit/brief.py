#!/usr/bin/env python3
"""Print unsolved challenges. Usage: ./brief.py [prefix]  e.g. ./brief.py T02 / K03 / W"""
import json, sys, re
det = json.load(open('/home/kali/ctf/details.json'))
ch = {c['id']: c for c in json.load(open('/home/kali/ctf/challenges.json'))}
pat = sys.argv[1] if len(sys.argv) > 1 else ''
n = 0
for cid, v in sorted(det.items(), key=lambda x: ch[x[0]]['order']):
    if v['solved']: continue
    if pat and not re.search(pat, v['name'], re.I): continue
    n += 1
    print(f"### {v['name']}  ({v['points']}p {v['difficulty']})  id={cid}  attempts={v['attempt_count']}")
    print(v['description'].strip())
    for h in v['hints']:
        if h['unlocked'] and h['text']: print("  HINT:", h['text'])
    print()
print(f"-- {n} unsolved matching {pat!r}")
