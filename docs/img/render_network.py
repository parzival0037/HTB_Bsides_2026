#!/usr/bin/env python3
"""Render the range diagrams with small machine icons.

Graphviz 2.42's spline router silently drops arrows on these layouts, so both
diagrams are drawn directly with matplotlib. Icons are simple vector glyphs so
the picture reads at a glance:

    monitor  = workstation / service host
    server   = multi-service fabric
    cloud    = event plane (internet)
    relay    = SOCKS relay / pivot
    key      = KDC
    lock     = a boundary that refuses you
"""
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from matplotlib.patches import FancyBboxPatch, FancyArrowPatch, Rectangle, Circle, Polygon, Ellipse

BG, INK, EDGE = "#ffffff", "#1c2530", "#54606e"
BLUE, GRN, YEL, RED, PUR, GREY = "#e6edfb", "#dff3e4", "#fff2cc", "#fbe3e3", "#efe6f8", "#f2f4f7"


def icon_monitor(ax, x, y, s=0.030, face=BLUE):
    """small workstation glyph: screen + stand"""
    w, h = s * 1.55, s
    ax.add_patch(Rectangle((x - w / 2, y - h / 2 + s * 0.28), w, h, linewidth=1.2,
                           edgecolor=EDGE, facecolor=face, zorder=3))
    ax.add_patch(Rectangle((x - w * 0.18, y - h / 2 + s * 0.10), w * 0.36, s * 0.18,
                           linewidth=0, facecolor=EDGE, zorder=3))
    ax.plot([x - w * 0.32, x + w * 0.32], [y - h / 2 + s * 0.06] * 2, color=EDGE, lw=1.6, zorder=3)


def icon_server(ax, x, y, s=0.030, face=BLUE):
    for i in range(3):
        ax.add_patch(Rectangle((x - s * 0.85, y - s * 0.60 + i * s * 0.46), s * 1.7, s * 0.36,
                               linewidth=1.1, edgecolor=EDGE, facecolor=face, zorder=3))


def icon_cloud(ax, x, y, s=0.030, face=BLUE):
    for dx, dy, r in ((0, 0, 1.0), (-0.75, -0.15, 0.7), (0.75, -0.12, 0.72)):
        ax.add_patch(Ellipse((x + dx * s * 0.9, y + dy * s), s * 1.9 * r, s * 1.25 * r,
                             linewidth=0, facecolor=face, zorder=3))
        ax.add_patch(Ellipse((x + dx * s * 0.9, y + dy * s), s * 1.9 * r, s * 1.25 * r,
                             linewidth=1.0, edgecolor=EDGE, facecolor="none", zorder=4))


def icon_relay(ax, x, y, s=0.030, face=YEL):
    ax.add_patch(Rectangle((x - s * 0.8, y - s * 0.32), s * 1.6, s * 0.64, linewidth=1.2,
                           edgecolor=EDGE, facecolor=face, zorder=3))
    for i in (-1, 0, 1):
        ax.add_patch(Circle((x + i * s * 0.42, y), s * 0.09, linewidth=0, facecolor=EDGE, zorder=4))


def icon_key(ax, x, y, s=0.030, face=PUR):
    ax.add_patch(Circle((x - s * 0.42, y), s * 0.30, linewidth=1.2, edgecolor=EDGE, facecolor=face, zorder=3))
    ax.add_patch(Rectangle((x - s * 0.16, y - s * 0.09), s * 0.72, s * 0.18, linewidth=1.0,
                           edgecolor=EDGE, facecolor=face, zorder=3))
    ax.add_patch(Rectangle((x + s * 0.34, y - s * 0.30), s * 0.13, s * 0.21, linewidth=0, facecolor=EDGE, zorder=4))


def icon_lock(ax, x, y, s=0.022, face=RED):
    ax.add_patch(FancyBboxPatch((x - s * 0.55, y - s * 0.45), s * 1.1, s * 0.85,
                                boxstyle="round,pad=0.004,rounding_size=0.012",
                                linewidth=1.2, edgecolor=EDGE, facecolor=face, zorder=3))
    ax.add_patch(Arc = None) if False else None
    from matplotlib.patches import Arc
    ax.add_patch(Arc((x, y + s * 0.42), s * 0.78, s * 0.78, theta1=0, theta2=180,
                     linewidth=1.4, edgecolor=EDGE, zorder=3))


