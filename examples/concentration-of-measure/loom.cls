%% loom.cls -- a WOVEN notebook class for handwritten LaTeX notes
%% ---------------------------------------------------------------------------
%%  Concept:  A page is cloth on a loom.  You don't just typeset the maths,
%%            you typeset the WEAVE of your own understanding.
%%
%%              warp   = threads currently in play (left selvage rail)
%%              knot   = a result that binds threads together (theorem boxes)
%%              loose  = an open question / confusion (dangling margin thread)
%%              warmth = a gauge of how well you actually grok a block
%%
%%  Fill-in study notes (built in):  \fillin blanks · \TODO proof gaps ·
%%            yourturn boxes · \recall margin prompts · \workspace ruled lines.
%%
%%  Palette:  natural dyes -- indigo, madder, weld -- ruled in iron-gall.
%%  Engine:   XeLaTeX  (uses Libertinus math + macOS Optima/Avenir Next).
%%  Author:   北极甜虾 (Polaris), 2026.   MIT-licensed.
%% ---------------------------------------------------------------------------
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{loom}[2026/06/28 v0.2 Loom -- a woven notebook class for fill-in study notes]

% ----- class options --------------------------------------------------------
\newif\ifloom@cjk      \loom@cjkfalse
\newif\ifloom@letter   \loom@letterfalse
\DeclareOption{cjk}{\loom@cjktrue}          % enable 中文 (Songti / PingFang)
\DeclareOption{letter}{\loom@lettertrue}    % US letter instead of A4
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax
\LoadClass[11pt]{article}

% ----- geometry: wide left gutter for the rail, generous right for loose ----
\RequirePackage{geometry}
\ifloom@letter
  \geometry{letterpaper}
\else
  \geometry{a4paper}
\fi
\geometry{top=2.0cm, bottom=2.3cm, left=2.9cm, right=3.1cm,
          marginparwidth=2.35cm, marginparsep=0.35cm, headsep=14pt}

% ----- fonts: Libertinus (text+math, portable) + display faces --------------
%  The signature faces are macOS system fonts (Optima / Avenir Next / Menlo).
%  Where they are absent (Windows, Linux, plain TeX Live) we fall back through
%  portable faces that ship with TeX Live, then to Libertinus, which always
%  exists.  Output on macOS is unchanged; everywhere else it still compiles.
\RequirePackage{libertinus-otf}             % loads fontspec + unicode-math
\RequirePackage{microtype}

% headings: the incised humanist signature
% NB: [Ligatures=TeX] so ---/``''/-- fire in display text (libertinus body has them already).
\IfFontExistsTF{Optima}{\newfontfamily\headingfont{Optima}[Ligatures=TeX]}{%
  \IfFontExistsTF{Lato}{\newfontfamily\headingfont{Lato}[Ligatures=TeX]}{%
    \newfontfamily\headingfont{Libertinus Sans}[Ligatures=TeX]}}
% the informal "intuition voice"
\IfFontExistsTF{Avenir Next}{\newfontfamily\strandfont{Avenir Next}[Ligatures=TeX]}{%
  \IfFontExistsTF{Lato}{\newfontfamily\strandfont{Lato}[Ligatures=TeX]}{%
    \newfontfamily\strandfont{Libertinus Sans}[Ligatures=TeX]}}
% condensed labels (numbers, weave-ids, the cover footer)
\IfFontExistsTF{Avenir Next Condensed}{\newfontfamily\labelfont{Avenir Next Condensed}[Ligatures=TeX]}{%
  \IfFontExistsTF{Gillius ADF Cond}{\newfontfamily\labelfont{Gillius ADF Cond}[Ligatures=TeX]}{%
    \newfontfamily\labelfont{Libertinus Sans}[Ligatures=TeX]}}
% monospace
\IfFontExistsTF{Menlo}{\setmonofont{Menlo}[Scale=0.86]}{%
  \IfFontExistsTF{Consolas}{\setmonofont{Consolas}[Scale=0.86]}{%
    \setmonofont{Libertinus Mono}[Scale=0.92]}}
\linespread{1.06}

