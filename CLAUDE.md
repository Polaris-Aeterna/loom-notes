# CLAUDE.md — operating harness for the Loom repo

This file is the entry point for any Claude Code session working here. Read it first.
It is a **router + fast-path**: enough to do the main job without asking, with pointers to the
deep guides for anything beyond the common case.

## What this repo is

**Loom** is a woven XeLaTeX document class (`loom.cls`) plus an AI workflow for producing
**fill-in study notes** — notes written to be *read* (statements + intuition) yet engineered to
be *filled* (blanks, proof skeletons, "your turn" computations), so the learner studies by active
recall. The repo also runs an automated pipeline: drop a source in `sources/`, and an agent
generates a complete, compilable notebook under `output/<notebook>/`.

> **Golden rule.** Notes are **~70% readable / ~30% to fill**, organized **around one spine**
> (a single organizing idea), **never a section-by-section transcript** of the source. The source
> is the answer key.

## Repo map — know what each kind of file is

| path | kind | tracked? | rule |
|---|---|---|---|
| `sources/` | **source inputs** (`.md/.txt/.pdf`) you convert | yes | read-only inputs; one topic per file |
| `output/<name>/` | **generated notebooks** (the contract, below) | yes — except built PDFs | what you produce |
| `loom.cls` (root) | the document class (canonical) | yes | edit here; re-sync copies (see below) |
| `examples/*/` | **committed reference notebooks** + their `main.pdf` | yes | study for style; do **not** clobber their PDFs |
| `template/` | blank starter + live cheat-sheet (`main.tex`, `main.pdf`) | yes | do **not** clobber `template/main.pdf` |
| `gallery/*.png` | screenshots for the README | yes | committed on purpose |
| `skill/` | the `fill-in-notes` Claude skill + deep references | yes | the authoritative method/pitfalls |
| `*.aux *.log *.fls *.fdb_latexmk *.xdv *.toc *.out *.synctex.gz`, `missfont.log` | **build artifacts** | no (`.gitignore`) | transient; never commit |
| guides: `.claude-instructions.md`, `SPINE-ANALYSIS-GUIDE.md`, `WORKFLOW.md` | docs | yes | route to these for depth |

## Primary workflow: source → notebook

1. **Read** the named source in `sources/`.
2. **Find the spine** — the single most powerful organizing idea (highest *coverage*, *predictive
   power*, *teaching impact*). Pick its pattern and a 0–1 confidence. → `SPINE-ANALYSIS-GUIDE.md`.
3. **Reorganize** the material around that spine; do not transcribe the source order.
4. **Write** `output/<kebab-name>/` with the syntax + 70/30 rules in `.claude-instructions.md`.
5. **Compile and verify** (below). Look at the PDF before declaring done.

You do **not** need to ask the user for the spine — that is the job.

### Output contract — `output/<kebab-name>/` contains exactly:

- `main.tex` — `\documentclass{loom}` (add `[cjk]` only if the **notes** contain Chinese), woven
  cover with the **spine as subtitle**, spine on the front page (a cheat-table/map, partly blank),
  then spine-ordered sections. Cite each source location in the knot title.
- `metadata.json` — the spine analysis: `spine`, `pattern`
  (`single-theorem | engine-list | binary-opposition | organizing-dictionary | linear-narrative`),
  `confidence` (0–1), `reasoning`, `key_concepts`, `section_order`, `ratio`. Full schema:
  `.claude-instructions.md` §4. Working example: `output/pigeonhole-principle/metadata.json`.
- `compile.sh` and `compile.ps1` — one-command builds (bash / PowerShell).
- `loom.cls` — a **copy** of the root class (see below).

A complete worked reference lives in `output/pigeonhole-principle/` — mirror its shape.

## `loom.cls` handling

Each notebook ships a **copy** of root `loom.cls` (decided: copies, not symlinks — robust on
Windows, makes each folder self-contained). The copies are byte-identical to root. **If you edit
root `loom.cls`, re-sync every copy:**

```bash
for f in $(find . -name loom.cls -not -path './.git/*' -not -path './loom.cls'); do cp loom.cls "$f"; done
```

