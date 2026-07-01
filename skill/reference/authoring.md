# Claude Code instructions — generating Loom fill-in notes

This file is the **entry point** when someone asks you to turn a file in `sources/` into
Loom study notes. Read it top to bottom, then read
[`spine-analysis.md`](spine-analysis.md) before writing anything.

> **Golden rule.** Notes are **70% readable, 30% to fill**, organized **around one spine**,
> never a section-by-section transcript of the source. The source is the answer key.

---

## 0. The job, in one paragraph

The user drops a `.md` / `.txt` / `.pdf` in `sources/` and names it — *without* telling you the
organizing idea. You (1) read it, (2) auto-identify the **spine** (the single most powerful
organizing idea), (3) reorganize the material around that spine, and (4) write a complete,
compilable Loom notebook into `output/<notebook-name>/` with the five files in §4. Then compile
and verify (§6).

---

## 1. Document skeleton

Every `main.tex` looks like this:

```latex
\documentclass{loom}              % add [cjk] if the NOTES contain Chinese; [letter] for US Letter
\runningthread{short spine phrase}  % quiet footer label, lowercase
\begin{document}

\loomcover{Title}{Spine subtitle — the one idea}{Author}{Date}

\section*{The one idea, and how to read}
  \begin{strand} ... one paragraph naming the spine ... \end{strand}
  \block{The master table}
    % a tabularx cheat-sheet that IS the spine, with a few \fillin blanks
\clearpage
\tableofcontents
\clearpage

\input{sections/01-...}    % OR inline the sections directly; both are fine
\input{sections/02-...}

\end{document}
```

Small notebooks may keep all sections inline in `main.tex`; larger ones split into
`sections/NN-*.tex` and `\input` them. Either is acceptable.

---

## 2. The Loom grammar — the working set

Full command reference: [`loom-commands.md`](loom-commands.md). Day to day you need:

- **Cover & structure:** `\loomcover{title}{subtitle = the spine}{author}{date}` (turns on the
  rail), `\runningthread{footer}`, `\section`/`\subsection`, `\block{quiet sub-heading}`,
  `\trigger{reach for this when…}`.
- **Knots (auto-colored):** `theorem`/`lemma`/`proposition`/`corollary` (**indigo** — state in
  full), `definition` (**madder** — blank one clause), `example` (**weld** — a worked instance),
  `remark`, and `proof … \TODO{…}` (ships as a skeleton). Put the source location in the optional
  bracket — e.g. `\begin{theorem}[Erdős–Szekeres; src §5]` — so the learner can find the answer key.
- **Intuition voice:** `strand` env (the big idea, read-only), `\whisper{…}`, `\keyword{…}`.
- **Selvage & gauges:** `\warmth{0..5}` (top of each section), `\loose{open thread}`,
  `\warp{key}` / `\pick{key}` (declare then reuse a recurring object).

### The five fill-in devices (this is the 30%)
| device | blanks out | example |
|---|---|---|
| `\fillin[width]` | a defining clause / punchline number | `some box holds \fillin[1.4cm] objects` |
| `\TODO{hint}` | the keystone step of a proof | `\TODO{the contradiction: assume every box has \le 1}` |
| `yourturn` env | a worked computation, restaged | wrap an example for the reader to do |
| `\workspace[n]` | n ruled lines to write on | put inside `yourturn` |
| `\recall{question}` | a margin active-recall prompt | `\recall{Why is \(\lceil n/k\rceil\) sharp?}` |

---

## 3. The 70/30 ratio — what to blank

Read [`method.md`](method.md). In short:

**Leave readable (≈70%):** motivation/intuition (`strand`), full theorem statements, the
*shape* of a proof (named steps), the cheat-table scaffolding.

**Blank out (≈30%):** the one keystone step of a proof (`\TODO`), a defining clause of a
definition (`\fillin`), the computation in an example (`yourturn`), the punchline number
(`\fillin`), the row the section is teaching.

Put gaps at high-value thinking points, never so dense that reading breaks.

---

## 4. Output contract — `output/<notebook-name>/`

`<notebook-name>` = a short kebab-case slug from the topic (e.g. `pigeonhole-principle`).
Write **exactly these files**:

1. **`main.tex`** — the notebook (§1–§3).
2. **`metadata.json`** — the spine analysis. Schema:
   ```json
   {
     "notebook": "pigeonhole-principle",
     "source": "sources/pigeonhole.md",
     "generated": "2026-06-28",
     "spine": {
       "spine": "One-sentence organizing idea.",
       "pattern": "single-theorem | engine-list | binary-opposition | organizing-dictionary | linear-narrative",
       "confidence": 0.0,
       "reasoning": "Why this spine wins on coverage, predictive power, teaching impact.",
       "key_concepts": ["...", "..."],
       "section_order": ["Reordered section 1", "Reordered section 2"]
     },
     "ratio": { "readable": 0.70, "fillable": 0.30 }
   }
   ```
   `confidence` follows the rubric in [`spine-analysis.md`](spine-analysis.md).
   `section_order` is your **reorganized** order, not the source's.
3. **`compile.sh`** — see template below.
4. **`compile.ps1`** — PowerShell sibling (for Windows users).
5. **`loom.cls`** — a **copy** of the repo-root `loom.cls` (self-contained build).

`compile.sh`:
```bash
#!/usr/bin/env bash
set -e
cd "$(dirname "$0")"
latexmk -xelatex -interaction=nonstopmode -file-line-error main.tex
# fallback if latexmk is absent: xelatex main.tex && xelatex main.tex
```
`compile.ps1`:
```powershell
Set-Location $PSScriptRoot
latexmk -xelatex -interaction=nonstopmode -file-line-error main.tex
```

---

## 5. XeLaTeX / unicode-math pitfalls — verify before compiling

Full list: [`pitfalls.md`](pitfalls.md) — read it before compiling. The three that *will* bite
every time:

- **Engine: XeLaTeX only.** `latexmk -xelatex` or `xelatex` **twice** (the selvage rail uses
  `remember picture`; TOC/`\ref` resolve on the second pass). Never pdflatex.
- **Brace macros under scripts/accents:** write `_{\R}` not `_\R`, `\widehat{\E}` not `\widehat\E`.
- **Do NOT load `amssymb`** — unicode-math already supplies the glyphs (throws
  `\eth already defined`). The class loads only `amsmath, mathtools`.

Everything else — arrow glyphs in headings, multiple `\fillin` on one line, wide-table columns,
colliding margin notes, the macOS-font swap for other platforms — is in [`pitfalls.md`](pitfalls.md).

---

## 6. Compile & verify (don't declare done until you've looked)

```bash
cd output/<notebook-name>
bash compile.sh                       # or: latexmk -xelatex -interaction=nonstopmode main.tex
```
Then check the log is clean and **look at the PDF**:
```bash
grep -cE 'Overfull \\hbox \([0-9]{2,}\.' main.log   # aim ~0 large boxes
grep -c 'Font shape .* undefined' main.log          # ≤1 (the benign cover sc fallback)
pdftoppm -png -r 130 -f 2 -l 2 main.pdf p            # poppler; -> p-2.png (pdftocairo also works)
```
The page should show: woven cover + spine subtitle, the left selvage rail, indigo/madder/weld
knots, visible `\fillin`/`\TODO`/`yourturn`, margin `\warmth`/`\recall`, and structure that
follows the spine — not the source's section order.

## 7. Honest scoping
The notes restate results from the source — fine for personal study. Before publishing notes
that closely track a **copyrighted** book, attribute clearly and prefer an original example.
Keep the source's numbering in each knot title so the learner can check the answer key.
