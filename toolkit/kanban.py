#!/usr/bin/env python3
"""Generate the CTF kanban page from live challenge state + local lane state.

  ./kanban.py            # regenerate kanban.html from the event API
  ./kanban.py --offline  # use cached challenges.json

State inputs:
  /home/kali/ctf/challenges.json   live solved/unsolved (refreshed from API)
  /home/kali/ctf/lanes/state.json  in-progress lanes + notes (hand maintained)

Output: /home/kali/ctf/kanban.html
"""
import json, sys, pathlib, html, datetime, re, time

CTF = pathlib.Path("/home/kali/ctf")
OUT = CTF / "kanban.html"
DIFF_RANK = {"easy": 0, "medium": 1, "hard": 2, "expert": 3}


def _retry(fn, tries=8, delay=4):
    last = None
    for _ in range(tries):
        try:
            return fn()
        except Exception as e:
            last = e
            time.sleep(delay)
    raise last


def fetch_live():
    import requests
    s = requests.Session()
    jar = {}
    for line in (CTF / "cookies.txt").read_text().splitlines():
        if line.startswith("#HttpOnly_"):
            line = line.replace("#HttpOnly_", "", 1)
        if line.startswith("#") or not line.strip():
            continue
        p = line.split("\t")
        if len(p) == 7:
            jar[p[5]] = p[6]
    s.cookies.update(jar)
    h = {"X-Request-ID": "kanban"}
    ch = _retry(lambda: s.get("https://bsides.keplerops.com/api/v1/ctf/me/challenges/", headers=h, timeout=30).json())
    ev = _retry(lambda: s.get("https://bsides.keplerops.com/api/v1/ctf/me/event/", headers=h, timeout=30).json())
    (CTF / "challenges.json").write_text(json.dumps(ch, indent=1))
    return ch, ev


def load():
    if "--offline" in sys.argv:
        ch = json.loads((CTF / "challenges.json").read_text())
        ev = None
    else:
        ch, ev = fetch_live()
    det = json.loads((CTF / "details.json").read_text()) if (CTF / "details.json").exists() else {}
    st = json.loads((CTF / "lanes/state.json").read_text()) if (CTF / "lanes/state.json").exists() else {}
    claims = json.loads((CTF / "claims.json").read_text()) if (CTF / "claims.json").exists() else {}
    return ch, ev, det, st, claims


def card(c, extra=None, note=None, lane=None, flag=None, attempts=None):
    d = c["difficulty"]
    tags = "".join(f'<span class="tag">{html.escape(t)}</span>' for t in (c.get("tags") or []))
    meta = f'<span class="pill {d}">{d}</span><span class="pts">{c["points"]}p</span>'
    bits = []
    if lane:
        bits.append(f'<span class="lane">{html.escape(lane)}</span>')
    if attempts:
        bits.append(f'<span class="att">att {attempts}</span>')
    if flag:
        bits.append(f'<code class="flag">{html.escape(flag)}</code>')
    if note:
        bits.append(f'<div class="note">{html.escape(note)}</div>')
    return f"""<div class="card {d}">
  <div class="ch">{html.escape(c['name'])}</div>
  <div class="row">{meta}{tags}</div>
  <div class="row small">{''.join(bits)}</div>
</div>"""


