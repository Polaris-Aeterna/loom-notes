# Pitfalls — XeLaTeX / unicode-math traps that will bite

Hard-won from building the example notebooks. Each one cost a compile cycle.

## Engine & fonts
- **Must use XeLaTeX** (`xelatex` / `latexmk -xelatex`), never pdflatex — the class loads
  `fontspec` and macOS system fonts (Optima, Avenir Next). LaTeX Workshop in VS Code
  defaults to pdflatex; the repo's `.vscode/settings.json` overrides it to XeLaTeX.
- **Run twice** (or use latexmk): the selvage rail uses `remember picture`, and the TOC
  + `\ref`s resolve on the second pass.
- Cross-platform fonts are **automatic** now: `loom.cls` wraps each face in `\IfFontExistsTF`,
  so macOS uses Optima/Avenir/Menlo (and Songti/Kaiti/PingFang for CJK) while Windows/Linux fall
  back to Lato/Gillius/Libertinus (and SimSun/KaiTi/Microsoft YaHei for CJK). No edit needed.
  On non-macOS the log may show a benign probe miss (`font not found, using nullfont`) as each
  `\IfFontExistsTF` tests the macOS face, plus one cosmetic `Font shape … sc undefined` from the
  cover footer's `\textsc` — both harmless.

## unicode-math gotchas (these throw `Missing { inserted` / `\__um_group_begin:`)
- **`\mathbb` in a subscript needs braces.** `\PP^1_\R` fails; write `\PP^1_{\R}`.
  Define shorthands braced too: `\newcommand{\R}{\mathbb{R}}` (not `\mathbb R`).
- **`\widehat` over a `\mathbb` macro needs braces.** `\widehat\E` fails (where `\E=\mathbb E`);
  write `\widehat{\E}`.
- **Do not load `amssymb`** — unicode-math already supplies those glyphs; loading it throws
  `Command \eth already defined`. (The class deliberately loads only `amsmath,mathtools`.)

## Layout
- **Several `\fillin` blanks on one display line overflow.** Stack them in a 2×2
  `\begin{aligned}…\end{aligned}` instead of one long row.
- **A wide non-wrapping table column overflows.** Use the provided `L` (wrapping `X`) column
  for the last/long column; wrap its header as `\multicolumn{1}{l}{…}` to fix baseline.
- **Long `\warp{key}` tags clip in the narrow margin.** Keep keys short; the tag is
  `\raggedright` so multi-word keys wrap, but a single long word can still overrun.
- **Margin notes don't auto-avoid each other.** `\loose`, `\recall`, and `\warp` use `marginnote`
  (which works inside boxes, unlike `\marginpar`) but it does *not* stack to avoid overlap. So do
  NOT place a `\loose` right after a `yourturn` whose last element is a `\recall` — the two collide
  and overprint. Make the section-closing thread an inline `strand` instead, or separate them.
- **Optima lacks some glyphs** (e.g. `→`). In a `\block`/heading use math mode `$\to$`,
  not a literal arrow, or it tofus.

## Style
- TeX input ligatures now fire in the display fonts too: the class loads `\headingfont`,
  `\strandfont`, and `\labelfont` with `[Ligatures=TeX]`, so `---` → em dash and `` `` ``/`''`
  → curly quotes render correctly in `strand`/`\whisper`/`\block`/headings/cover (the body font
  Libertinus already had them). You can write `---` and `` ``…'' `` directly; no Unicode
  workaround needed. (`\setmonofont` is deliberately left without it, so dashes stay literal in
  code.) Stylistically, still go light on em-dashes in prose; prefer commas/colons.
- When bulk-replacing in Chinese files, use a tool that handles UTF-8 (`perl -CSD`
  *double-encodes* an ASCII-typed Chinese replacement → mojibake; use `\x{FF0C}` escapes or
  Python with `encoding='utf-8'`).

## Verify before declaring done
Rasterize a page and actually look at it:
```bash
gs -dQUIET -dBATCH -dNOPAUSE -sDEVICE=png16m -r130 -dFirstPage=2 -dLastPage=2 -o p2.png main.pdf
```
Scan the log for real problems: `grep -cE 'Overfull \\hbox \([0-9]{2,}\.' main.log`,
`grep -c undefined main.log`, `grep -c 'Font shape .*undefined' main.log` — aim for 0.
