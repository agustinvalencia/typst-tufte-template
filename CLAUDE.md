# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

A single-file [Typst](https://typst.app) template (`tufte.typ`) for Tufte-style documents:
a wide left text column with a dedicated right margin for side notes. `example.typ`
demonstrates every feature and doubles as the visual regression check.

## Commands

```bash
typst compile example.typ        # build example.pdf (requires typst >= 0.15)
typst watch example.typ          # rebuild on save while editing
```

There is no test suite — verify changes by compiling `example.typ` and eyeballing the PDF.
Fonts (`Palatino`, `FiraCode Nerd Font`) must be installed locally or the compile falls back
to substitutes; `typst fonts` lists what's available.

## Packaging

`typst.toml` makes this a Typst package (`name = "tufte"`, `entrypoint = "tufte.typ"`).
`install.sh` / `uninstall.sh` manage the install into Typst's local package dir
(`.../typst/packages/local/<name>/<version>/`), so documents can `#import "@local/tufte:0.1.0": *`.
Both scripts are OS-aware and read name/version from `typst.toml` — never hard-code them elsewhere.

- `./install.sh` copies the package (for end users); `./install.sh --link` symlinks the repo so
  edits to `tufte.typ` take effect live (dev workflow — this is how the repo is currently installed).
- Bumping the version: update `version` in `typst.toml`, then re-run `install.sh`. The installer
  writes to the new `<version>` path; the old install keeps working for existing docs until removed.
- `example.typ` intentionally imports by relative path so the repo compiles standalone without the install.

## Architecture

Everything lives in `tufte.typ`. The single dependency is `@preview/drafting:0.2.2`, which
provides the margin-note machinery (`margin-note`, `inline-note`, `set-page-properties`,
`set-margin-note-defaults`).

- **`tufte(..)`** is the entry point, applied via `#show: tufte.with(...)`. It sets page
  geometry, the running header (suppressed on page 1), the footer page number, and calls the
  block builders. The key layout invariant: body content is rendered at `width: 100% - 5cm`
  (`tufte.typ:109`) while `set-margin-note-defaults(margin-right: 5cm)` reserves that 5cm strip
  for notes. Any change to one width must match the other.
- **`wideblock(content)`** breaks a block out to `100% + 5cm` to span into the margin (full-bleed figures/tables).
- **Block builders** — `titleblock`, `authorsblock` (lays authors out in rows of 3),
  `abstractblock` — are called in order inside `tufte()`.
- **`note(..)`** is the numbered side note: it steps a `notecounter`, drops a superscript marker
  inline, and places a numbered `margin-note`. Pass `numbered: false` for an unnumbered note.
  `dx`/`dy` nudge the note's position.
- **`inline-review` / `side-review`** are colored annotation helpers for draft review passes
  (inline highlight vs. red margin flag).

Author records accept `name` (required) plus optional `role`, `organization`, and `email`;
any other key (e.g. `affiliation`) is silently ignored by `authorsblock`.
