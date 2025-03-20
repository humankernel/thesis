#import "template.typ": template, BODY-MATTER
#import "@preview/hydra:0.6.0": hydra

#show: template.with(
  lang: "es",
  title: [Desarrollo de una herramienta basada en RAG y LLMs para optimizar el análisis de
artículos científicos],
  faculty: [VERTEX: INTERACTIVE 3D ENVIRONMENTS, FACULTAD 4],
  authors: ("Joaquin Rivas Sánchez"),
  advisors: ("Msc. Angel Alberto Vazquez Sánchez", "Msc. Lisset Salazar Gómez"),
  abstract: [#lorem(80)],
  keywords: ("Aprendizaje Profundo", "RAG", "Procesamiento de Lenguaje Natural", "Contexto Cubano", "Código Abierto"),
  table-of-contents: (
    enable: true,
    title: "Índice general"
  ),
  figure-index: (
    enabled: true,
    title: "Índice de figuras"
  ),
  table-index: (
    enabled: true,
    title: "Índice de tablas"
  ),
  watermark: [Borrador],
  bibliography: bibliography(
    "refs.bib",
    title: "Bibliografía",
    style: "american-psychological-association"
  )
)

#show: BODY-MATTER.with(10pt)

#set page(header: context {
  align(right, emph("Capítulo " + hydra(1)))
  line(length: 100%)
})

// = Declaración de autoría

// Declaramos ser autores de la presente tesis y reconocemos a la Universidad de las Ciencias Informáticas
// los derechos patrimoniales sobre esta, con carácter exclusivo.

// Para que así conste firmamos la presente a los \_\_\_ dias del mes de \_\_\_\_\_\_\_\_\_ del año \_\_\_\_\_\_

// #block(width: 150pt)[
//   #line(length: 100%)
//   #align(center)[Signature]
// ]

#include "Introduction.typ"
#include "Chapter1.typ"
#include "Chapter2.typ"
#include "Chapter3.typ"
#include "Conclusions.typ"
#include "Suggestions.typ"


#set heading(numbering: none)
= Anexos