import json, requests, pathlib, concurrent.futures, re

s = requests.Session()
jar = {}
for line in pathlib.Path('cookies.txt').read_text().splitlines():
    if line.startswith('#HttpOnly_'): line = line.replace('#HttpOnly_', '', 1)
    if line.startswith('#') or not line.strip(): continue
    parts = line.split('\t')
    if len(parts) == 7: jar[parts[5]] = parts[6]
s.cookies.update(jar)

H = {"X-Request-ID": "recon-details", "Referer": "https://bsides.keplerops.com/ctf/challenges/"}
chs = json.load(open('challenges.json'))
todo = [c for c in chs if not c['solved']]
out = {}

def get(c):
    r = s.get(f"https://bsides.keplerops.com/api/v1/ctf/me/challenges/{c['id']}/", headers=H, timeout=30)
    return c['id'], r.json()

with concurrent.futures.ThreadPoolExecutor(8) as ex:
    for cid, data in ex.map(get, todo):
        out[cid] = data

json.dump(out, open('details.json', 'w'), indent=1)
print("fetched", len(out))
d = next(iter(out.values()))
print(json.dumps(d, indent=1)[:2500])
