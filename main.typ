#import "template.typ": template, BODY-MATTER
#import "@preview/hydra:0.6.0": hydra

#show: template.with(
  watermark: [],

  lang: "es",
  title: [Desarrollo de una herramienta basada en LLM y RAG \ para optimizar el análisis de artículos científicos], // TODO: cambiar 'optimizar'
  faculty: [FACULTAD DE TECNOLOGÍAS INTERACTIVAS],
  authors: ("Joaquin Enrique Rivas Sánchez       "),
  advisors: ("Msc. Angel Alberto Vazquez Sánchez", 
             "Msc. Lisset Salazar Gómez"),

  abstract: [La presente tesis de grado propone una herramienta de código abierto, basada en modelos de lenguaje de gran tamaño (LLM) y en la técnica de Generación Aumentada por Recuperación (RAG), para facilitar el análisis automatizado de artículos científicos, adaptada al contexto tecnológico y lingüístico de Cuba. Enfrentando limitaciones como baja conectividad, restricciones geopolíticas y falta de recursos, la solución utiliza Python, vLLM y Gradio, con modelos como `DeepSeek-R1-Distill-Qwen-1.5B` y `BAAI/bge-m3`. Desarrollada bajo la metodología _Extreme Programming_ (XP), la herramienta incluye módulos de reformulación de consultas, recuperación y generación de respuestas. Evaluaciones con RAGAS revelaron una fidelidad moderada en las respuestas y un alto nivel de recuperación contextual, validando la viabilidad técnica del sistema y sentando las bases para futuras mejoras.],
  keywords: ("Aprendizaje Profundo", 
             "Contexto Cubano",
             "Código Abierto",
             "Generación Aumentada por Recuperación", 
             "Procesamiento de Lenguaje Natural"),

  general-index: (enabled: true, title: "Índice general"),
  figure-index:  (enabled: true, title: "Índice de figuras"),
  table-index:   (enabled: true, title: "Índice de tablas"),

  bibliography: bibliography("refs.bib",
    title: "Bibliografía",
    style: "american-psychological-association"
  ),
  annexes: (
    (
      image: "Images/rag-eval.png", 
      caption: "Herramienta de Evaluación (Elaboración propia)", 
      ref: "rag-eval" 
    ),
    (
      image: "Images/rag.png", 
      caption: "Prototipo (Elaboración propia)", 
      ref: "prototype-rag" 
    ),
  )
)

// TODO: fix orthography and grammar
// TODO: update template

#include "Introduction.typ"
#include "Chapter1.typ"
#include "Chapter2.typ"
#include "Chapter3.typ"
#include "Conclusions.typ"
#include "Suggestions.typ"