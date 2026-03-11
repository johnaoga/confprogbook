# confprogbook — A LaTeX class for conference program books

[![License: LPPL 1.3c](https://img.shields.io/badge/License-LPPL_1.3c-blue.svg)](https://www.latex-project.org/lppl/)

A complete, ready-to-use LaTeX class for typesetting conference **Book of Abstracts** / **Program Books**. Built on the standard `book` class, it provides high-level commands for:

- **Cover pages** and front matter (logo, editors, copyright)
- **Programmatic table of contents** with dotted leaders and page references
- **Day/plenary/session headings** as colored boxes
- **Talk entries** with authors, affiliations, and cross-referenced page numbers
- **PDF abstract inclusion** with automatic labeling
- **Participant lists** with `mailto:` links
- **Landscape schedule tables** with accent colors
- **Fully customizable color scheme**

Originally developed for the [Benelux Meeting on Systems and Control](https://www.beneluxmeeting.nl/), generalized for any academic conference.

---

## Quick Start

```latex
\documentclass[a4paper]{confprogbook}

\conferencetitle{10th International Symposium on Examples}
\conferencedate{June 1--3, 2027}
\conferencelocation{Zurich, Switzerland}
\conferenceshort{ISE 2027}
\booktitle{Book of Abstracts}
\editors{Alice Smith, Bob Jones, and Carol Lee}
\institution{ETH Zurich}
\conferencelogo[0.15]{logo.png}

\begin{document}

\makefrontcover
\makefrontmatter

\cpbbeginprogram
\input{program}
\programpartindex
\cpbendprogram

\cpbbeginabstracts
\input{abstracts}
\cpbendabstracts

\cpbbeginparticipants
\input{participants}
\cpbendparticipants

\cpbbegincomments
\input{comments}
\cpbendcomments

\end{document}
```

## Installation

### Local installation (any system)

Copy `confprogbook.cls` into one of:

1. **Your project directory** (simplest — works immediately).
2. **Your local texmf tree:**
   ```bash
   # On Linux/macOS
   mkdir -p ~/texmf/tex/latex/confprogbook
   cp confprogbook.cls ~/texmf/tex/latex/confprogbook/
   texhash ~/texmf

   # On Windows (MiKTeX)
   # Copy to C:\Users\<you>\texmf\tex\latex\confprogbook\
   # Then refresh via MiKTeX Console > Tasks > Refresh file name database
   ```

### Overleaf

Upload `confprogbook.cls` to your Overleaf project root (same folder as `main.tex`). That's it.

## File Structure

```
confprogbook/
├── confprogbook.cls          # The LaTeX class (core deliverable)
├── confprogbook-doc.tex      # Documentation source
├── README.md                 # This file
├── LICENSE                   # LPPL 1.3c license
└── example/                  # Minimal working example
    ├── main.tex
    ├── program.tex
    ├── abstracts.tex
    ├── participants.tex
    └── comments.tex
```

## Documentation

Full documentation is in `confprogbook-doc.tex`. Compile it with:

```bash
pdflatex confprogbook-doc.tex
pdflatex confprogbook-doc.tex   # twice for TOC
```

Key sections:
- **§2 Quick Start** — minimal working example
- **§5 Program Entry Commands** — `\dayheading`, `\pleheading`, `\sesheading`, `\puttalk`
- **§6 Abstract Inclusion** — `\includepaper`
- **§7 Participant List** — `\putpart`
- **§8 Color Customization** — `\setdaycolors`, `\setplenarycolors`, `\setsessioncolors`
- **§11 Publishing to CTAN and Overleaf**

## Publishing to CTAN (for the LaTeX community)

### Step 1: Prepare the package

Ensure you have:
- `confprogbook.cls` — the class file
- `confprogbook-doc.pdf` — compiled documentation
- `README.md` — this file
- `LICENSE` — LPPL 1.3c
- `example/` — working example

### Step 2: Create the archive

```bash
# Compile documentation
cd confprogbook
pdflatex confprogbook-doc.tex
pdflatex confprogbook-doc.tex

# Create zip (from parent directory)
cd ..
zip -r confprogbook.zip confprogbook/ \
  -x "confprogbook/boa2026-bis/*" \
  -x "confprogbook/.git/*"
```

### Step 3: Submit to CTAN

1. Go to **https://ctan.org/upload**
2. Fill in:
   - **Package name:** `confprogbook`
   - **Summary:** A LaTeX class for typesetting conference program books (Book of Abstracts)
   - **Version:** 1.0
   - **License:** LPPL 1.3c
   - **Author:** John Aoga
   - **Topic:** Conference proceedings, Document class
   - **Home repository:** (your GitHub URL)
3. Upload `confprogbook.zip`
4. CTAN volunteers review and accept (typically 1–3 days)

### Step 4: TeX Live & MiKTeX integration

Once accepted on CTAN:
- **TeX Live** picks it up in the next update cycle (daily for tlcontrib, or next annual release)
- **MiKTeX** syncs within days
- Users can then install via: `tlmgr install confprogbook` (TeX Live) or MiKTeX Console

### Step 5: Overleaf availability

Once in TeX Live:
- **Automatic:** Overleaf updates its TeX Live annually. After the next update, `\documentclass{confprogbook}` works natively on Overleaf.
- **Immediate (template):** Create an Overleaf project with the class + example, then submit to the [Overleaf Gallery](https://www.overleaf.com/latex/templates) via *Menu → Submit to Gallery*.
- **Immediate (manual):** Users can always upload `confprogbook.cls` directly.

## Color Customization

```latex
% Dark blue day headings with white text
\setdaycolors{rgb}{0.1,0.2,0.5}{rgb}{0.05,0.1,0.3}{gray}{1}

% Gold plenary headings
\setplenarycolors{rgb}{0.85,0.65,0.13}{rgb}{0.72,0.53,0.04}{gray}{0}

% Light gray sessions
\setsessioncolors{gray}{0.9}{gray}{0.6}{gray}{0}
```

## Migration from Manual Setup

If you have an existing conference book with manual `\newcommand` definitions:

1. Replace `\documentclass{book}` → `\documentclass[a4paper]{confprogbook}`
2. Remove your package loading, custom commands, color definitions, and page layout
3. Add metadata commands (`\conferencetitle`, etc.)
4. Replace manual section structure with `\makefrontcover`, `\cpbbeginprogram`, etc.
5. Replace `\includepdf[...]` with `\includepaper{label}{file}`
6. Your `\puttalk`, `\putpart`, and content files work **unchanged**

## License

Copyright (c) 2026 John Aoga.

This work may be distributed and/or modified under the conditions of the
LaTeX Project Public License, version 1.3c or later.
See https://www.latex-project.org/lppl/

## Acknowledgments

Inspired by the LaTeX setup used for the *Benelux Meeting on Systems and Control* Book of Abstracts. Thanks to Gianluca Bianchin, Julien Hendrickx, Raphaël Jungers, and Erjen Lefeber.
