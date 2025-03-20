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

#let template(
  lang: "en",
  title: [],
  faculty: [],
  authors: (), 
  advisors: (),
  date: none,
  date-format: "[month repr:long] [day padding:zero], [year repr:full]",
  abstract: [], 
  keywords: (),
  table-of-contents: (enable: false, title: ""),
  table-index: (enabled: false, title: ""),
  figure-index: (enabled: false, title: ""),
  watermark: none, 
  appendix: (
    enabled: false,
    title: "",
    heading-numbering-format: "",
    body: none,
  ),
  bibliography: none,
  body
) = {  
  set text(lang: lang)

  // Metadata
  set document(title: title, author: authors, description: abstract, keywords: keywords)

  // Body font.
  set text(size: 12pt)
  // Set raw text font.
  show raw: set text(font: ("DejaVu Math TeX Gyre"), size: 9pt)
  // Show table captions on top
  show figure.where(
    kind: table
  ): set figure.caption(position: top)
  // Page Config.
  set page(
    paper: "a4",
    margin: (bottom: 1.75cm, top: 2.25cm),
    background: rotate(-45deg, 
      text(120pt, fill: rgb(230, 230, 230))[*#watermark*]
    ),
  )
  set par(justify: true)


  //  table style
  // set size and header-color
  show table: set text(size: 9pt, font: "DejaVu Math TeX Gyre")
  set table(
    fill: (x, y) => if y == 0 { color.rgb(204, 204, 255) },
  )


  // Cover page.
  page(
    align(center, block(width: 90%)[
        #image("Images/uci_logo.jpg", width: 40%)

        #v(2em)

        // University
        #text(size: 10pt)[Universidad de las Ciencias Informáticas]

        #v(-0.5em)

        // Faculty
        #text(size: 8pt)[#faculty]

        #v(5em)

        // Title
        #text(size: 18pt)[#title]

        #v(5em)

        // type of document
        #text[*Trabajo de diploma para optar por el título de  Ingeniero en Ciencias Informáticas*]

        #v(5em)

        // authors
        #text(size: 12pt, [Autor: #authors])

        // tutors
        #text(size: 12pt, [Tutores:])
        #for t in advisors {
          text(size: 12pt, t)
        }

        #if date != none {
          v-space
          text(date.display(date-format))
        }
        #v(15em)
        #text(size: 12pt, [*La Habana, 2025*])
      ],
    ),
  )


  set page()
  // Abstract
  heading[RESUMEN]
  text[#abstract]
  v(2pt)
  // keywords
  text[*Palabras clave*: #keywords.join(", ")]



  // Configure paragraph properties.
  // Default leading is 0.65em.
  // Default spacing is 1.2em.
  // set par(leading: 0.7em, spacing: 1.35em, justify: true, linebreaks: "optimized")

  // Add vertical space after headings.
  // show heading: it => {
  //   it
  //   v(2%, weak: true)
  // }


  // Outline
  if table-of-contents.enable != none {
    pagebreak()
    outline(title: table-of-contents.at("title", default: "Outline"))
  }

  // Outline - Figures
  if figure-index.enabled != none {
    pagebreak()
    outline(
      title: figure-index.at("title", default: "Figures Index"), 
      target: figure.where(kind: image)
    )
  }

  // Outline - Tables
  if table-index != none {
    pagebreak()
    outline(
      title: table-index.at("title", default: "Tables Index"), 
      target: figure.where(kind: table)
    )
  }


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
    set heading(numbering: "1.", supplement: [Capítulo])

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



#let BODY-MATTER(
  text-size,
  ship-part-page: true,
  body
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
  set heading(numbering: "1.", outlined: true)

  // show heading.where(level: 1): it => {
  //   align(right)[
  //     #line(length: 100%)
  //     #block[#it.body]
  //     #line(length: 100%)
  //   ]
  // }

  // Main headings in BODY-MATTER
  show heading.where(level: 1): it => {
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
  
  body
}




#let table_user_story(number, name, priority, risk, user, points, iterations, responsable, description, observations, picture: none) = {
  let rows = (
      // header
      table.header(
        table.cell(colspan: 2)[*Historia de Usuario*]
      ),

      // hu number + name
      [*Número:* #number],[*Nombre:* #name],

      // user
      table.cell(colspan: 2)[*Usuario:* #user], 

      // priority + risk
      [*Prioridad de negocio:* #priority],[*Riesgo en desarrollo:* #risk],

      // points + iterations
      [*Puntos estimados:* #points],[*Iteración asignada:* #iterations],

      // responsable
      table.cell(colspan: 2)[*Programador Responsable:* #responsable],

      // description
      table.cell(colspan: 2)[*Descripción:* #description],

      // observations
      table.cell(colspan: 2)[*Observaciones:* #observations],
  )

  // picture 
  if picture != none {
    rows.push(
      table.cell(colspan: 2)[
        *Prototipo Interfaz:* \
        #align(center, image(picture, width: 60%))
      ]
    ) 
  }

  figure(
    table(
      align: left,
      columns: (2fr, 3fr),
      stroke: .5pt + black,
      ..rows
    ),
    caption: [Historia de usuario #number]
  )
}