\ifloom@cjk
  \RequirePackage{xeCJK}
  % 中文正文 -> 宋体; \emph 落到楷体.  macOS: Songti/Kaiti; Windows: SimSun/KaiTi.
  \IfFontExistsTF{Songti SC}{\setCJKmainfont{Songti SC}[ItalicFont={Kaiti SC}]}{%
    \IfFontExistsTF{SimSun}{\setCJKmainfont{SimSun}[ItalicFont={KaiTi}]}{%
      \setCJKmainfont{Noto Serif CJK SC}}}
  \IfFontExistsTF{PingFang SC}{\setCJKsansfont{PingFang SC}}{%
    \IfFontExistsTF{Microsoft YaHei}{\setCJKsansfont{Microsoft YaHei}}{%
      \setCJKsansfont{Noto Sans CJK SC}}}
  \IfFontExistsTF{PingFang SC}{\setCJKmonofont{PingFang SC}}{%
    \IfFontExistsTF{Microsoft YaHei}{\setCJKmonofont{Microsoft YaHei}}{%
      \setCJKmonofont{Noto Sans CJK SC}}}
  \xeCJKsetup{CJKmath=true}
\fi

% ----- the dye-pot ----------------------------------------------------------
\RequirePackage{xcolor}
\definecolor{inkiron}{HTML}{211C17}   % iron-gall: warm near-black body ink
\definecolor{indigo}{HTML}{27406B}   % indigo: structure, headings, knots
\definecolor{madder}{HTML}{9C2B2E}   % madder red: definitions, emphasis
\definecolor{weld}{HTML}{BE8A20}   % weld gold: examples, warmth
\definecolor{linen}{HTML}{F5EFE2}   % undyed cloth: rail + soft box fills
\definecolor{thread}{HTML}{C7BBA1}   % the faint warp hairlines
\definecolor{selvage}{HTML}{8A7F6B}   % muted edge text in the margins
\color{inkiron}

% ----- maths & theorem machinery -------------------------------------------
\RequirePackage{amsmath,mathtools}   % NB: unicode-math already supplies amssymb glyphs
\RequirePackage{amsthm}
\RequirePackage[most]{tcolorbox}
\tcbuselibrary{skins,breakable}
\RequirePackage{enumitem}
\RequirePackage{needspace}
\RequirePackage{marginnote}
\RequirePackage{eso-pic}
\usetikzlibrary{calc,decorations.pathmorphing}
\RequirePackage{titlesec}
\RequirePackage{fancyhdr}

