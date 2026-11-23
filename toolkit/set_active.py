#!/usr/bin/env python3
"""Keep the board honest: in-progress == the chapters actually running.
Usage: ./set_active.py K13 W01     (empty args clears in-progress)"""
import json, sys, pathlib
CTF = pathlib.Path('/home/kali/ctf')
st = json.loads((CTF / 'lanes/state.json').read_text())
ch = {c['name']: c for c in json.loads((CTF / 'challenges.json').read_text())}
active = {a.upper() for a in sys.argv[1:]}
st['in_progress'] = {}
for name, c in ch.items():
    if c['solved']:
        continue
    code = name.split(':')[0].split('.')[0].upper()
    if code in active:
        st['in_progress'][name] = {"lane": code}
# lanes block: active -> running, others -> idle/queued
for code in list(st['lanes']):
    if code in active:
        st['lanes'][code]['status'] = 'running'
    elif st['lanes'][code].get('status') != 'complete — 16/16':
        st['lanes'][code]['status'] = 'idle'
for code in active:
    st['lanes'].setdefault(code, {"what": "", "status": "running"})
(CTF / 'lanes/state.json').write_text(json.dumps(st, indent=1))
print(f"in progress: {len(st['in_progress'])} cards across {len(active)} lanes: {' '.join(sorted(active))}")
