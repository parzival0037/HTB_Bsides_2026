# Diagram sources

Rendered from Graphviz / Matplotlib, committed as PNG (GitHub-safe) and SVG.

| File | Shows |
|---|---|
| `segments.png` | the three network segments, every host and its ports |
| `access-path.png` | operator access chain: terminal → kali → rowan-dev → SOCKS relay → 10.77.x, and the ARWC denial |
| `k19-2-chain.png` | per-challenge attack chain example (K19.2 certificate enrolment) |

Regenerate:

```bash
dot -Tpng -Gdpi=150 segments.dot -o segments.png
dot -Tpng -Gdpi=150 access-path.dot -o access-path.png
python3 render_chain.py        # the matplotlib one, avoids graphviz spline bugs
```
