#!/usr/bin/env python3
"""Watch the submission feed and print every newly SOLVED challenge.

  ./watch_solves.py            # foreground: prints new solves as they land
  ./watch_solves.py --once     # one pass, then exit (for cron/manual checks)

State: /home/kali/ctf/solved_seen.json  (challenge_id -> first-seen time)
Output: one line per new solve, appended to /home/kali/ctf/SOLVES.log
"""
import json, sys, time, datetime, pathlib, requests

CTF = pathlib.Path('/home/kali/ctf')
SEEN = CTF / 'solved_seen.json'
LOG = CTF / 'SOLVES.log'
POLL = 20


def session():
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
    return s


def fetch(s, path, tries=6, delay=4):
    last = None
    for _ in range(tries):
        try:
            r = s.get(f"https://bsides.keplerops.com{path}",
                      headers={"X-Request-ID": "watch"}, timeout=25)
            if r.ok:
                return r.json()
        except Exception as e:
            last = e
        time.sleep(delay)
    raise last or RuntimeError("fetch failed")


def report(line):
    stamp = datetime.datetime.now().strftime('%H:%M:%S')
    text = f"[{stamp}] {line}"
    print(text, flush=True)
    with open(LOG, 'a') as f:
        f.write(text + "\n")


def pass_once(s):
    subs = fetch(s, '/api/v1/ctf/submissions/')['submissions']
    ch = {c['id']: c for c in fetch(s, '/api/v1/ctf/me/challenges/')}
    seen = json.loads(SEEN.read_text()) if SEEN.exists() else {}
    new = []
    for x in subs:
        if not x.get('is_correct'):
            continue
        cid = x['challenge_id']
        if cid in seen:
            continue
        seen[cid] = x['submitted_at']
        new.append(x)
    SEEN.write_text(json.dumps(seen, indent=1))
    solved_total = sum(1 for c in ch.values() if c['solved'])
    for x in sorted(new, key=lambda y: y['submitted_at']):
        c = ch.get(x['challenge_id'], {})
        report(f"SOLVED {x['challenge_name']}  +{x['points_awarded']}p  "
               f"(attempt {x['attempt_number']})  {c.get('difficulty','')}  "
               f"— total {solved_total}/{len(ch)}")
    return len(new), solved_total, len(ch)


def main():
    s = session()
    if '--once' in sys.argv:
        n, tot, allc = pass_once(s)
        if n == 0:
            report(f"no new solves — {tot}/{allc}")
        return
    report("watcher started")
    pass_once(s)
    while True:
        try:
            pass_once(s)
        except Exception as e:
            report(f"watch error: {type(e).__name__}: {e}")
        time.sleep(POLL)


if __name__ == '__main__':
    main()