def node(ax, x, y, w, h, title, lines, kind="monitor", face=GREY, fs=8.6, icon_s=0.026):
    ax.add_patch(FancyBboxPatch((x - w / 2, y - h / 2), w, h,
                                boxstyle="round,pad=0.006,rounding_size=0.012",
                                linewidth=1.1, edgecolor=EDGE, facecolor=face, zorder=2))
    ix = x - w / 2 + icon_s * 1.7
    iy = y + h * 0.22
    {"monitor": icon_monitor, "server": icon_server, "cloud": icon_cloud,
     "relay": icon_relay, "key": icon_key, "lock": icon_lock}[kind](ax, ix, iy, icon_s, face)
    tx = x - w / 2 + icon_s * 3.2
    ax.text(tx, y + h / 2 - h * 0.16, title, ha="left", va="center",
            fontsize=fs + 0.6, color=INK, fontweight="bold", zorder=5)
    if lines:
        step = h * 0.24
        y0 = y + h / 2 - h * 0.40
        for i, line in enumerate(lines):
            ax.text(tx, y0 - i * step, line, ha="left", va="center",
                    fontsize=fs, color=INK, zorder=5)


def arrow(ax, p1, p2, color=EDGE, label=None, ls="-", lw=1.5, lx=None, ly=None, fs=8.2):
    ax.add_patch(FancyArrowPatch(p1, p2, arrowstyle="-|>", mutation_scale=14, color=color,
                                 lw=lw, linestyle=ls, shrinkA=3, shrinkB=4, zorder=1))
    if label:
        mx = lx if lx is not None else (p1[0] + p2[0]) / 2
        my = ly if ly is not None else (p1[1] + p2[1]) / 2
        ax.text(mx, my, label, ha="center", va="center", fontsize=fs, color=color, zorder=6,
                bbox=dict(boxstyle="round,pad=0.22", fc=BG, ec="none"))


def band(ax, x0, y0, x1, y1, label, color=EDGE):
    ax.add_patch(FancyBboxPatch((x0, y0), x1 - x0, y1 - y0,
                                boxstyle="round,pad=0.004,rounding_size=0.015",
                                linewidth=1.1, linestyle=(0, (4, 3)), edgecolor=color,
                                facecolor="none", zorder=0))
    ax.text(x0 + 0.006, y1 + 0.012, label, ha="left", va="bottom", fontsize=9.2, color=EDGE)


def save(fig, name):
    fig.savefig(name, bbox_inches="tight", facecolor=BG, dpi=170)
    plt.close(fig)
    print("wrote", name)


# ---------------------------------------------------------------- segments
def segments():
    fig, ax = plt.subplots(figsize=(12.6, 8.0), dpi=170)
    ax.set_xlim(0, 1); ax.set_ylim(0, 1); ax.axis("off")
    ax.set_title("Operation NORTHSTORM — range segments, hosts and services", fontsize=12.5, color=INK, pad=10)

    band(ax, 0.015, 0.625, 0.985, 0.945, "10.77.40.0/24 · operator + training desks")
    node(ax, 0.135, 0.795, 0.215, 0.115, "kali 10.77.40.10",
         ["user cinder", "passwordless sudo"], "monitor", GRN, 8.3)
    node(ax, 0.615, 0.795, 0.70, 0.115, "training desks   HTTP 8080-8083", [
        "workbench 10.77.40.20   git :8080 · dispatch :8081 · courier :8082 · diagnostics :8083",
        "accounts 10.77.40.30   identity :8080        developer 10.77.40.40   artifacts :8080",
        "state 10.77.40.50   outlet / SCADA :8080"], "monitor", GREY, 8.3)

    band(ax, 0.015, 0.225, 0.985, 0.585, "10.77.50.0/24 + 10.77.51.0/24 · KeplerOps")
    node(ax, 0.135, 0.485, 0.215, 0.115, "rowan-dev", [
        "10.50.13.180 :2222", "10.77.50.20 · rowan", "RDP 3389 · helper :8701"], "monitor", YEL, 8.3)
    node(ax, 0.455, 0.485, 0.335, 0.115, "service fabric 10.77.50.11", [
        ":443  objects staff support assistant", "llm workboard identity ca cert tickets",
        ":5432 data    :6443 cloud-api"], "server", BLUE, 8.3)
    node(ax, 0.825, 0.485, 0.31, 0.115, "10.77.51.0/24", [
        ".20 gitea   .30 registry", ".40 jenkins   .41 review", ".50 preview   .70 indexer"], "server", BLUE, 8.3)

    node(ax, 0.135, 0.315, 0.215, 0.085, "KDC 10.77.50.40:88", ["realm KEPLEROPS.TEST"], "key", PUR, 8.3)
    node(ax, 0.455, 0.315, 0.335, 0.085, "delivery.keplerops.test :8443",
         ["inspections · releases · package meta"], "server", BLUE, 8.3)
    node(ax, 0.825, 0.315, 0.31, 0.085, "SOCKS relay 127.0.0.1:13389",
         ["the only PermitOpen port"], "relay", YEL, 8.3)

    band(ax, 0.015, 0.02, 0.985, 0.175, "10.77.60.0/24 · ARWC (customer / OT)")
    node(ax, 0.335, 0.095, 0.60, 0.095, "connector.arwc.test  10.77.60.20", [
        ":443 FieldKest-Customer-Relay · :22 sshd · five real routes"], "monitor", RED, 8.3)
    node(ax, 0.825, 0.095, 0.31, 0.095, "channel identity required", [
        "every staff credential is refused"], "lock", RED, 8.0)

    arrow(ax, (0.135, 0.735), (0.135, 0.545), label="ssh :2222 (key)", color="#b5651d", lx=0.245, ly=0.64)
    arrow(ax, (0.245, 0.485), (0.285, 0.485), label="socks5h", color="#b5651d", lx=0.268, ly=0.512)
    arrow(ax, (0.625, 0.485), (0.668, 0.485))
    arrow(ax, (0.455, 0.428), (0.455, 0.360))
    arrow(ax, (0.135, 0.428), (0.135, 0.360), label="kinit", ls=":", lx=0.185, ly=0.394)
    arrow(ax, (0.825, 0.428), (0.825, 0.360))
    arrow(ax, (0.825, 0.272), (0.640, 0.145), label="denied  403 channel_identity_denied",
          color="#b03a3a", lw=1.9, lx=0.70, ly=0.255)
    save(fig, "segments.png")


