%% loom.cls (classico edition) -- Full-featured Loom for Overleaf, contributed by fn-gn (fixed section rule, stable)
%% ---------------------------------------------------------------------------
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{loom}[2026/06/29 v2.6 Overleaf Loom with reliable red rule]

% ----- class options --------------------------------------------------------
\newif\ifloom@cjk      \loom@cjkfalse
\newif\ifloom@letter   \loom@letterfalse
\DeclareOption{cjk}{\loom@cjktrue}
\DeclareOption{letter}{\loom@lettertrue}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax
\LoadClass[11pt]{article}

% ----- geometry (original) --------------------------------------------------
\RequirePackage{geometry}
\ifloom@letter
  \geometry{letterpaper}
\else
  \geometry{a4paper}
\fi
\geometry{top=2.0cm, bottom=2.3cm, left=2.9cm, right=3.1cm,
          marginparwidth=2.35cm, marginparsep=0.35cm, headsep=14pt}

% ----- colours (exact dye‑pot) ----------------------------------------------
\RequirePackage{xcolor}
\definecolor{inkiron}{HTML}{211C17}
\definecolor{indigo}{HTML}{27406B}
\definecolor{madder}{HTML}{9C2B2E}
\definecolor{weld}{HTML}{BE8A20}
\definecolor{linen}{HTML}{F5EFE2}
\definecolor{thread}{HTML}{C7BBA1}
\definecolor{selvage}{HTML}{8A7F6B}
\color{inkiron}

% ----- math packages (load before fontspec/unicode-math) --------------------
\RequirePackage{amsmath}
\RequirePackage[overload]{mathtools}
\RequirePackage{amsthm}

% ----- fonts: URW Classico from ./fonts/ ------------------------------------
\RequirePackage{fontspec}
\RequirePackage{unicode-math}

\setmainfont{URWClassico}[
  Path        = fonts/,
  Extension   = .otf,
  UprightFont = *-Regular,
  ItalicFont  = *-Italic,
  BoldFont    = *-Bold,
  BoldItalicFont = *-BoldItalic
]
\setsansfont{URWClassico}[
  Path        = fonts/,
  Extension   = .otf,
  UprightFont = *-Regular,
  ItalicFont  = *-Italic,
  BoldFont    = *-Bold,
  BoldItalicFont = *-BoldItalic
]
\setmathfont{Latin Modern Math}

\newfontfamily\headingfont{URWClassico}[
  Path        = fonts/,
  Extension   = .otf,
  UprightFont = *-Regular,
  BoldFont    = *-Bold,
  ItalicFont  = *-Italic,
  BoldItalicFont = *-BoldItalic
]
\newfontfamily\strandfont{URWClassico}[
  Path        = fonts/,
  Extension   = .otf,
  UprightFont = *-Regular,
  ItalicFont  = *-Italic,
  BoldFont    = *-Bold,
  BoldItalicFont = *-BoldItalic
]
\newfontfamily\labelfont{URWClassico}[
  Path        = fonts/,
  Extension   = .otf,
  UprightFont = *-Regular,
  BoldFont    = *-Bold,
  ItalicFont  = *-Italic,
  BoldItalicFont = *-BoldItalic
]

\ifloom@cjk
  \RequirePackage{xeCJK}
  % Prefer Noto CJK (bundled on Overleaf); fall back to macOS faces locally.
  \IfFontExistsTF{Noto Serif CJK SC}{%
    \setCJKmainfont{Noto Serif CJK SC}[
      UprightFont=*,
      BoldFont=* Bold,
      ItalicFont=Noto Serif CJK SC,
      BoldItalicFont=Noto Serif CJK SC Bold]
    \setCJKsansfont{Noto Sans CJK SC}
    \setCJKmonofont{Noto Sans CJK SC}
  }{%
    \setCJKmainfont{Songti SC}[ItalicFont={Kaiti SC}]
    \setCJKsansfont{PingFang SC}
    \setCJKmonofont{PingFang SC}
  }%
  \xeCJKsetup{CJKmath=true}
\fi

\RequirePackage{microtype}
\linespread{1.06}

