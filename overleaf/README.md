# LOOM on Overleaf

The root [`loom.cls`](../loom.cls) uses macOS-only fonts (Optima, Avenir Next,
Menlo, Songti/PingFang), so it fails on Overleaf. This folder holds two
Overleaf-ready editions. **Both use the same class name (`\documentclass{loom}`)
and the same command set as the local class** — the same notes source compiles
under either, just by choosing which `loom.cls` you upload. Set the compiler to
**XeLaTeX** (Menu → Compiler → XeLaTeX).

| | [`libertinus/`](libertinus/) | [`classico/`](classico/) |
|---|---|---|
| Display face | Libertinus Sans (humanist) | URW Classico (Optima clone) |
| Body / math | Libertinus Serif / Math *(= original)* | URW Classico (sans) |
| Chinese (`[cjk]`) | Noto CJK SC | Noto CJK SC |
| Fonts to upload | **none** — all bundled with Overleaf | 4 `.otf`, you supply |
| Closest to the macOS original's *look* | body & math match; display differs | ✓ display is an Optima clone |
| Author | new for this repo | contributed by [fn-gn](https://github.com/fn-gn) ([PR #1](https://github.com/Polaris-Aeterna/loom-notes/pull/1)) |

**Most people want [`libertinus/`](libertinus/):** copy `loom.cls` + `main.tex`
into a project, compile, done. Pick [`classico/`](classico/) only if you want
the exact Optima look and don't mind supplying four font files (see
[`classico/fonts/README.md`](classico/fonts/README.md)).

## What `classico/` changes vs `libertinus/`

fn-gn's edition (`classico/`) additionally externalises the cover emblem and the
selvage rail to `loom-emblem.tex` / `loom-rail.tex` (+ the PDFs in `figure/`) for
faster compiles, and adds `\enpunct` (Chinese punctuation → English + space).
Both editions keep every LOOM pedagogy tool (`strand`, `fillin`, `TODO`,
`yourturn`, `warmth`, `loose`, `recall`, `workspace`, the theorem boxes, the
dye-pot palette).
