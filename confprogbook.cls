%%
%% confprogbook.cls — A LaTeX class for conference program books
%%
%% Copyright (c) 2026 John Aoga
%% Licensed under the LaTeX Project Public License v1.3c or later.
%% See https://www.latex-project.org/lppl/
%%
%% This class provides a complete solution for typesetting conference
%% program books (Book of Abstracts) including: cover pages, programmatic
%% table of contents, session/talk entries, included PDF abstracts,
%% participant lists, and organizational comments.
%%
\NeedsTeXFormat{LaTeX2e}[2020/10/01]
\ProvidesClass{confprogbook}[2026/03/11 v1.0 Conference Program Book class]

%% ============================================================
%% 1. CLASS OPTIONS
%% ============================================================

%% Forward all unknown options to the book class
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{book}}
\ProcessOptions\relax

%% Load base class
\LoadClass{book}

%% ============================================================
%% 2. REQUIRED PACKAGES
%% ============================================================

\RequirePackage{amsmath,amsfonts,amssymb,amstext}
\RequirePackage{graphicx}
\RequirePackage[table]{xcolor}
\RequirePackage{latexsym}
\RequirePackage{ifthen}
\RequirePackage{etoolbox}
\RequirePackage{tabularx}
\RequirePackage{ltablex}
\RequirePackage{lscape}
\RequirePackage{fancyhdr}
\RequirePackage{pdfpages}
\RequirePackage[T1]{fontenc}
\RequirePackage{hyperref}
\RequirePackage{pgfkeys}
\RequirePackage{xparse}

%% ============================================================
%% 3. INTERNAL LENGTHS AND COUNTERS
%% ============================================================

\newlength{\cpb@boxwidth}
\newlength{\cpb@colw}
\setlength{\cpb@colw}{244mm}

\newcounter{cpb@sp}
\setcounter{cpb@sp}{21}
\newcounter{cpb@pdfpage}

%% ============================================================
%% 4. COLOR DEFINITIONS (with user-facing customization)
%% ============================================================

%% --- Default color scheme ---
%% Background colors for boxes
\definecolor{cpb@daybox}{rgb}{1,.2,.2}
\definecolor{cpb@plebox}{rgb}{.4,0,.8}
\definecolor{cpb@sesbox}{rgb}{.8,.8,1}
%% Frame colors for boxes
\definecolor{cpb@fdaybox}{rgb}{1,.2,.2}
\definecolor{cpb@fplebox}{rgb}{.4,0,.8}
\definecolor{cpb@fsesbox}{rgb}{.8,.8,1}
%% Text colors inside boxes
\definecolor{cpb@daytext}{gray}{0}
\definecolor{cpb@pletext}{gray}{1}
\definecolor{cpb@sestext}{gray}{0}
%% Accent colors for tables
\definecolor{cpb@tableaccent}{rgb}{.8,.8,1}
\definecolor{cpb@highlight}{rgb}{1,.2,.2}

%% --- User-facing color customization commands ---
\newcommand{\setdaycolors}[3]{%
  % #1=fill, #2=frame, #3=text  (each is an {model}{spec})
  \definecolor{cpb@daybox}#1%
  \definecolor{cpb@fdaybox}#2%
  \definecolor{cpb@daytext}#3%
}
\newcommand{\setplenarycolors}[3]{%
  \definecolor{cpb@plebox}#1%
  \definecolor{cpb@fplebox}#2%
  \definecolor{cpb@pletext}#3%
}
\newcommand{\setsessioncolors}[3]{%
  \definecolor{cpb@sesbox}#1%
  \definecolor{cpb@fsesbox}#2%
  \definecolor{cpb@sestext}#3%
}
\newcommand{\settableaccentcolor}[1]{%
  \definecolor{cpb@tableaccent}#1%
}

%% ============================================================
%% 5. METADATA COMMANDS
%% ============================================================

%% Storage macros (with sensible defaults)
\newcommand{\cpb@conftitle}{Conference Title}
\newcommand{\cpb@confsubtitle}{}
\newcommand{\cpb@confedition}{}
\newcommand{\cpb@confdate}{Date TBD}
\newcommand{\cpb@conflocation}{Location TBD}
\newcommand{\cpb@confshort}{Conference}
\newcommand{\cpb@booktitle}{Book of Abstracts}
\newcommand{\cpb@editors}{}
\newcommand{\cpb@institution}{}
\newcommand{\cpb@institutionaddr}{}
\newcommand{\cpb@copyrighttext}{%
  All rights reserved. No part of the publication may be reproduced
  in any form by print, photo print, or by any other means
  without prior permission in writing from the publisher.%
}
\newcommand{\cpb@conflogo}{}
\newcommand{\cpb@logoscale}{0.2}
\newcommand{\cpb@pdfscale}{0.95}
\newcommand{\cpb@headerL}{}
\newcommand{\cpb@headerR}{}

