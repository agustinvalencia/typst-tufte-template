# typst-tufte-template

A [Typst](https://typst.app) template for **Tufte-style documents**: a wide main text
column paired with a generous right-hand margin for numbered side notes, references, and
review annotations. Inspired by the layouts of Edward Tufte.

See [`example.typ`](example.typ) for a full demonstration and [`example.pdf`](example.pdf) for the rendered result.

## Features

- Tufte-style page layout with a dedicated 5 cm margin column for notes
- Numbered (or unnumbered) **side notes** that place a superscript marker inline and the note in the margin
- **Wide blocks** that break out of the text column to span into the margin — for large figures or tables
- Title, subtitle, multi-author, and abstract blocks
- Running header (date + heading, suppressed on page 1) and centred page numbers
- Heading and equation numbering enabled by default
- BibTeX **bibliography** support
- **Draft review helpers** — inline highlights and red margin flags for marking up work in progress

## Requirements

- [Typst](https://github.com/typst/typst) **≥ 0.15**
- Fonts (installed locally, or Typst falls back to substitutes):
  - Body: **Palatino**
  - Monospace: **FiraCode Nerd Font**

  Run `typst fonts` to see what's available, or override the fonts per document (see below).

The only package dependency, [`@preview/drafting`](https://typst.app/universe/package/drafting),
is fetched automatically on first compile.

## Install as a local package

Install once and import it from any document as `@local/tufte:0.1.0` — no need to copy
`tufte.typ` into each project.

Run the installer from the repo root:

```bash
./install.sh            # copy the package into Typst's local package dir
./install.sh --link     # or symlink the repo instead (edits take effect live — good for hacking on the template)
./uninstall.sh          # remove it again
```

The scripts are OS-aware (macOS / Linux / Windows) and read the package name and version
straight from `typst.toml`, installing to
`…/typst/packages/local/<name>/<version>/`. Then, in any document:

```typ
#import "@local/tufte:0.1.0": *

#show: tufte.with(title: [My Document])
```

## Usage

Alternatively, copy `tufte.typ` (and, optionally, `bibliography.bib`) into your project and
import it by relative path — this is what [`example.typ`](example.typ) does:

```typ
#import "tufte.typ": *

#show: tufte.with(
    title: [An Example using Tufte],
    authors: (
        (
            name: "Name Lastname",
            organization: "Institute",
            email: "name.lastname@institute.com",
        ),
    ),
    abstract: lorem(60),
    date: none,
)

= Introduction

Body text goes here.#note[ And this appears as a numbered note in the margin. ]

#bibliography("bibliography.bib")
```

### Build

```bash
typst compile example.typ        # produces example.pdf
typst watch example.typ          # rebuild on every save while editing
```

## Template options

`tufte(..)` accepts the following named arguments:

| Argument | Default | Description |
|---|---|---|
| `title` | `"Untitled"` | Document title (content or string) |
| `header-title` | `"Docs Descriptive Heading"` | Text shown on the right of the running header |
| `authors` | `()` | Array of author dictionaries (see below) |
| `abstract` | `none` | Abstract content, rendered in a narrow indented block |
| `date` | `datetime.today()` | Shown at the left of the running header; pass `none` to omit |
| `font` | `"Palatino"` | Body font |
| `mono-font` | `"FiraCode Nerd Font"` | Font for raw / code spans |

### Author records

Each author is a dictionary. Only `name` is required; the rest are optional and rendered in
order. **Any other key is silently ignored.**

```typ
(
    name: "Ada Lovelace",     // required
    role: "Lead Author",      // optional
    organization: "Institute",// optional
    email: "ada@example.com", // optional
)
```

Authors are laid out in rows of three.

## Helpers

All are exported by `#import "tufte.typ": *`:

| Helper | Purpose |
|---|---|
| `note(content, numbered: true, dx: -4cm, dy: -2em)` | Side note. Drops a superscript marker inline and places the note in the margin. Set `numbered: false` for no marker; `dx`/`dy` nudge its position. |
| `wideblock(content)` | Break a block out to `100% + 5cm` so it spans into the margin — for wide figures or tables. |
| `inline-review(content, color: red, size: 8pt)` | Highlight text inline for draft review. |
| `side-review(content, color: red, dx: -4cm)` | Place a red flag in the margin for draft review. |

## Layout note

Body content is rendered at `100% - 5cm` and the matching 5 cm strip on the right is reserved
for margin notes. If you fork the template and change one of these widths, change the other to
match — see `tufte.typ`.

## License

[MIT](LICENSE) © 2025 Agustín Valencia
