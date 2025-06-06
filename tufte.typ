#import "@preview/drafting:0.2.2": *

#let note(dy: -2em, content) = {
  text(
    size: 9pt,
    margin-note(
      side: right,
      justify: true,
      content,
      dy: dy,
      page-offset-x: -4cm,
    ),
  )
}

#let narrow(content) = block(width: 70%, content)

#let abstractblock(abstract) = context {
  block(inset: (left: 1cm, right: 1cm))[
    #v(1cm)
    #par(justify: true, text(abstract))
    #v(1cm)
  ]
}

#let tufte(
  title: "Untitled",
  authors: (),
  abstract: [],
  font: "Palatino",
  mono-font: "FiraCode Nerd Font",
  bib: "bibliography.bib",
  doc,
) = {
  set page(
    paper: "us-letter",
    margin: (
      left: 3cm,
      right: 2.5cm,
      top: 3cm,
      bottom: 2cm,
    ),
    header: context {
      if counter(page).get().first() > 1 {
        v(1cm)
        align(
          right + horizon,
          title,
        )
      }
    },
    footer: context {
      counter(page).display()
    },
  )
  set text(font: font)
  set align(center)
  text(24pt, title)

  set-page-properties()
  set-margin-note-defaults(
    stroke: none,
    side: right,
    margin-right: 5cm,
  )

  let n_authors = authors.len()
  let n_cols = calc.min(n_authors, 3)
  grid(
    columns: (1fr,) * n_cols,
    row-gutter: 24pt,
    ..authors.map(author => [
      #author.name \
      #author.affiliation \
      #link("mailto:" + author.email)
    ])
  )
  show raw: set text(font: mono-font, size: 8pt)

  set align(left)
  set heading(numbering: "1.1.1.1. ")
  set math.equation(numbering: "(1)")

  abstractblock[#abstract]
  doc
}
