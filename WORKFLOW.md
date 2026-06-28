# Workflow — from a source file to finished Loom notes

Loom turns raw study material into **fill-in study notes**: written to be *read* (70%), engineered
to be *filled* (30%), and organized around one **spine** that you never have to choose yourself.

```
  sources/X.md   ──►   Claude Code      ──►   output/<name>/        ──►   you compile
  (you drop it)        auto-finds spine        main.tex + metadata        & review the PDF
                       & generates notes        compile.sh / .ps1
```

---

## Step 1 — Place a source

Put a `.md`, `.txt`, or `.pdf` in [`sources/`](sources/). One topic per file works best.
You do **not** specify the organizing idea.

## Step 2 — Ask Claude Code (no spine needed)

> Make Loom notes from `sources/pigeonhole.md`.

Claude Code then:
1. Reads the source and **auto-identifies the spine** — the single most powerful organizing idea
   — using [`SPINE-ANALYSIS-GUIDE.md`](SPINE-ANALYSIS-GUIDE.md) (examines title, structure, core
   concepts, thematic links; picks highest coverage + predictive power + teaching impact).
2. **Reorganizes** the material around that spine (not a section-by-section transcript).
3. Generates a complete notebook in `output/<notebook-name>/`, following
   [`.claude-instructions.md`](.claude-instructions.md) and the 70/30 rule.

It records its spine analysis in `metadata.json` so you can see *why* it chose that shape:

```json
{
  "spine": {
    "spine": "Choose the boxes, then count.",
    "pattern": "single-theorem",
    "confidence": 0.9,
    "reasoning": "Every section is the principle, sharpened or applied; ...",
    "key_concepts": ["pigeonhole principle", "ceil(n/k)", "Ramsey R(3,3)", "Erdős–Szekeres"],
    "section_order": ["The one idea", "Simple form", "Strong form", "Applications"]
  }
}
```

## Step 3 — What you get in `output/<notebook-name>/`

| file | what it is |
|---|---|
| `main.tex` | the notebook — XeLaTeX, spine-first, 70% read / 30% fill |
| `metadata.json` | the spine analysis (idea, pattern, confidence, reasoning, concepts, order) |
| `compile.sh` | one-command build (bash / Git Bash) |
| `compile.ps1` | one-command build (PowerShell — primary shell on Windows) |
| `loom.cls` | a copy of the class, so the folder builds on its own |

## Step 4 — Compile

From the notebook folder:

```bash
# Git Bash / macOS / Linux
bash compile.sh
```
```powershell
# Windows PowerShell
./compile.ps1
```
Either runs `latexmk -xelatex` (which runs XeLaTeX the needed two passes). Requires a TeX
distribution with XeLaTeX (e.g. TeX Live). Fonts are **cross-platform**: macOS uses
Optima/Avenir, other systems fall back automatically (Lato/Gillius/Libertinus; SimSun/KaiTi/YaHei
for Chinese) — no setup.

## Step 5 — Review the PDF

A good `main.pdf` shows:

- [ ] a **woven cover** with the **spine** as the subtitle
- [ ] the **left selvage rail** on every page
- [ ] **colored knots** — indigo theorems, madder definitions, weld examples
- [ ] visible **`\fillin` blanks**, **`\TODO` hints**, **`yourturn` boxes** with `\workspace` lines
- [ ] **margin notes** — `\warmth` gauges and `\recall` prompts
- [ ] structure that follows **the spine**, not the source's section order

Read it back. If the gaps are in the wrong places or the spine feels weak, tell Claude Code what
to change — e.g. "blank the keystone step in the strong-form proof instead" or "the spine should
be the algebra↔geometry dictionary."

---

## Reference
- [`.claude-instructions.md`](.claude-instructions.md) — full Loom syntax + XeLaTeX pitfalls.
- [`SPINE-ANALYSIS-GUIDE.md`](SPINE-ANALYSIS-GUIDE.md) — how the spine is chosen.
- [`skill/reference/`](skill/reference/) — method (70/30), command reference, pitfalls in depth.
- [`examples/`](examples/) — seven worked notebooks in different spine styles.