Fonts are cross-platform via `\IfFontExistsTF` (macOS → Optima/Avenir/Menlo + Songti/Kaiti;
elsewhere → Lato/Gillius/Libertinus + SimSun/KaiTi/Microsoft YaHei). No per-platform edits needed.

## Commands (TeX Live 2026 is on PATH; XeLaTeX only)

```powershell
# Windows / PowerShell (primary shell here)
cd output\<name>; ./compile.ps1          # or:
latexmk -xelatex -interaction=nonstopmode -file-line-error main.tex
```
```bash
# macOS / Linux / Git Bash
cd output/<name> && bash compile.sh      # or:
latexmk -xelatex -interaction=nonstopmode main.tex   # latexmk runs the needed two passes
```
- **Never pdflatex.** If `latexmk` is unavailable, run `xelatex main.tex` **twice** (the selvage
  rail uses `remember picture`; TOC/`\ref` resolve on the 2nd pass).
- **Rasterize to inspect** (Ghostscript is **not** installed; use poppler):
  `pdftoppm -png -r 130 -f 2 -l 2 main.pdf page` → `page-2.png`. (`pdftocairo` also works.)

## Verification loop & success criteria

After compiling:
1. Process exited 0 and `main.pdf` exists with the expected page count
   (`grep -oE 'Output written on .*\(([0-9]+) page' main.log`).
2. Log is clean: `grep -cE 'Overfull \\hbox \([0-9]{2,}\.' main.log` (~0 large boxes);
   `grep -c 'Font shape .* undefined' main.log` (≤1 — see benign note below); `grep -c undefined`.
3. **Look at the PDF.** A correct notebook shows: woven cover + **spine subtitle**; the left
   selvage rail on every page; **indigo** theorems, **madder** definitions, **weld** examples;
   visible `\fillin` blanks, `\TODO` hints, `yourturn`+`\workspace`; margin `\warmth`/`\recall`;
   structure following the **spine**, not the source's order.

## Do not commit

- Build artifacts and `output/**/*.pdf` are git-ignored — keep it that way; clean with
  `latexmk -c`.
- **Never overwrite committed reference PDFs:** `examples/*/main.pdf`, `template/main.pdf`,
  `gallery/*.png`. A stray build can dirty them — restore with `git checkout -- <path>`.
- Commit only when the user explicitly asks.

## Failure modes to avoid (XeLaTeX / unicode-math / fonts)

- Subscripts/macros over `\mathbb` need braces: `_{\R}` not `_\R`; `\widehat{\E}` not `\widehat\E`.
- **Do not load `amssymb`** — unicode-math already supplies the glyphs (clashes on `\eth`).
- Arrows in headings/`\block`: use math mode `$\to$`, not a literal `→` (may tofu).
- Several `\fillin` on one display line overflow → stack them in `aligned`.
- Margin notes don't auto-avoid: don't place a `\loose` right after a `yourturn` ending in
  `\recall` — they collide.
- Use `[cjk]` only when the notes contain Chinese.
- **Benign on non-macOS:** the log may show `font not found, using nullfont` (an `\IfFontExistsTF`
  probe missing the macOS face, then loading the fallback) and one `Font shape … sc undefined`
  from the cover footer's `\textsc`. Both are harmless — not build failures.

Full pitfalls: `skill/reference/pitfalls.md`.

## Where the deep rules live (read on demand)

| read this | when |
|---|---|
| `.claude-instructions.md` | writing `main.tex` — every command, the fill-in devices, pitfalls, the full output/metadata contract |
| `SPINE-ANALYSIS-GUIDE.md` | step 2 — the five spine patterns, diagnostic questions, selection criteria, confidence rubric |
| `WORKFLOW.md` | the end-to-end user-facing flow and the PDF review checklist |
| `skill/reference/method.md` | the 70/30 pedagogy — what to leave readable vs. blank, per-section rhythm |
| `skill/reference/loom-commands.md` | the exhaustive command reference |
| `skill/SKILL.md` | the skill manifest / scope notes |
| `examples/*/`, `output/pigeonhole-principle/` | worked notebooks in different spine styles |