% page furniture: a quiet selvage footer
\pagestyle{fancy}\fancyhf{}
\renewcommand{\headrulewidth}{0pt}
\renewcommand{\footrulewidth}{0pt}
\fancyfoot[R]{\strandfont\footnotesize\color{selvage}\thepage}
\fancyfoot[L]{\strandfont\footnotesize\color{selvage}\MakeLowercase{\loom@runtitle}}
\def\loom@runtitle{}
\newcommand{\runningthread}[1]{\def\loom@runtitle{#1}}

% loose page layout for notes
\setlength{\parindent}{0pt}
\setlength{\parskip}{0.45em plus 0.2em minus 0.1em}

% ===========================================================================
%  WOVEN PRIMITIVES
% ===========================================================================

% a 2x2 plain-weave tile -- the "knot" emblem (arg: dye colour)
\newcommand{\loomtile}[1]{%
  \begin{tikzpicture}[x=1pt,y=1pt,baseline=-0.4pt]
    \fill[#1]            (0,0) rectangle (3,3);
    \fill[#1]            (3,3) rectangle (6,6);
    \fill[#1!28!linen]   (3,0) rectangle (6,3);
    \fill[#1!28!linen]   (0,3) rectangle (3,6);
  \end{tikzpicture}}

% a procedural tri-colour plain-weave swatch (arg: side length in pt)
\newcommand{\weaveemblem}[1]{%
  \begin{tikzpicture}[x=1pt,y=1pt]
    \pgfmathsetmacro{\cell}{#1/8}%
    \foreach \c in {0,...,7}{%
      \foreach \r in {0,...,7}{%
        \pgfmathtruncatemacro{\warpover}{mod(\c+\r,2)}%
        \pgfmathtruncatemacro{\warpcol}{mod(\c,3)}%
        \def\wcolor{indigo}\ifnum\warpcol=2\def\wcolor{weld}\fi
        \coordinate (o) at (\c*\cell,\r*\cell);
        \def\drawwarp{\fill[\wcolor,rounded corners=0.8pt]
            ($(o)+(0.17*\cell,-0.03*\cell)$) rectangle ($(o)+(0.83*\cell,1.03*\cell)$);}%
        \def\drawweft{\fill[madder,rounded corners=0.8pt]
            ($(o)+(-0.03*\cell,0.17*\cell)$) rectangle ($(o)+(1.03*\cell,0.83*\cell)$);}%
        \ifnum\warpover=1 \drawweft\drawwarp \else \drawwarp\drawweft \fi
      }}%
  \end{tikzpicture}}

% the persistent SELVAGE RAIL, painted into every page background
\newcommand{\loomrail}{%
  \AddToShipoutPictureBG{%
    \begin{tikzpicture}[remember picture,overlay]
      \fill[linen]
        ([xshift=1.05cm,yshift=-1.9cm]current page.north west) rectangle
        ([xshift=1.55cm,yshift= 2.0cm]current page.south west);
      \foreach \i in {0,1,2,3}{%
        \draw[thread,line width=0.4pt]
          ([xshift={1.10cm+\i*0.13cm},yshift=-1.9cm]current page.north west) --
          ([xshift={1.10cm+\i*0.13cm},yshift= 2.0cm]current page.south west);}
    \end{tikzpicture}}}

% ===========================================================================
%  HEADINGS  (number hangs onto the rail as a woven knot)
% ===========================================================================
\newcommand{\sectionheadfont}{\headingfont\bfseries\fontsize{15}{18}\selectfont
  \color{indigo}\addfontfeatures{LetterSpace=3.0}}
\titleformat{\section}[block]
  {\sectionheadfont}
  {\llap{\raisebox{-1.2pt}{\loomtile{indigo}}\hspace{7pt}}\textcolor{selvage}{\thesection}\hspace{0.7em}}
  {0pt}
  {\MakeUppercase}
  [\vspace{1pt}{\color{madder}\rule{\linewidth}{1.1pt}}]
\titlespacing*{\section}{0pt}{20pt plus 4pt}{8pt}

\titleformat{\subsection}[runin]
  {\headingfont\bfseries\color{madder}}
  {\thesubsection}{0.55em}{}
\titlespacing*{\subsection}{0pt}{11pt plus 2pt}{0.7em}

\titleformat{\subsubsection}[runin]
  {\strandfont\bfseries\color{indigo}}
  {}{0pt}{}
\titlespacing*{\subsubsection}{0pt}{8pt}{0.6em}

% ===========================================================================
%  KNOTS  (theorem-likes: amsthm head + tcolorbox skin)
% ===========================================================================
\newtheoremstyle{loomplain}{6pt}{6pt}{\normalfont}{0pt}
  {\headingfont\bfseries\color{indigo}}{.}{0.5em}
  {\thmname{#1}\thmnumber{ #2}\thmnote{ \normalfont\itshape\color{inkiron}(#3)}}
\newtheoremstyle{loomdefn}{6pt}{6pt}{\normalfont}{0pt}
  {\headingfont\bfseries\color{madder}}{.}{0.5em}
  {\thmname{#1}\thmnumber{ #2}\thmnote{ \normalfont\itshape\color{inkiron}(#3)}}
\newtheoremstyle{loomexm}{6pt}{6pt}{\normalfont}{0pt}
  {\headingfont\bfseries\color{weld!75!inkiron}}{.}{0.5em}
  {\thmname{#1}\thmnumber{ #2}\thmnote{ \normalfont\itshape\color{inkiron}(#3)}}
\newtheoremstyle{loomrem}{6pt}{6pt}{\normalfont}{0pt}
  {\itshape\color{madder}}{.}{0.5em}
  {\thmname{#1}\thmnumber{ #2}\thmnote{ \normalfont\itshape(#3)}}

\theoremstyle{loomplain}
\newtheorem{theorem}{Theorem}[section]
\newtheorem{lemma}[theorem]{Lemma}
\newtheorem{proposition}[theorem]{Proposition}
\newtheorem{corollary}[theorem]{Corollary}
\theoremstyle{loomdefn}
\newtheorem{definition}[theorem]{Definition}
\theoremstyle{loomexm}
\newtheorem{example}[theorem]{Example}
\theoremstyle{loomrem}
\newtheorem{remark}[theorem]{Remark}
\newtheorem*{remark*}{Remark}

% the binding-thread skin; a knot-tile hangs left onto the rail
\tcbset{
  knotcommon/.style={
    enhanced, breakable, sharp corners, frame hidden, boxrule=0pt,
    left=12pt, right=11pt, top=8pt, bottom=8pt,
    before skip=10pt plus 2pt, after skip=10pt plus 2pt },
  knotindigo/.style={knotcommon, colback=linen!60!white,
    borderline west={2.2pt}{0pt}{indigo},
    overlay unbroken and first={\node[anchor=north east,inner sep=0pt]
      at ([xshift=-7pt,yshift=-7pt]frame.north west){\loomtile{indigo}};}},
  knotmadder/.style={knotcommon, colback=madder!6!linen,
    borderline west={2.2pt}{0pt}{madder},
    overlay unbroken and first={\node[anchor=north east,inner sep=0pt]
      at ([xshift=-7pt,yshift=-7pt]frame.north west){\loomtile{madder}};}},
  knotweld/.style={knotcommon, colback=weld!10!linen,
    borderline west={2.2pt}{0pt}{weld},
    overlay unbroken and first={\node[anchor=north east,inner sep=0pt]
      at ([xshift=-7pt,yshift=-7pt]frame.north west){\loomtile{weld}};}},
}
\tcolorboxenvironment{theorem}{knotindigo}
\tcolorboxenvironment{lemma}{knotindigo}
\tcolorboxenvironment{proposition}{knotindigo}
\tcolorboxenvironment{corollary}{knotindigo}
\tcolorboxenvironment{definition}{knotmadder}
\tcolorboxenvironment{example}{knotweld}

% proofs end on a tiny woven tile instead of the usual tombstone
\renewcommand{\qedsymbol}{\loomtile{inkiron}}
\renewcommand{\proofname}{\normalfont\headingfont\itshape\color{selvage}Proof}

% optional inline knot-ID stamp (ties to an L01/L02 claim-DAG habit)
\newcommand{\weaveid}[1]{\leavevmode
  \llap{\raisebox{-0.8pt}{\loomtile{madder}}\hspace{4pt}}%
  {\labelfont\footnotesize\color{selvage}#1\hspace{0.6em}}}

% ===========================================================================
%  THE INTUITION VOICE  (a strand running alongside the formal line)
% ===========================================================================
\newtcolorbox{strand}{
  enhanced, breakable, sharp corners, frame hidden, boxrule=0pt,
  colback=indigo!4, borderline west={1.6pt}{0pt}{indigo!55},
  left=11pt, right=9pt, top=6pt, bottom=6pt,
  before skip=8pt, after skip=8pt,
  fontupper=\strandfont\small\color{inkiron!92!white}}

\newcommand{\whisper}[1]{{\strandfont\small\color{indigo!78!black}#1}}
\newcommand{\keyword}[1]{{\bfseries\color{madder}#1}}

% ===========================================================================
%  THE SELVAGE EDGE  (open threads + a warmth gauge)
% ===========================================================================
% a dangling yarn glyph
\newcommand{\looseglyph}{\tikz[baseline=-0.6ex]{\draw[madder,line width=0.6pt,
  decorate,decoration={snake,amplitude=1.1pt,segment length=4.2pt}](0,0)--(0.62cm,0);}}
% a loose thread = an open question, in the right margin
\newcommand{\loose}[1]{\marginnote{\raggedright\strandfont\footnotesize\color{selvage}%
  \looseglyph\par\vspace{1pt}#1}}

% warmth: how well do I grok this?  n filled weave squares out of 5
\newcommand{\warmth}[1]{\,\begin{tikzpicture}[x=1pt,y=1pt,baseline=-0.4pt]
  \foreach \i in {1,...,5}{%
    \ifnum\i>#1
      \draw[thread,line width=0.5pt] ({(\i-1)*5.0},0) rectangle +(3.4,3.4);
    \else
      \fill[weld] ({(\i-1)*5.0},0) rectangle +(3.4,3.4);
    \fi}
  \end{tikzpicture}\,}

% warp / pick: declare a recurring thread, then pick it up later (cross-ref)
\RequirePackage{hyperref}
\hypersetup{colorlinks=true, linkcolor=indigo, citecolor=madder,
            urlcolor=indigo, pdfborder={0 0 0}}
\newcommand{\warp}[1]{\phantomsection\label{warp:#1}%
  \marginnote{\raggedright\strandfont\scriptsize\color{indigo}$\rightsquigarrow$\,#1}}
\newcommand{\pick}[1]{\hyperref[warp:#1]{%
  {\strandfont\scriptsize\color{indigo}[\,#1\,$\hookleftarrow$]}}}

% ===========================================================================
%  THE COVER  (a woven plate)
% ===========================================================================
% \loomcover{title}{subtitle}{author}{date}   -- enables the rail afterwards
\newcommand{\loomcover}[4]{%
  \begin{titlepage}\thispagestyle{empty}\centering
    \vspace*{2.0cm}
    {\weaveemblem{132}\par}
    \vspace{1.3cm}
    {\headingfont\bfseries\fontsize{32}{36}\selectfont\color{indigo}%
      \addfontfeatures{LetterSpace=1.0}#1\par}
    \vspace{0.55cm}
    {\color{madder}\rule{4.2cm}{1.1pt}\par}
    \vspace{0.5cm}
    {\strandfont\large\color{inkiron!85!white}#2\par}
    \vfill
    {\strandfont\color{inkiron}#3\par}
    \vspace{0.25em}
    {\strandfont\small\color{selvage}#4\par}
    \vspace{1.1cm}
    {\labelfont\footnotesize\color{selvage}%
      dyed in \textcolor{indigo}{indigo}, \textcolor{madder}{madder} \&
      \textcolor{weld}{weld}; ruled in iron-gall. \quad woven on \textsc{loom}.\par}
  \end{titlepage}%
  \loomrail}

% if you skip the cover, call \weave to start the rail
\newcommand{\weave}{\loomrail}

% ===========================================================================
%  PEDAGOGY  --  fill-in study notes (passive read + active recall)
%  The method: state results so they can be READ; leave the high-value steps,
%  computations, and definition-clauses BLANK so they must be ACTIVELY recalled.
% ===========================================================================
\RequirePackage{booktabs}
\RequirePackage{tabularx}
\RequirePackage{array}
\newcolumntype{L}{>{\raggedright\arraybackslash}X}   % wrapping table column

% \block{...} -- a quiet sub-heading inside a section
\newcommand{\block}[1]{\par\medskip\noindent
  {\headingfont\bfseries\color{indigo}#1}\par\smallskip}

% \trigger{...} -- a "when to reach for this" cue
\newcommand{\trigger}[1]{\par\smallskip\noindent
  {\headingfont\bfseries\color{madder}Trigger.}\enspace #1\par\smallskip}

% \TODO{hint} -- a gap to fill inside a proof / derivation
\newcommand{\TODO}[1]{{\strandfont\small\color{madder}[\,fill in: #1\,]}}

% \fillin[width] -- an empty ruled blank to write the answer in
\newcommand{\fillin}[1][2.2cm]{\,\underline{\hspace{#1}}\,}

% \recall{question} -- a quick active-recall prompt in the margin
\newcommand{\recall}[1]{\marginnote{\raggedright\strandfont\footnotesize\color{selvage}%
  {\bfseries\color{indigo}?}\ #1}}

% the active-input zone: a weld box you work inside
\newtcolorbox{yourturn}{enhanced,breakable,sharp corners,boxrule=0pt,frame hidden,
  colback=weld!9!linen, borderline west={2pt}{0pt}{weld},
  left=11pt,right=10pt,top=7pt,bottom=8pt,before skip=9pt,after skip=9pt,
  before upper={{\headingfont\bfseries\color{weld!60!inkiron}Your turn.}\enspace}}

% \workspace[n] -- n faint ruled lines to write on (handwriting; ignore if you type)
\newcommand{\workspace}[1][3]{\par\vspace{1pt}%
  \foreach \i in {1,...,#1}{\noindent{\color{thread}\rule{\linewidth}{0.3pt}}\par\vspace{9pt}}}

\endinput
