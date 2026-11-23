#!/usr/bin/env python3
"""Minimal SOCKS5 CONNECT proxy (no auth). Run on rowan-dev bound to
127.0.0.1:13389 (the only port sshd PermitOpen allows), then reach it from the
range box with:  ssh -N -L 1080:127.0.0.1:13389 rowan-dev
and use:         curl --socks5-hostname 127.0.0.1:1080 https://host/
"""
import socket, struct, threading, sys

PORT = int(sys.argv[1]) if len(sys.argv) > 1 else 13389


def pipe(a, b):
    try:
        while True:
            d = a.recv(65536)
            if not d:
                break
            b.sendall(d)
    except Exception:
        pass
    finally:
        try:
            b.shutdown(socket.SHUT_WR)
        except Exception:
            pass


def handle(c):
    try:
        c.settimeout(30)
        h = c.recv(2)
        if len(h) < 2 or h[0:1] != b"\x05":
            return
        n = h[1]
        c.recv(n)
        c.sendall(b"\x05\x00")
        hdr = c.recv(4)
        if len(hdr) < 4:
            return
        atyp = hdr[3]
        if atyp == 1:
            host = socket.inet_ntoa(c.recv(4))
        elif atyp == 3:
            ln = c.recv(1)[0]
            host = c.recv(ln).decode()
        else:
            host = socket.inet_ntop(socket.AF_INET6, c.recv(16))
        port = struct.unpack("!H", c.recv(2))[0]
        try:
            u = socket.create_connection((host, port), timeout=30)
        except Exception:
            c.sendall(b"\x05\x05\x00\x01\x00\x00\x00\x00\x00\x00")
            return
        c.sendall(b"\x05\x00\x00\x01\x00\x00\x00\x00\x00\x00")
        c.settimeout(None)
        u.settimeout(None)
        threading.Thread(target=pipe, args=(c, u), daemon=True).start()
        pipe(u, c)
    except Exception:
        pass
    finally:
        try:
            c.close()
        except Exception:
            pass


def main():
    s = socket.socket()
    s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    s.bind(("127.0.0.1", PORT))
    s.listen(50)
    while True:
        c, _ = s.accept()
        threading.Thread(target=handle, args=(c,), daemon=True).start()


if __name__ == "__main__":
    main()
