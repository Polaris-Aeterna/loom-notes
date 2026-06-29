# Fonts for the `classico` edition

`loom.cls` (in this folder) loads its display face, **URW Classico** (an open
clone of Optima), from *this* `fonts/` directory. The font files are **not
bundled** in the repo: URW Classico is distributed under the **Aladdin Free
Public License (AFPL)**, which allows non-commercial redistribution only and
would clash with this repo's MIT licence. So you supply them yourself.

## What to put here

Four OpenType files, named exactly:

```
URWClassico-Regular.otf
URWClassico-Bold.otf
URWClassico-Italic.otf
URWClassico-BoldItalic.otf
```

## Where to get them

URW Classico ships with the CTAN **`classico`** package:
<https://ctan.org/pkg/classico>. Mind the AFPL terms (non-commercial use).

## How to compile

This folder is already laid out flat (`main.tex`, `loom.cls`, `loom-emblem.tex`,
`loom-rail.tex`, `figure/`, `fonts/` all siblings), so just upload the whole
`classico/` folder to an Overleaf project, add the four `.otf` above into
`fonts/`, and set the compiler to **XeLaTeX** (Menu → Compiler → XeLaTeX).

## Don't want to upload fonts at all?

Use the **`libertinus`** edition next door — all-Libertinus + Noto CJK, every
font ships with Overleaf, nothing to upload. See [`../../libertinus/`](../../libertinus/).