def main():
    ch, ev, det, st, claims = load()
    inprog = st.get("in_progress", {})
    solved_flags = st.get("flags", {})
    notes = st.get("notes", {})
    L = st.get("lanes", {})

    solved = [c for c in ch if c["solved"]]
    unsolved = [c for c in ch if not c["solved"]]
    doing = [c for c in unsolved if c["name"] in claims or c["name"] in inprog]
    rest = [c for c in unsolved if c["name"] not in inprog]
    rest.sort(key=lambda c: (DIFF_RANK.get(c["difficulty"], 9), c["points"], c["order"]))

    def claim_note(name):
        m = claims.get(name)
        if not m:
            return notes.get(name)
        age = max(0, int(__import__("time").time()) - int(m.get("since", 0)))
        return f"claimed by pi lane {m['lane']} · {age // 60}m{age % 60:02d}s"

    def is_chain(nxt, cur):
        """true if nxt is the next-numbered sibling of a card in progress (same chapter)"""
        m1 = re.match(r"([TKW]\d+)\.(\d)", nxt["name"])
        m2 = re.match(r"([TKW]\d+)\.(\d)", cur["name"])
        return bool(m1 and m2 and m1.group(1) == m2.group(1) and int(m1.group(2)) == int(m2.group(2)) + 1)

    upnext, later = [], []
    for c in rest:
        if any(is_chain(c, d) for d in doing):
            upnext.append(c)
        else:
            later.append(c)

    total = len(ch)
    done = len(solved)
    pct = 100.0 * done / total if total else 0
    score = ev["participant"]["cached_score"] if ev else st.get("score", 0)
    rank = (ev or {}).get("participant", {}).get("rank") or st.get("rank", "–")
    lane_rows = "".join(
        f'<div class="lanerow"><b>{html.escape(k)}</b> <span>{html.escape(v.get("what",""))}</span>'
        f'<em>{html.escape(v.get("status",""))}</em></div>'
        for k, v in L.items()
    )
    ts = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    lane_map = {}
    for nm, m in claims.items():
        lane_map.setdefault(m['lane'], []).append(nm)
    unattr = json.loads((CTF / "unattributed.json").read_text()) if (CTF / "unattributed.json").exists() else []
    unattr_html = "".join(
        f'<div class="unattr"><code>{html.escape(u["flag"])}</code>'
        f'<span>{html.escape(u["found"][:120])}</span>'
        f'<em>{html.escape(u["note"][:150])}</em></div>' for u in unattr)
    lane_cards = "".join(
        f'<div class="lanebox"><b>{html.escape(l)}</b>'
        f'<span>{len(v)} card(s)</span>'
        f'<em>{html.escape(", ".join(x.split(":")[0] for x in sorted(v)))}</em></div>'
        for l, v in sorted(lane_map.items()))

    cols = [
        ("in-progress", f"In progress <span class='n'>{len(doing)}</span>",
         "".join(card(c, lane=(claims.get(c["name"]) or inprog.get(c["name"], {})).get("lane"),
                      note=claim_note(c["name"]),
                      attempts=c.get("attempt_count")) for c in doing) or "<p class='empty'>no active lane</p>"),
        ("next", f"Next up <span class='n'>{len(upnext)}</span>",
         "".join(card(c, note=notes.get(c["name"])) for c in upnext) or "<p class='empty'>–</p>"),
        ("backlog", f"Backlog — easy first <span class='n'>{len(later)}</span>",
         "".join(card(c) for c in later[:60]) + (f"<p class='empty'>+{len(later)-60} more</p>" if len(later) > 60 else "")),
        ("solved", f"Exploited <span class='n'>{len(solved)}</span>",
         "".join(card(c, flag=solved_flags.get(c["name"])) for c in solved) or "<p class='empty'>–</p>"),
    ]
    columns = "".join(
        f'<section class="col {cid}"><header>{title}</header><div class="cards">{body}</div></section>'
        for cid, title, body in cols
    )

    OUT.write_text(f"""<!doctype html>
<html lang="en"><head><meta charset="utf-8"><meta http-equiv="refresh" content="20">
<title>BSides CTF 2026 — kanban</title>
<style>
:root{{--bg:#0f1115;--panel:#171a21;--line:#262b36;--fg:#e6e9ef;--dim:#8b94a7;--acc:#5cc8ff;
--easy:#2f9e6b;--medium:#c8a13a;--hard:#d9704b;--expert:#b04ad0;}}
*{{box-sizing:border-box}}
body{{margin:0;background:var(--bg);color:var(--fg);font:14px/1.45 ui-sans-serif,system-ui,-apple-system,Segoe UI,Roboto,sans-serif}}
header.top{{position:static;padding:8px 20px;background:#12151b;border-bottom:1px solid var(--line)}}
h1{{margin:0 0 3px;font-size:14px;letter-spacing:.2px}}
.stats{{display:flex;gap:14px;flex-wrap:wrap;color:var(--dim);font-size:12px;align-items:center}}
.stats b{{color:var(--fg)}}
.bar{{height:6px;background:#20242e;border-radius:99px;overflow:hidden;width:260px}}
.bar i{{display:block;height:100%;background:linear-gradient(90deg,#5cc8ff,#2f9e6b);width:{pct:.1f}%}}
.lanerow{{display:flex;gap:8px;font-size:12px;color:var(--dim);margin-top:4px}}
.lanerow b{{color:var(--acc)}} .lanerow em{{margin-left:auto;color:#6f7a8d;font-style:normal}}
.board{{display:grid;grid-template-columns:repeat(4,minmax(260px,1fr));gap:14px;padding:16px 20px 60px;align-items:start}}
.col header{{font-size:12px;text-transform:uppercase;letter-spacing:.9px;color:var(--dim);
padding:6px 4px;border-bottom:1px solid var(--line);position:sticky;top:0;background:var(--bg);z-index:4}}
.col header .n{{color:var(--fg);background:#20242e;border-radius:99px;padding:1px 7px;margin-left:6px;font-size:11px}}
.cards{{display:flex;flex-direction:column;gap:8px;margin-top:8px}}
.card{{background:var(--panel);border:1px solid var(--line);border-radius:9px;padding:9px 11px;border-left:3px solid var(--line)}}
.card.easy{{border-left-color:var(--easy)}} .card.medium{{border-left-color:var(--medium)}}
.card.hard{{border-left-color:var(--hard)}} .card.expert{{border-left-color:var(--expert)}}
.ch{{font-size:13px;font-weight:600;margin-bottom:6px}}
.row{{display:flex;gap:6px;align-items:center;flex-wrap:wrap}}
.small{{margin-top:6px;color:var(--dim);font-size:11px}}
.pill{{font-size:10px;text-transform:uppercase;letter-spacing:.6px;padding:1px 6px;border-radius:4px;background:#20242e;color:var(--dim)}}
.pill.easy{{color:var(--easy)}} .pill.medium{{color:var(--medium)}} .pill.hard{{color:var(--hard)}} .pill.expert{{color:var(--expert)}}
.pts{{font-size:11px;color:var(--acc)}}
.tag{{font-size:10px;color:var(--dim);border:1px solid var(--line);border-radius:4px;padding:0 5px}}
.lane{{color:#e0b060;font-size:11px;font-weight:600}}
.att{{color:#7d8698;font-size:11px}}
.note{{width:100%;color:#9aa4b6;font-size:11px;margin-top:4px}}
.flag{{font-size:11px;color:#6ee7a8;background:#12241a;border:1px solid #1d4029;border-radius:4px;padding:1px 5px}}
.empty{{color:#5c6474;font-size:12px}}
.col.solved .card{{opacity:.92}}
@media(max-width:1100px){{.board{{grid-template-columns:repeat(2,minmax(240px,1fr))}}}}
</style></head><body>
<header class="top">
 <h1>BSides CTF 2026 — Operation NORTHSTORM · team MoTM</h1>
 <div class="stats">
  <span><b>{done}</b>/{total} flags · <b>{pct:.1f}%</b></span>
  <span class="bar"><i></i></span>
  <span><b>{score}</b> pts</span><span>rank <b>{rank}</b></span>
  <span>{len(doing)} in progress · {len(upnext)+len(later)} to go</span>
  <span>claims: <code>CLAIMS.md</code></span>
  <span style="margin-left:auto">updated {ts} · auto-refresh 20s</span>
 </div>
 {lane_rows}
</header>
<div class="unattr-board"><span class="lb-title">flags found, card unknown</span>{unattr_html or "<span class='empty'>none</span>"}</div>
<div class="lane-board"><span class="lb-title">lanes at work</span>{lane_cards or "<span class='empty'>none</span>"}</div>
<div class="board">{columns}</div>
</body></html>""")
    print(f"wrote {OUT}  ({done}/{total} solved, {len(doing)} in progress)")


if __name__ == "__main__":
    main()
