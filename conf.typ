#let conf(
  facultad: str,
  title: str,
  authors: (), 
  tutors: (),
  abstract: [], 
  keywords: [],
  doc
) = {  
  // UCI LOGO
  figure(
    image("Images/uci_logo.jpg", width: 40%)
  )
  
  set align(center)
  text(size: 10pt)[Universidad de las Ciencias Informáticas]

  v(-0.5em)

  // FACULTAD
  set align(center)
  text(size: 8pt)[#facultad]

  v(5em)

  // TITLE
  set align(center)
  text(size: 18pt)[#title]

  v(5em)

  // TIPO
  text[*Trabajo de diploma para optar por el título de  Ingeniero en Ciencias Informáticas*]

  v(2em)

  pagebreak()

  set align(left)
  par(justify: true)[
    *RESUMEN* \
    #abstract
  ]
  text[*Palabras Clave*: #keywords]


  align(center)[
    #text(17pt)[
      #block(width: 85%)[
        // Autor: #authors.authors.first()
        // v(3mm)
        // Tutores: #authors.tutors.join(", ")
      ]
    ]
  ]
  
  v(8mm)


  pagebreak()

  outline(title: "Índice de Contenidos")
  pagebreak()
  outline(title: "Índice de Tablas", target: figure.where(kind: table))
  pagebreak()
  outline(title: "Índice de Figuras", target: figure.where(kind: image))
  pagebreak()

  set par(justify: true)
  set text(font: "New Computer Modern", size: 11pt)
  set align(left)
  doc
}
