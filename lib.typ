// Workaround for the lack of an `std` scope.
#let std-bibliography = bibliography
#let std-smallcaps = smallcaps
#let std-upper = upper

// Overwrite the default `smallcaps` and `upper` functions with increased spacing between
// characters. Default tracking is 0pt.
#let smallcaps(body) = std-smallcaps(text(tracking: 0.6pt, body))
#let upper(body) = std-upper(text(tracking: 0.6pt, body))

// Colors used across the template.
#let stroke-color = luma(200)
#let fill-color = luma(250)

#let conf(
  title: [Your Title],
  faculty: [Your Faculty],
  paper-size: "a4",
  author: (), 
  tutor: (),
  date: none,
  date-format: "[month repr:long] [day padding:zero], [year repr:full]",
  abstract: none, 
  keywords: (),
  table-of-contents: outline(),
  appendix: (
    enabled: false,
    title: "",
    heading-numbering-format: "",
    body: none,
  ),

  // Display an index of tables
  table-index: (
    enabled: false,
    title: "", 
  ),
  // Display an index of figures
  figure-index: (
    enabled: false,
    title: "",
  ),

  bibliography: none,
  body
) = {  
  // Set the document's metadata.
  set document(title: title, author: author)
  // Set the body font.
  set text(size: 12pt) // default is 11pt

  // Set raw text font.
  show raw: set text(font: ("DejaVu Math TeX Gyre"), size: 9pt)

  // Configure page size and margins.
  set page(
    paper: paper-size,
    margin: (bottom: 1.75cm, top: 2.25cm),
  )




  // Cover page.
  page(
    // UCI LOGO
    // align(
    //   center,
    //   image("Images/uci_logo.jpg", width: 40%)
    // ),

    align(
      center,
      block(width: 90%)[
        #let v-space = v(2em, weak: true)
        #text(size: 10pt)[Universidad de las Ciencias Informáticas]
        #v(-0.5em)
        #text(size: 8pt)[#faculty]

        // TITLE
        #v(5em)
        #text(size: 18pt)[#title]

        #text[*Trabajo de diploma para optar por el título de  Ingeniero en Ciencias Informáticas*]

        #v(5em)
        #v-space
        #text(1.6em, [*Autor*: #author])
        #v(0.5em)
        #text(1.6em, [*Tutores*:])
        #for t in tutor {
          text(1.6em, t)
        }

        #if date != none {
          v-space
          text(date.display(date-format))
        }
      ],
    ),
  )



  // Abstract
  pagebreak()
  set align(left)
  par(justify: true)[
    *RESUMEN* \
    #abstract
  ]
  text[*Palabras Clave*: #keywords.join("; ")]
  

  

  // Config Post-Cover
  set par(justify: true)
  set text(font: "New Computer Modern", size: 11pt)
  set align(left)

  // Configure paragraph properties.
  // Default leading is 0.65em.
  // Default spacing is 1.2em.
  set par(leading: 0.7em, spacing: 1.35em, justify: true, linebreaks: "optimized")

  // Add vertical space after headings.
  show heading: it => {
    it
    v(2%, weak: true)
  }



  // Display index of contents.
  if table-of-contents != none {
    pagebreak()
    table-of-contents
  }

  // Display index of tables.
  if table-index != none {
    pagebreak()
    outline(
      title: table-index.at("title", default: "Índice de Tablas"), 
      target: figure.where(kind: table)
    )
  }

  // Display index of figures.
  if figure-index != none {
    pagebreak()
    outline(
      title: figure-index.at("title", default: "Índice de Figuras"), 
      target: figure.where(kind: image)
    )
  }







  // Configure page numbering and footer.
  set page(
    footer: context {
      // Get current page number.
      let i = counter(page).at(here()).first()

      // Align right for even pages and left for odd.
      let is-odd = calc.odd(i)
      let aln = if is-odd {
        right
      } else {
        left
      }

      // Are we on a page that starts a chapter?
      let target = heading.where(level: 1)
      if query(target).any(it => it.location().page() == i) {
        return align(aln)[#i]
      }

      // Find the chapter of the section we are currently in.
      let before = query(target.before(here()))
      if before.len() > 0 {
        let current = before.last()
        let gap = 1.75em
        let chapter = upper(text(size: 0.68em, current.body))
        if current.numbering != none {
          if is-odd {
            align(aln)[#chapter #h(gap) #i]
          } else {
            align(aln)[#i #h(gap) #chapter]
          }
        }
      }
    },
  )


  // Configure equation numbering.
  set math.equation(numbering: "(1)")

  // Display inline code in a small box that retains the correct baseline.
  show raw.where(block: false): box.with(
    fill: fill-color.darken(2%),
    inset: (x: 3pt, y: 0pt),
    outset: (y: 3pt),
    radius: 2pt,
  )

  // Display block code with padding.
  show raw.where(block: true): block.with(inset: (x: 5pt))

  // Break large tables across pages.
  show figure.where(kind: table): set block(breakable: true)
  set table(
    // Increase the table cell's padding
    inset: 7pt, // default is 5pt
    stroke: (0.5pt + stroke-color),
  )
  // Use smallcaps for table header row.
  show table.cell.where(y: 0): smallcaps
  
  // Wrap `body` in curly braces so that it has its own context. This way show/set rules
  // will only apply to body.
  {
    // Configure heading numbering.
    set heading(numbering: "1.")

    // Start chapters on a new page.
    show heading.where(level: 1): it => {
      if chapter-pagebreak {
        pagebreak(weak: true)
      }
      it
    }
    body
  }

  // Display appendix before the bibliography.
  if appendix.enabled {
    pagebreak()
    heading(level: 1)[#appendix.at("title", default: "Appendix")]

    // For heading prefixes in the appendix, the standard convention is A.1.1.
    let num-fmt = appendix.at("heading-numbering-format", default: "A.1.1.")

    counter(heading).update(0)
    set heading(
      outlined: false,
      numbering: (..nums) => {
        let vals = nums.pos()
        if vals.len() > 0 {
          let v = vals.slice(0)
          return numbering(num-fmt, ..v)
        }
      },
    )

    appendix.body
  }

  // Display bibliography
  if bibliography != none {
    pagebreak()
    show std-bibliography: set text(0.85em)
    // Use default paragraph properties for bibliography.
    show std-bibliography: set par(leading: 0.65em, justify: false, linebreaks: auto)
    bibliography
  }
}


// Auxiliary FMT function
#let FMT(w, size: 12pt) = {
  if type(w) == type("") {
    if      w == "top-gap" { return 7.5 * size }        // Shared by all level-1 headings
    else if w == "sq-side" { return 5.0 * size }        // Shaded square within the top-gap
    else if w == "it-hght" { return 6.5 * size }        // Room for level-1 heading bodies
    else if w == "it-size" { return 2.0 * size }        // Level-1 heading text size
    else if w == "sn-size" { return 3.5 * size }        // Square-bound number text-size
    else if w == "sq-shad" { return rgb("#00000070") }  // Shaded square shade color
    else if w == "sq-text" { return rgb("#000000A0") }  // Shaded text color
  }
  return none
}

// #let HEADER (
//   text-size,
//   lang-chapter,
//   ship-part-page: true,
//   body-matter-material
// ) = {
//   // Page settings adjustments
//   set page(
//     numbering: "1",
//     footer: context {
//       let cur-pag-num = counter(page).at(here()).first()
//       let ALIGN = if calc.even(cur-pag-num) { left } else { right }
//       set align(ALIGN)
//       [#counter(page).display("1")]
//     },
//     header: [],
//   )
// }

#let BODY-MATTER(
  text-size,
  ship-part-page: true,
  body-matter-material
) = {
  // New Page
  pagebreak()

  // Page settings adjustments
  set page(
    numbering: "1",
    footer: context {
      line(length: 100%, stroke: 0.5pt)
      text[
        Joaquin Rivas Sánchez 
        #h(1fr) 
        #counter(page).display("1")
      ]
    },
    header: [],
  )

  // Heading numbering and outlining controls
  set heading(
    numbering: "1.1.1.",
    outlined: true,
  )

  // Main headings in BODY-MATTER
  show heading.where(level: 1): it => {
    counter(figure.where(kind: image)).update(0)
    counter(figure.where(kind: table)).update(0)
    counter(math.equation).update(0)
    // Layout
    pagebreak(weak: true)
    align(right, {
      text(size: text-size)[CAPÍTULO ]
      counter(heading).display("1")
    })
    
    line(length: 100%, stroke: 0.5pt)
    block( // Chapter title
      width: 100%,
      align(
        right,
        text(
          size: FMT("it-size", size: text-size),
          weight: "extrabold",
        )[#it.body]
      )
    )
    line(length: 100%, stroke: 0.5pt)
  }

  // Book body material
  body-matter-material
}