# ------------------------------------------------------------ access path
def access_path():
    fig, ax = plt.subplots(figsize=(14.0, 5.2), dpi=170)
    ax.set_xlim(0, 1); ax.set_ylim(0, 1); ax.axis("off")
    ax.set_title("Access path — browser terminal → kali → rowan-dev → relay → estate",
                 fontsize=12, color=INK, pad=8)

    steps = [
        ("event plane", ["bsides.keplerops.com", "/api/v1", "wss /ws/terminal"], "cloud", BLUE),
        ("kali", ["10.77.40.10", "user cinder", "box.py drives the pty"], "monitor", GRN),
        ("rowan-dev", ["10.50.13.180:2222", "ssh key", "AllowTcpForwarding local"], "monitor", YEL),
        ("SOCKS relay", ["127.0.0.1:13389", "only PermitOpen port", "ssh -L 1080"], "relay", YEL),
        ("10.77.x estate", ["staff · gitea · jenkins", "review · delivery", "registry · indexer"], "server", BLUE),
    ]
    width, gap = 0.160, 0.032
    xs = [0.03 + width / 2 + i * (width + gap) for i in range(5)]
    top, bot = 0.78, 0.24
    for (title, lines, kind, face), x in zip(steps, xs):
        ax.add_patch(FancyBboxPatch((x - width / 2, bot), width, top - bot,
                                    boxstyle="round,pad=0.006,rounding_size=0.012",
                                    linewidth=1.1, edgecolor=EDGE, facecolor=face, zorder=2))
        {"monitor": icon_monitor, "server": icon_server, "cloud": icon_cloud,
         "relay": icon_relay}[kind](ax, x, top - 0.085, 0.030, "#ffffff")
        ax.text(x, top - 0.165, title, ha="center", va="center", fontsize=9.2,
                color=INK, fontweight="bold", zorder=5)
        for i, line in enumerate(lines):
            ax.text(x, top - 0.255 - i * 0.085, line, ha="center", va="center",
                    fontsize=8.0, color=INK, zorder=5)

    labels = ["JSON frames", "ssh", "runs / -L", "socks5h"]
    for i in range(4):
        arrow(ax, (xs[i] + width / 2, 0.51), (xs[i + 1] - width / 2, 0.51),
              label=labels[i], ly=0.565, fs=7.6)

    bx, by, bw, bh = 0.845, 0.10, 0.29, 0.13
    ax.add_patch(FancyBboxPatch((bx - bw / 2, by - bh / 2), bw, bh,
                                boxstyle="round,pad=0.006,rounding_size=0.012",
                                linewidth=1.1, edgecolor=EDGE, facecolor=RED, zorder=2))
    icon_lock(ax, bx - bw / 2 + 0.035, by, 0.024, RED)
    ax.text(bx + 0.02, by + 0.028, "ARWC relay", ha="center", va="center", fontsize=8.6,
            color=INK, fontweight="bold", zorder=5)
    ax.text(bx + 0.02, by - 0.020, "403 channel_identity_denied", ha="center", va="center",
            fontsize=7.8, color=INK, zorder=5)
    arrow(ax, (xs[3], bot), (bx - 0.10, by + bh / 2), label="staff creds refused",
          color="#b03a3a", lw=1.8, lx=0.60, ly=0.155, fs=7.8)
    save(fig, "access-path.png")


if __name__ == "__main__":
    segments()
    access_path()
