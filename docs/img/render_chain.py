#!/usr/bin/env python3
"""Render the per-challenge attack-chain diagram (matplotlib).

Graphviz 2.42's spline router fails on these label widths ("cannot realloc pnls"),
so chain diagrams are drawn directly instead.
"""
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from matplotlib.patches import FancyBboxPatch, FancyArrowPatch

BG, BOX, EDGE = "#ffffff", "#f6f8fb", "#54606e"
BLUE, YEL, GRN, RED, DARK = "#e6edfb", "#fff2cc", "#dff3e4", "#fbe3e3", "#1c2530"

STEPS = [
    ("1  GET /api/service-directory\nleaks archive_subject + enrollment_worker token", BLUE),
    ("2  GET /api/archive/handovers/self\n401 client_cert_required — header spoofing ignored", BOX),
    ("3  GET /api/enrollment/StaffArchiveUser\neku=clientAuth · subject_format={subject}", BOX),
    ('4  POST …/requests  {"upn": victim}\nreturns certificate_pem + private_key_pem', YEL),
    ("5  GET /api/archive/handovers/{upn}\nmTLS with --cert/--key", YEL),
    ("6  flag in response: FLAG{e47f6aa72d8045aa}", GRN),
]
SIDE = {2: ("422 invalid_upn\nonly the shape is checked", RED),
        4: ("403 subject_mismatch\n404 handover_not_found", RED)}


def box(ax, x, y, w, h, text, fc=BOX, fs=9.5):
    ax.add_patch(FancyBboxPatch((x - w / 2, y - h / 2), w, h,
                                boxstyle="round,pad=0.012,rounding_size=0.02",
                                linewidth=1.2, edgecolor=EDGE, facecolor=fc))
    ax.text(x, y, text, ha="center", va="center", fontsize=fs, color=DARK, linespacing=1.45)


def arrow(ax, p1, p2, color=EDGE, ls="-", lw=1.4):
    ax.add_patch(FancyArrowPatch(p1, p2, arrowstyle="-|>", mutation_scale=13,
                                 color=color, lw=lw, linestyle=ls, shrinkA=2, shrinkB=3))


def main():
    fig, ax = plt.subplots(figsize=(9.6, 7.8), dpi=170)
    ax.set_xlim(0, 1); ax.set_ylim(0, 1); ax.axis("off")
    ax.set_title("K19.2 — attack chain: enrolment breaks the identity boundary",
                 fontsize=11.5, color=DARK, pad=10)
    ys = [0.905 - i * 0.153 for i in range(len(STEPS))]
    for (text, fc), y in zip(STEPS, ys):
        box(ax, 0.40, y, 0.60, 0.108, text, fc)
    for i in range(len(STEPS) - 1):
        arrow(ax, (0.40, ys[i] - 0.054), (0.40, ys[i + 1] + 0.054))
    for i, (text, fc) in SIDE.items():
        box(ax, 0.855, ys[i], 0.23, 0.095, text, fc, fs=8.4)
        arrow(ax, (0.70, ys[i]), (0.74, ys[i]), color="#b03a3a", ls="--", lw=1.2)
    fig.savefig("k19-2-chain.png", bbox_inches="tight", facecolor=BG)
    print("wrote k19-2-chain.png")


if __name__ == "__main__":
    main()