% ----- small inline tile ------------------------------------------
\RequirePackage{tikz}
\usetikzlibrary{calc,decorations.pathmorphing}
\newcommand{\loomtile}[1]{%
  \begin{tikzpicture}[x=1pt,y=1pt,baseline=-0.4pt]
    \fill[#1]            (0,0) rectangle (3,3);
    \fill[#1]            (3,3) rectangle (6,6);
    \fill[#1!28!linen]   (3,0) rectangle (6,3);
    \fill[#1!28!linen]   (0,3) rectangle (3,6);
  \end{tikzpicture}}

% ----- main emblem (externalised) -------------------------------------------
\RequirePackage{graphicx}
\newcommand{\weaveemblem}[1]{%
  \IfFileExists{loom-emblem.tex}{%
    \input{loom-emblem.tex}%
  }{%
    \begin{tikzpicture}[x=1pt,y=1pt]
      \fill[linen!80!indigo!10] (0,0) rectangle (#1,#1);
      \draw[thread,line width=0.4pt] (0,0) rectangle (#1,#1);
      \node[anchor=center, font=\strandfont\scriptsize, color=selvage] 
        at (#1/2,#1/2) {emblem};
    \end{tikzpicture}%
  }%
}

% ----- title page -----------------------------------------------------------
\def\loomsubtitle{}
\renewcommand{\maketitle}{%
  \begin{titlepage}
    \thispagestyle{empty}
    \centering
    \vspace*{2.0cm}
    {\weaveemblem{132}\par}
    \vspace{1.3cm}
    {\headingfont\bfseries\fontsize{32}{36}\selectfont\color{indigo}%
      \addfontfeatures{LetterSpace=1.0}\@title\par}
    \vspace{0.55cm}
    {\color{madder}\rule{4.2cm}{1.1pt}\par}
    \vspace{0.5cm}
    {\strandfont\large\color{inkiron!85!white}\loomsubtitle\par}
    \vfill
    {\strandfont\color{inkiron}\@author\par}
    \vspace{0.25em}
    {\strandfont\small\color{selvage}\@date\par}
    \vspace{1.1cm}
    {\labelfont\footnotesize\color{selvage}%
  dyed in \textcolor{indigo}{indigo}, \textcolor{madder}{madder} \&
  \textcolor{weld}{weld}; ruled in iron-gall. \quad woven on \text{loom}.\par}
  \end{titlepage}%
}
\newcommand{\loomcover}[4]{%
  \title{#1}%
  \def\loomsubtitle{#2}%
  \author{#3}%
  \date{#4}%
  \maketitle
}

% ----- page style -----------------------------------------------------------
\RequirePackage{fancyhdr}
\RequirePackage{eso-pic}
\pagestyle{fancy}\fancyhf{}
\renewcommand{\headrulewidth}{0pt}
\renewcommand{\footrulewidth}{0pt}
\fancyfoot[R]{\strandfont\footnotesize\color{selvage}\thepage}
\fancyfoot[L]{\strandfont\footnotesize\color{selvage}\MakeLowercase{\loom@runtitle}}
\def\loom@runtitle{}
\newcommand{\runningthread}[1]{\def\loom@runtitle{#1}}
\setlength{\parindent}{2em}
\setlength{\parskip}{0.45em plus 0.2em minus 0.1em}

% ----- rail (external) ------------------------------------------------------
\newcommand{\loomrail}{}
\newcommand{\enablerail}{%
  \AddToShipoutPictureBG{%
    \begin{tikzpicture}[remember picture,overlay]
      \IfFileExists{loom-rail.tex}{%
        \input{loom-rail.tex}%
      }{%
        \IfFileExists{rail.pdf}{%
          \node[inner sep=0pt, anchor=north west] 
            at ([xshift=1.05cm,yshift=-1.9cm]current page.north west)
            {\includegraphics[width=0.5cm, height=\dimexpr\paperheight-3.9cm\relax]{rail.pdf}};
        }{%
          \draw[thread, line width=0.4pt]
            ([xshift=1.05cm,yshift=-1.9cm]current page.north west) --
            ([xshift=1.05cm,yshift=2.0cm]current page.south west);
        }%
      }%
    \end{tikzpicture}%
  }%
}

% ----- TITLE FORMAT with visible red rule (reliable) -----------------------
\RequirePackage{titlesec}
\newcommand{\sectionheadfont}{\headingfont\bfseries\fontsize{15}{18}\selectfont
  \color{indigo}\addfontfeatures{LetterSpace=3.0}}

% Use a separate macro to draw the rule after the section heading
\titleformat{\section}[block]
  {\sectionheadfont}
  {\llap{\raisebox{-1.2pt}{\loomtile{indigo}}\hspace{7pt}}\textcolor{selvage}{\thesection}\hspace{0.7em}}
  {0pt}
  {\MakeUppercase}
  [\vspace{2pt}\textcolor{madder}{\rule{\linewidth}{1.1pt}}]   % <-- the red line

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
%  ALL PEDAGOGY TOOLS (unchanged)
% ===========================================================================
\RequirePackage[most]{tcolorbox}
\tcbuselibrary{skins,breakable}
\RequirePackage{enumitem}
\RequirePackage{needspace}
\RequirePackage{marginnote}
\RequirePackage{hyperref}
\hypersetup{colorlinks=true, linkcolor=indigo, citecolor=madder,
            urlcolor=indigo, pdfborder={0 0 0}}

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

\renewcommand{\qedsymbol}{\loomtile{inkiron}}
\renewcommand{\proofname}{\normalfont\headingfont\itshape\color{selvage}Proof}
\newcommand{\weaveid}[1]{\leavevmode
  \llap{\raisebox{-0.8pt}{\loomtile{madder}}\hspace{4pt}}%
  {\labelfont\footnotesize\color{selvage}#1\hspace{0.6em}}}

% ----- strand -------------------------------------------------------------
\newtcolorbox{strand}{
  enhanced, breakable, sharp corners, frame hidden, boxrule=0pt,
  colback=indigo!4, borderline west={1.6pt}{0pt}{indigo!55},
  left=11pt, right=9pt, top=6pt, bottom=6pt,
  before skip=8pt, after skip=8pt,
  fontupper=\strandfont\small\color{inkiron!92!white}}
\newcommand{\whisper}[1]{{\strandfont\small\color{indigo!78!black}#1}}
\newcommand{\keyword}[1]{{\bfseries\color{madder}#1}}

% ----- margin tools -------------------------------------------------------
\newcommand{\looseglyph}{\tikz[baseline=-0.6ex]{\draw[madder,line width=0.6pt,
  decorate,decoration={snake,amplitude=1.1pt,segment length=4.2pt}](0,0)--(0.62cm,0);}}
\newcommand{\loose}[1]{\marginnote{\raggedright\strandfont\footnotesize\color{selvage}%
  \looseglyph\par\vspace{1pt}#1}}
\newcommand{\warmth}[1]{\,\begin{tikzpicture}[x=1pt,y=1pt,baseline=-0.4pt]
  \foreach \i in {1,...,5}{%
    \ifnum\i>#1
      \draw[thread,line width=0.5pt] ({(\i-1)*5.0},0) rectangle +(3.4,3.4);
    \else
      \fill[weld] ({(\i-1)*5.0},0) rectangle +(3.4,3.4);
    \fi}
  \end{tikzpicture}\,}
\newcommand{\warp}[1]{\phantomsection\label{warp:#1}%
  \marginnote{\raggedright\strandfont\scriptsize\color{indigo}$\rightsquigarrow$\,#1}}
\newcommand{\pick}[1]{\hyperref[warp:#1]{%
  {\strandfont\scriptsize\color{indigo}[\,#1\,$\hookleftarrow$]}}}

% ----- pedagogy -----------------------------------------------------------
\RequirePackage{booktabs}
\RequirePackage{tabularx}
\RequirePackage{array}
\newcolumntype{L}{>{\raggedright\arraybackslash}X}
\newcommand{\block}[1]{\par\medskip\noindent
  {\headingfont\bfseries\color{indigo}#1}\par\smallskip}
\newcommand{\trigger}[1]{\par\smallskip\noindent
  {\headingfont\bfseries\color{madder}Trigger.}\enspace #1\par\smallskip}
\newcommand{\TODO}[1]{{\strandfont\small\color{madder}[\,fill in: #1\,]}}
\newcommand{\fillin}[1][2.2cm]{\,\underline{\hspace{#1}}\,}
\newcommand{\recall}[1]{\marginnote{\raggedright\strandfont\footnotesize\color{selvage}%
  {\bfseries\color{indigo}?}\ #1}}
\newtcolorbox{yourturn}{enhanced,breakable,sharp corners,boxrule=0pt,frame hidden,
  colback=weld!9!linen, borderline west={2pt}{0pt}{weld},
  left=11pt,right=10pt,top=7pt,bottom=8pt,before skip=9pt,after skip=9pt,
  before upper={{\headingfont\bfseries\color{weld!60!inkiron}Your turn.}\enspace}}
\newcommand{\workspace}[1][3]{\par\vspace{1pt}%
  \foreach \i in {1,...,#1}{\noindent{\color{thread}\rule{\linewidth}{0.3pt}}\par\vspace{9pt}}}

% ----- math shorthands -----------------------------------------------------
\newcommand{\R}{\mathbb{R}}
\newcommand{\C}{\mathbb{C}}
\newcommand{\Q}{\mathbb{Q}}
\newcommand{\Z}{\mathbb{Z}}
\newcommand{\N}{\mathbb{N}}
\newcommand{\PP}{\mathbb{P}}
\newcommand{\V}{\mathcal{V}}
\newcommand{\Ideal}{\mathcal{I}}
\newcommand{\gen}[1]{\langle #1\rangle}
\newcommand{\xb}{\mathbf{x}}
\newcommand{\inn}{\operatorname{in}}
\DeclareMathOperator{\Spec}{Spec}
\DeclareMathOperator{\rad}{rad}
\DeclareMathOperator{\HS}{HS}
\DeclareMathOperator{\HP}{HP}
\DeclareMathOperator{\rank}{rank}

\endinput