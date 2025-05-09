#import "template.typ": template, BODY-MATTER
#import "@preview/hydra:0.6.0": hydra

#show: template.with(
  watermark: [Borrador],

  lang: "es",
  title: [Desarrollo de una herramienta basada en RAG y LLMs \ para optimizar el análisis de artículos científicos],
  faculty: [VERTEX: INTERACTIVE 3D ENVIRONMENTS, FACULTAD 4],
  authors: ("Joaquin Rivas Sánchez"),
  advisors: ("Msc. Angel Alberto Vazquez Sánchez", 
             "Msc. Lisset Salazar Gómez"),

  abstract: [#lorem(80)],
  keywords: ("Aprendizaje Profundo", 
             "RAG", 
             "Procesamiento de Lenguaje Natural", 
             "Contexto Cubano", 
             "Código Abierto"),

  general-index: (enabled: true, title: "Índice general"),
  figure-index:  (enabled: true, title: "Índice de figuras"),
  table-index:   (enabled: true, title: "Índice de tablas"),

  bibliography: bibliography("refs.bib",
    title: "Bibliografía",
    style: "american-psychological-association"
  ),
)

// TODO: fix template
// TODO: add abstract, conclusions, ...
// TODO: fix orthography and grammar

#include "Introduction.typ"
#include "Chapter1.typ"
#include "Chapter2.typ"
#include "Chapter3.typ"
#include "Conclusions.typ"
#include "Suggestions.typ"
#include "Annexes.typ"