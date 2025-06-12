#import "@preview/drafting:0.2.2": *

#let abstractblock(abstract) = context {
  block(inset: (left: 1cm, right: 1cm))[
    #v(1cm)
    #par(justify: true, text(size:9pt,abstract))
    #v(1cm)
  ]
}

#let tufte(
  title: "Untitled",
  header-title: "Docs Descriptive Heading",
  authors: (),
  abstract: [],
  font: "Palatino",
  mono-font: "FiraCode Nerd Font",
  doc,
) = {
  set page(
    paper: "us-letter",
    margin: ( left: 3cm, right: 2.5cm, top: 3cm, bottom: 2cm),
    header: context {
      if counter(page).get().first() > 1 {
        v(1cm)
        align(
          right + horizon,
          text(size:10pt,header-title),
        )
      }
    },
    footer: context {
      align(right,
      counter(page).display()
    )
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
  show raw: set text(font: mono-font, size: 7pt)

  set align(left)
  set heading(numbering: "1.1.1.1. ")
  set math.equation(numbering: "(1)")

  abstractblock[#abstract]
  text(size:10pt,doc)
}

#let notecounter = counter("notecounter")
#let note(dy: -2em, dx: -4cm, numbered:true, content, ..args) = {
  let note-number-to-display = none // Will hold the number to use

  if numbered {
    notecounter.step() // Increment the counter
    // Get the *current* state of the counter after stepping, as a content block.
    note-number-to-display = context { notecounter.display() }
  }

  // Main text marker
  let main-text-marker = if numbered {
    context {
      super(note-number-to-display) // Use the captured content for superscript
    }
  } else {
    [] // No marker
  }

  // Margin note block
  let margin-note-block = text(
    size:9pt,
    margin-note(
      if numbered {
        text(
          size:10pt, 
        {
            // Use the same captured content for superscript in margin note
            context {
              super(note-number-to-display)
            }
            text(size: 9pt, " ")
          }
        )
        content
      } else {
        content
      }
      ,dy:dy,
      page-offset-x: dx,
    )
  )

  // Return both parts
  (main-text-marker + margin-note-block)
}



#let narrow(content, width: 70%) = block(width: width, content)

#let inline-review(color:red, size:8pt, content, ..args) = {
  inline-note(
    fill: color.lighten(60%),
    text(size:size, content),
    ..args
  )

}

#let side-review(color:red, size:8pt, dx:-4cm, content, ..args) = {
  text(
  size:size,
  margin-note(
      fill:red, 
      stroke:red,
      page-offset-x: dx,
      content
    )  
  )
}
