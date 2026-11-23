#!/usr/bin/env python3
"""Run commands on the CTF range box over the platform's WebSocket SSH terminal.

Usage:
  ./box.py 'id; uname -a'            # run a command, print output
  ./box.py -f script.sh              # run a local script (uploaded via base64 heredoc)
  ./box.py -t 60 'longcmd'           # custom timeout seconds
"""
import sys, json, time, asyncio, base64, argparse, http.cookiejar, pathlib, re

import websockets
import requests

ANSI = re.compile(r"\x1b\[[0-9;?]*[a-zA-Z]|\x1b\][^\x07\x1b]*(?:\x07|\x1b\\)|\r")

HOST = "bsides.keplerops.com"
BASE = f"https://{HOST}"
INSTANCE = "provision.node.training-host#0"
COOKIES = pathlib.Path("/home/kali/ctf/cookies.txt")


def ws_url():
    return f"wss://{HOST}/ws/terminal/{requests.utils.quote(INSTANCE, safe='')}/"


def cookie_header():
    jar = http.cookiejar.MozillaCookieJar(str(COOKIES))
    jar.load(ignore_discard=True, ignore_expires=True)
    return "; ".join(f"{c.name}={c.value}" for c in jar if c.domain.endswith("keplerops.com") or c.domain == HOST)


async def _connect(hdr):
    last = None
    for attempt in range(4):
        try:
            return await websockets.connect(ws_url(), additional_headers=hdr, open_timeout=20,
                                             max_size=4 * 1024 * 1024)
        except Exception as e:  # transient DNS / proxy hiccups on this workstation
            last = e
            await asyncio.sleep(2 + attempt * 2)
    raise last


async def run(command, timeout=45, tail=None):
    hdr = {"Cookie": cookie_header(), "Origin": BASE}
    # literal contains a shell substitution so the typed echo never matches the sentinel
    marker_lit = f"DONEMARK_{int(time.time()*1000)}$((6*7))"
    marker = marker_lit.split("$")[0] + "42"
    async with await _connect(hdr) as ws:
        await ws.send(json.dumps({"type": "resize", "cols": 200, "rows": 50}))
        # wake the pty
        await ws.send(json.dumps({"type": "input", "data": "\n"}))
        await asyncio.sleep(0.8)
        buf = []
        # drain banner
        try:
            while True:
                raw = await asyncio.wait_for(ws.recv(), timeout=1.0)
                msg = json.loads(raw)
                if msg.get("type") == "output":
                    buf.append(msg.get("data", ""))
        except asyncio.TimeoutError:
            pass
        buf = []
        payload = command.rstrip("\n") + f"; echo {marker_lit}\n"
        await ws.send(json.dumps({"type": "input", "data": payload}))
        deadline = time.time() + timeout
        while time.time() < deadline:
            try:
                raw = await asyncio.wait_for(ws.recv(), timeout=2.0)
            except asyncio.TimeoutError:
                continue
            try:
                msg = json.loads(raw)
            except json.JSONDecodeError:
                continue
            if msg.get("type") == "output":
                buf.append(msg.get("data", ""))
                if marker in "".join(buf):
                    break
        text = "".join(buf)
        text = text.split(marker)[0]
        # drop the echoed command line and ANSI noise
        text = ANSI.sub("", text)
        return text


def upload_and_run(local_path, timeout=120):
    data = pathlib.Path(local_path).read_bytes()
    b64 = base64.b64encode(data).decode()
    remote = "/tmp/" + pathlib.Path(local_path).name
    cmd = f"base64 -d > {remote} <<'B64EOF'\n{b64}\nB64EOF\nchmod +x {remote}; bash {remote}"
    return asyncio.run(run(cmd, timeout=timeout))


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("-f", "--file")
    ap.add_argument("-t", "--timeout", type=int, default=45)
    ap.add_argument("command", nargs="*")
    a = ap.parse_args()
    if a.file:
        out = upload_and_run(a.file, timeout=max(a.timeout, 120))
    else:
        out = asyncio.run(run(" ".join(a.command), timeout=a.timeout))
    sys.stdout.write(out)
    if not out.endswith("\n"):
        sys.stdout.write("\n")


if __name__ == "__main__":
    main()
