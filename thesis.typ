#import "lib.typ": conf, BODY-MATTER

#set text(lang: "es")

#show: conf.with(
  title: [Desarrollo de una herramienta basada en RAG y LLMs para optimizar el análisis de
artículos científicos],
  faculty: [VERTEX: INTERACTIVE 3D ENVIRONMENTS, FACULTAD 4],
  author: ("Joaquin Rivas Sánchez"),
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

#include "Introduction.typ"
#include "Chapter1.typ"
#include "Chapter2.typ"
#include "Chapter3.typ"
#include "Conclusions.typ"
#include "Suggestions.typ"


#set heading(numbering: none)
= Anexos