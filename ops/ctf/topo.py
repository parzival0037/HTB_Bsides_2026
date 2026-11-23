import socket, concurrent.futures

PORTS = [22, 80, 443, 3000, 4840, 5432, 8080, 8081, 8082, 8083, 8443, 8701, 9090, 6443]


def probe(hp):
    h, p = hp
    s = socket.socket()
    s.settimeout(0.4)
    try:
        if s.connect_ex((h, p)) == 0:
            return (h, p)
    except Exception:
        pass
    finally:
        s.close()
    return None


hosts = ([f"10.77.50.{i}" for i in range(10, 45)]
         + [f"10.77.51.{i}" for i in range(10, 80)]
         + [f"10.77.60.{i}" for i in range(1, 30)]
         + [f"10.50.13.{i}" for i in range(175, 185)])
res = {}
with concurrent.futures.ThreadPoolExecutor(200) as ex:
    for r in ex.map(probe, [(h, p) for h in hosts for p in PORTS]):
        if r:
            res.setdefault(r[0], []).append(r[1])
for h in sorted(res):
    print(h, sorted(res[h]), flush=True)
