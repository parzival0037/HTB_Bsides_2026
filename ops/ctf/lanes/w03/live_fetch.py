import json, requests, pathlib, concurrent.futures
s = requests.Session(); jar={}
for line in pathlib.Path('/home/kali/ctf/cookies.txt').read_text().splitlines():
    if line.startswith('#HttpOnly_'): line=line.replace('#HttpOnly_','',1)
    if line.startswith('#') or not line.strip(): continue
    p=line.split('\t')
    if len(p)==7: jar[p[5]]=p[6]
s.cookies.update(jar)
H={"X-Request-ID":"reading-unlocked","Referer":"https://bsides.keplerops.com/ctf/challenges/"}
chs=json.load(open('/home/kali/ctf/challenges.json'))
todo=[c for c in chs if not c['solved']]
out={}
def get(c):
    r=s.get(f"https://bsides.keplerops.com/api/v1/ctf/me/challenges/{c['id']}/",headers=H,timeout=30)
    return c['id'],r.json()
with concurrent.futures.ThreadPoolExecutor(6) as ex:
    for cid,d in ex.map(get,todo): out[cid]=d
json.dump(out,open('/home/kali/ctf/lanes/w03/live_details.json','w'),indent=1)
print('fetched',len(out))
for cid,v in out.items():
    for h in v.get('hints',[]):
        if h.get('unlocked') and h.get('text'):
            print('HINT',v['name'],'::',h['text'])
