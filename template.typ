#let stroke-color = luma(200)
#let fill-color   = luma(250)

#let BODY-MATTER(ship-part-page: true, body) = {
  // Page settings adjustments
  set page(
    // numbering: "1",
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

  set heading(numbering: "1.", supplement: [Capítulo])

  // Main headings in BODY-MATTER
  show heading.where(level: 1): it => {
    pagebreak(weak: true)

    // CAPITULO N
    let n = int(counter(heading).display("1"))
    if n > 0 and n < 4 {
      align(right, {
        text(size: 10pt)[CAPÍTULO ]
        counter(heading).display("1")
      })
    }

    // Chapter title
    line(length: 100%, stroke: 0.5pt)
    block( 
      width: 100%,
      align(
        right,
        text(weight: "light")[#it.body]
      )
    )
    line(length: 100%, stroke: 0.5pt)
    v(15pt)
  }
  
  body
}


// ----------------------------------- TEMPLATE -----------------------------------

#let template(
  lang: str,
  title: content,
  faculty: content,
  authors: array, 
  advisors: array,
  dedication: content,
  acknowledgments: content,
  abstract: content, 
  keywords: array,
  general-index: (enabled: false, title: ""),
  table-index:   (enabled: false, title: ""),
  figure-index:  (enabled: false, title: ""),
  watermark: content, 
  bibliography: bibliography,
  appendix: array,
  body,
) = {  
  // Metadata -----------------------------------------------------------------------
  set text(lang: lang)
  set document(title: title, author: authors, description: abstract, keywords: keywords)
  
  // Document Style -----------------------------------------------------------------
  set text(size: 12pt)
  show raw: set text(font: ("Times New Roman"), size: 9pt)
  set page(
    paper: "a4",
    margin: (bottom: 1.75cm, top: 2cm),
    background: rotate(-45deg, 
      text(120pt, fill: rgb(230, 230, 230))[*#watermark*]
    ),
  )
  set par(justify: true)

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

  // table style
  // Show table captions on top
  show figure.where(
    kind: table
  ): set figure.caption(position: top)
  // set size and header-color
  show table: set text(size: 9pt, font: "Times New Roman")
  set table(
    fill: (x, y) => if y == 0 { color.rgb(204, 204, 255) },
  )


  // Cover -------------------------------------------------------------------------
  page(
    align(center, block(width: 90%)[
        #image("Images/uci_logo.jpg", width: 40%)

        #text(size: 10pt)[Universidad de las Ciencias Informáticas]

        #v(-0.5em)

        #text(size: 8.2pt)[#faculty]

        #v(5em)

        #text(size: 20pt)[#title]

        #v(5em)

        #text(size: 11pt)[*Trabajo de diploma para optar por el título de Ingeniero en Ciencias Informáticas*]

        #v(15em)

        #text(size: 12pt)[Autor: #authors]

        #text(size: 12pt)[Tutores: #advisors.join("\n")]

        #v(10em)
        #text(size: 12pt)[*La Habana, 2025*]
      ],
    ),
  )
  show: BODY-MATTER.with()

  // Acknowledgments -------------------------------------------------------
  if dedication != none {
    set page()
    heading(numbering: none, outlined: false)[Dedicatoria]
    text[#dedication]
  }

  // Acknowledgments -------------------------------------------------------
  if acknowledgments != none {
    set page()
    heading(numbering: none, outlined: false)[Agradecimientos]
    text[#acknowledgments]
  }

  // Firms -----------------------------------------------------------------
  {
    set page()
    heading(numbering: none, outlined: false)[Declaración de autoría]

    v(18pt)

    text[Declaramos ser autores de la presente tesis y reconocemos a la Universidad de las Ciencias Informáticas los derechos patrimoniales sobre esta, con carácter exclusivo..]

    v(18pt)
    
    text[Para que así conste firmamos la presente a los 18 dias del mes de junio del año 2025.]

    v(200pt)

    align(center)[
      // Author block
      #line(length: 7cm)
      #authors \
      Autor

      // Vertical space between author and tutors
      #v(2cm)

      // Tutors in two columns
      #grid(
        columns: 2,
        gutter: 3cm,
        align(center)[
          #line(length: 7cm)
          MSc. Angel Alberto Vazquez Sánchez \
          Tutor
        ],
        align(center)[
          #line(length: 7cm)
          MSc. Lisset Salazar Gómez \
          Tutora
        ]
      )
    ]
  }
  
  

  // Abstract & Keywords ------------------------------------------------------------
  {
    set page()
    heading(numbering: none, outlined: false)[Resumen]
    text[#abstract]
    v(2pt)
    text[*Palabras clave*: #keywords.join(", ")]
  }


  // Outline ------------------------------------------------------------------------
  if general-index.enabled != none {
    set page()
    outline(title: general-index.at("title", default: "Outline"))
  }

  // Outline Figures ----------------------------------------------------------------
  if figure-index.enabled != none {
    set page()
    outline(
      title: figure-index.at("title", default: "Figures Index"), 
      target: figure.where(kind: image)
    )
  }

  // Outline Tables -----------------------------------------------------------------
  if table-index != none {
    set page()
    outline(
      title: table-index.at("title", default: "Tables Index"), 
      target: figure.where(kind: table)
    )
  }

  // Body -------------------------------------------------------------------
  body
  
  // Bibliography -------------------------------------------------------------------
  if bibliography != none {
    bibliography
  }

  // Appendix -------------------------------------------------------------------
  if appendix != none {
    set page()
    heading(numbering: none)[Appendix]

    counter(heading).update(0)
    set heading(
      outlined: false,
      numbering: (..nums) => {
        let vals = nums.pos()
        if vals.len() > 0 {
          let v = vals.slice(0)
          return numbering("A.1.1.", ..v)
        }
      },
    )
    for item in appendix [
        #figure(
          image(item.image),
          caption: [#item.caption]
        ) #label(item.ref)
        #v(4pt)
    ]
  }
}



// ----------------------------------- HELPERS --------------------------------------

#let table_user_story(
  number: int, name: str, priority: str , risk: str, user: none, weeks: int, iterations: int,  responsable: int, description: str, observations: none, picture: none) = {
  let rows = (
      table.header(table.cell(colspan: 2)[*Historia de Usuario*]),
      [*Número*: #number],[*Nombre*: #name],
      
  )
  if user != none {
    rows.push(table.cell(colspan: 2)[*Usuario*: #user])
  }

  rows.push([*Prioridad de negocio*: #priority])
  rows.push([*Riesgo en desarrollo*: #risk])
  rows.push([*Tiempo estimado*: #weeks])
  rows.push([*Iteración asignada*: #iterations])
  rows.push(table.cell(colspan: 2)[*Programador Responsable*: #responsable])
  rows.push(table.cell(colspan: 2)[*Descripción*: #description])

  if observations != none {
    rows.push(table.cell(colspan: 2)[*Observaciones*: #observations])
  }

  if picture != none {
    rows.push(
      table.cell(colspan: 2)[
        *Prototipo Interfaz*: \
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


#let table_engineering_task(number: int, hu_number: int, nombre: content, type: content, weeks: int, start_date: datetime, description: content) = {
  let end_date = start_date + duration(days: weeks * 7)
  figure(
    table(
      align: left,
      columns: (2fr, 3fr),
      stroke: .5pt + black,
      table.header(table.cell(colspan: 2)[*Tarea de Ingeniería* - HU #hu_number]),
      table.cell(colspan: 2)[*Nombre de Tarea:* #nombre], 
      [*Tipo de Tarea:* #type],[*Tiempo Estimado:* #weeks],
      [*Fecha de inicio:* #start_date.display()],[*Fecha de fin:* #end_date.display()],
      table.cell(colspan: 2)[*Descripción:* #description],
    ),
    caption: [Tarea de Ingeniería #number]
  )
}

#let unit_test(code: content, desc: content, input: content, expected: content, result: content) = figure(
  table(
    columns: (1fr, 4fr),
    align: left,
    table.header(table.cell(colspan: 2)[Caso de Prueba #code]),
    table.cell(colspan: 2)[Descripción: #desc],
    [Entrada],[#input],
    [Salida Esperada],[#expected],
    table.cell(colspan: 2)[Evaluación de la Prueba: #result]
  ),
  caption: [Caso de Prueba #code]
)