%% User-facing setters
\newcommand{\conferencetitle}[1]{\renewcommand{\cpb@conftitle}{#1}}
\newcommand{\conferencesubtitle}[1]{\renewcommand{\cpb@confsubtitle}{#1}}
\newcommand{\conferenceedition}[1]{\renewcommand{\cpb@confedition}{#1}}
\newcommand{\conferencedate}[1]{\renewcommand{\cpb@confdate}{#1}}
\newcommand{\conferencelocation}[1]{\renewcommand{\cpb@conflocation}{#1}}
\newcommand{\conferenceshort}[1]{\renewcommand{\cpb@confshort}{#1}}
\newcommand{\booktitle}[1]{\renewcommand{\cpb@booktitle}{#1}}
\newcommand{\editors}[1]{\renewcommand{\cpb@editors}{#1}}
\newcommand{\institution}[1]{\renewcommand{\cpb@institution}{#1}}
\newcommand{\institutionaddress}[1]{\renewcommand{\cpb@institutionaddr}{#1}}
\newcommand{\copyrightnotice}[1]{\renewcommand{\cpb@copyrighttext}{#1}}
\newcommand{\conferencelogo}[2][0.2]{%
  \renewcommand{\cpb@logoscale}{#1}%
  \renewcommand{\cpb@conflogo}{#2}%
}
\newcommand{\pdfscale}[1]{\renewcommand{\cpb@pdfscale}{#1}}

%% ============================================================
%% 6. PAGE LAYOUT
%% ============================================================

\topmargin -8.9mm
\headheight 5mm
\headsep 5mm
\textwidth 178mm
\textheight 244mm
\columnsep 8mm
\oddsidemargin -9.4mm
\evensidemargin -9.4mm
\parindent 0em
\parskip 1ex plus 0.1ex minus 0.1ex

%% Fancy headers
\pagestyle{fancy}
\fancyhf{}
\fancyhead[LE,RO]{\rmfamily \cpb@booktitle}
\fancyhead[LO,RE]{\rmfamily \cpb@confshort}
\fancyfoot[C]{\rmfamily\thepage}
\renewcommand{\headrulewidth}{0.4pt}
\renewcommand{\footrulewidth}{0pt}

\frenchspacing
\sloppy

%% ============================================================
%% 7. HYPERREF SETUP (deferred to \AtBeginDocument)
%% ============================================================

\AtBeginDocument{%
  \hypersetup{%
    pdftitle={\cpb@booktitle{} -- \cpb@conftitle},
    pdfsubject={\cpb@confshort},
    pdfkeywords={conference, program book, book of abstracts},
    pdfcreator={LaTeX with confprogbook class},
    colorlinks=true
  }%
}

%% ============================================================
%% 8. TOC-RELATED INTERNALS
%% ============================================================

\renewcommand{\@pnumwidth}{1.87em}

\newcommand{\cpb@putplentitle}[2]{%
  \@dottedtocline{0}{0em}{0em}%
    {\textit{#1\/}}%
    {\ifthenelse{\equal{#2}{}}{}{\hyperlink{#2}{\pageref*{#2}}}}%
}

\newcommand{\cpb@puttalktitle}[2]{%
  \@dottedtocline{0}{0em}{0em}%
    {\textit{#1\/}}%
    {\IfBlankF{#2}{\ifcsname r@#2\endcsname\pageref{#2}\fi}}%
  \addtocounter{cpb@sp}{1}%
}
%% ============================================================
%% 9. CORE PROGRAM COMMANDS
%% ============================================================

%% --- Day heading (colored box spanning column width) ---
%% Usage: \dayheading{Tuesday, March 24, 2026}
\newcommand{\dayheading}[1]{%
  \vfill \newpage
  \setlength{\cpb@boxwidth}{\columnwidth}%
  \addtolength{\cpb@boxwidth}{-2\fboxsep}%
  \addtolength{\cpb@boxwidth}{-0.8pt}%
  \fcolorbox{cpb@fdaybox}{cpb@daybox}{%
    \begin{minipage}[t]{\cpb@boxwidth}%
      \color{cpb@daytext}\centerline{\textbf{#1}}%
    \end{minipage}%
  }\vfil%
}

%% --- Plenary heading ---
%% Usage: \pleheading{Type}{Room}{Title}{Speaker}{Chair}{Time}
\newcommand{\pleheading}[6]{%
  \setlength{\cpb@boxwidth}{\columnwidth}%
  \addtolength{\cpb@boxwidth}{-2\fboxsep}%
  \addtolength{\cpb@boxwidth}{-0.8pt}%
  \fcolorbox{cpb@fplebox}{cpb@plebox}{%
    \begin{minipage}[t]{\cpb@boxwidth}%
      \color{cpb@pletext}\textbf{#1}\hfill\textbf{#2}\\
      \centerline{\textbf{#3}}\\
      \centerline{\textbf{#4}}\\\textbf{Chair: #5}%
      \hfill\textbf{#6}%
    \end{minipage}%
  }\vfil%
}

%% --- Session heading ---
%% Usage: \sesheading{Code}{Room}{Title}{Chair}{Time}
\newcommand{\sesheading}[5]{%
  \setlength{\cpb@boxwidth}{\columnwidth}%
  \addtolength{\cpb@boxwidth}{-2\fboxsep}%
  \addtolength{\cpb@boxwidth}{-0.8pt}%
  \fcolorbox{cpb@fsesbox}{cpb@sesbox}{%
    \begin{minipage}[t]{\cpb@boxwidth}%
      \color{cpb@sestext}\textbf{#1}\hfill\textbf{#2}\\
      \centerline{\textbf{#3}}\\\textbf{Chair: #4}%
      \hfill\textbf{#5}%
    \end{minipage}%
  }\vfil%
}

%% ============================================================
%% 10. TALK AND PART ENTRY COMMANDS
%% ============================================================

%% --- Part entry in programmatic TOC ---
%% Usage: \putplen{Title}{Subtitle}{Label}
\newcommand{\putplen}[3]{%
  \parbox{\columnwidth}{\cpb@putplentitle{#1}{#3}#2\par}\vfil%
}

%% --- Talk title (dotted TOC line with page ref) ---
%% Usage: \puttalktitle{Talk Title}{paperLabel}
\newcommand{\puttalktitle}[2]{\cpb@puttalktitle{#1}{#2}}

%% --- Talk entry in program ---
%% Usage: \puttalk{ID+time}{TitleLine}{Author1}{Affil1}{Author2}{Affil2}{Author3}{Affil3}{Presenter}
\newcommand{\puttalk}[9]{%
  \parbox{\columnwidth}{%
    \textbf{#1}%
    #2%
    #3\hfill{#4}\par%
    \ifthenelse{\equal{#5}{}}{}{%
      #5\hfill{#6}\par%
      \ifthenelse{\equal{#7}{}}{}{%
        #7\hfill{#8}\par%
        \ifthenelse{\equal{#9}{}}{}{#9\par}%
      }%
    }%
  }\vfil%
}

%% --- Participant entry ---
%% Usage: \putpart{Prefix}{Name}{Affiliation}{Extra}{Email}
\newcommand{\putpart}[5]{%
  #1 #2\\ #3\\ #4\\
  \IfBlankF{#5}{\href{mailto:#5}{#5}}%
  \vfil%
}

%% ============================================================
%% 11. ABSTRACT INCLUSION
%% ============================================================

%% --- Include a single paper PDF ---
%% Usage: \includepaper{label}{filepath}
%% Optional: \includepaper[scale]{label}{filepath}
\NewDocumentCommand{\includepaper}{O{} m m}{%
  \edef\cpb@thisscale{\ifblank{#1}{\cpb@pdfscale}{#1}}%
  \includepdf[%
    pages=-,%
    pagecommand={\thispagestyle{fancy}\refstepcounter{cpb@pdfpage}\label{#2}},%
    scale=\cpb@thisscale%
  ]{#3}%
}

%% ============================================================
%% 12. HIGH-LEVEL STRUCTURE COMMANDS
%% ============================================================

%% --- Front cover ---
\newcommand{\makefrontcover}{%
  \thispagestyle{empty}%
  \begin{center}
    \vspace*{4cm}%
    {\Huge \textbf{\cpb@conftitle}}%
    \bigskip\bigskip%
    \ifdefempty{\cpb@confsubtitle}{}{%
      {\Huge \textbf{\cpb@confsubtitle}}\\%
    }%
    \vspace{4cm}%
    {\Large \textbf{\cpb@confdate}}%
    \bigskip%
    {\Large \textbf{\cpb@conflocation}}%
    \vspace{4cm}%
    {\Huge \textbf{\cpb@booktitle}}%
  \end{center}
  \vfill%
  \pagebreak%
}

%% --- Front matter (logo, editors, copyright) ---
\newcommand{\makefrontmatter}{%
  \ifdefempty{\cpb@conflogo}{}{%
    \includegraphics[scale=\cpb@logoscale]{\cpb@conflogo}%
  }%
  \thispagestyle{empty}%
  \vfill%
  \ifdefempty{\cpb@editors}{}{%
    {\large{\textbf{\cpb@editors}}}%
    \par%
  }%
  {\large{\textbf{\cpb@booktitle{} -- \cpb@conftitle}}}%
  \bigskip%
  \ifdefempty{\cpb@institution}{}{%
    \cpb@institution\\%
    \ifdefempty{\cpb@institutionaddr}{}{\cpb@institutionaddr}%
  }%
  \medskip%
  \cpb@copyrighttext%
  \medskip%
  \vspace*{.5cm}%
  \cleardoublepage%
}

%% --- Begin program section ---
\newcommand{\cpbbeginprogram}{%
  \cleardoublepage \mbox{} \vspace*{6cm}%
  \begin{center}
    \Huge\textbf{Part 1\\[2ex] Programmatic Table of Contents}%
  \end{center}
  \hypertarget{P:1}{} \label{P:1}%
  \twocolumn \cleardoublepage%
  \pagestyle{fancy}%
}

%% --- End program section (with part index) ---
\newcommand{\cpbendprogram}{%
  \nopagebreak \vfill%
}

%% --- Part index entries (convenience) ---
\newcommand{\programpartindex}{%
  \medskip\nopagebreak%
  \putplen{Part 1: \ \ Programmatic Table of Contents}{Overview of scientific program}{P:1}%
  \medskip\nopagebreak%
  \putplen{Part 2: \ \ Abstracts}{}{P:2}%
  \medskip\nopagebreak%
  \putplen{Part 3: \ \ List of Participants}{Alphabetical list}{P:3}%
  \medskip\nopagebreak%
  \putplen{Part 4: \ \ Organizational Comments}{Comments, overview program, map}{P:4}%
}

%% --- Begin abstracts section ---
\newcommand{\cpbbeginabstracts}{%
  \onecolumn \cleardoublepage \mbox{} \vspace*{6cm}%
  \begin{center}
    \Huge\textbf{Part 2\\[2ex] Abstracts}%
  \end{center}
  \hypertarget{P:2}{} \label{P:2}%
  \cleardoublepage%
}

%% --- End abstracts section ---
\newcommand{\cpbendabstracts}{}

%% --- Begin participants section ---
\newcommand{\cpbbeginparticipants}{%
  \onecolumn \cleardoublepage \mbox{} \vspace*{6cm}%
  \begin{center}
    \Huge\textbf{Part 3\\[2ex] List of Participants}%
  \end{center}
  \hypertarget{P:3}{} \label{P:3}%
  \twocolumn \cleardoublepage%
}

%% --- End participants section ---
\newcommand{\cpbendparticipants}{%
  \nopagebreak \vfill%
  \newpage%
}

%% --- Begin comments section ---
\newcommand{\cpbbegincomments}{%
  \onecolumn%
  \hypertarget{P:4}{} \label{P:4}%
}

%% --- End comments section ---
\newcommand{\cpbendcomments}{}

%% ============================================================
%% 13. LANDSCAPE PROGRAM TABLE HELPERS
%% ============================================================

%% Column width for landscape tables
\newcommand{\setlandscapecolwidth}[1]{\setlength{\cpb@colw}{#1}}

%% Convenience: raggedright alias for table cells
\newcommand{\rr}{\raggedright}

%% Shortcut for the table accent column color
\newcommand{\accentcol}{>{\columncolor{cpb@tableaccent}}}

%% ============================================================
%% 14. UTILITY COMMANDS
%% ============================================================

%% --- Euro formatting ---
\newcommand{\euros}[1]{€ #1}

%% --- Highlight text in red ---
\newcommand{\RED}[1]{{\textcolor{cpb@highlight}{#1}}}

%% --- Medskip + nopagebreak (very common pattern) ---
\newcommand{\programskip}{\medskip\nopagebreak}

%% ============================================================
%% 15. PART TITLE CUSTOMIZATION
%% ============================================================

%% Allow users to rename the four standard parts
\newcommand{\cpb@partIname}{Part 1}
\newcommand{\cpb@partIsubtitle}{Programmatic Table of Contents}
\newcommand{\cpb@partIIname}{Part 2}
\newcommand{\cpb@partIIsubtitle}{Abstracts}
\newcommand{\cpb@partIIIname}{Part 3}
\newcommand{\cpb@partIIIsubtitle}{List of Participants}
\newcommand{\cpb@partIVname}{Part 4}
\newcommand{\cpb@partIVsubtitle}{Organizational Comments}

\newcommand{\setpartname}[3]{%
  % #1 = part number (I, II, III, IV), #2 = name, #3 = subtitle
  \expandafter\renewcommand\csname cpb@part#1name\endcsname{#2}%
  \expandafter\renewcommand\csname cpb@part#1subtitle\endcsname{#3}%
}

\endinput
%%
%% End of confprogbook.cls
