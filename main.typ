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

  abstract: [La presente tesis de grado propone una herramienta de código abierto, basada en modelos de lenguaje de gran tamaño (LLMs) y en la técnica de Generación Aumentada por Recuperación (RAG), para facilitar el análisis semiautomático de artículos científicos en PDF, adaptada al contexto tecnológico y lingüístico de Cuba. Enfrentando limitaciones como baja conectividad, restricciones geopolíticas y falta de recursos, la solución utiliza Python, vLLM y Gradio, con modelos como DeepSeek y BAAI/bge m3, permitiendo una búsqueda híbrida eficaz en español. Desarrollada bajo la metodología Extreme Programming (XP), la herramienta incluye módulos de compresión de contexto, reformulación de consultas y generación de respuestas. Evaluaciones con RAGAS revelaron un alto nivel de recuperación contextual pero una fidelidad moderada en las respuestas, validando la viabilidad técnica del sistema y sentando las bases para futuras mejoras.],
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
// TODO: fix orthography and grammar

#include "Introduction.typ"
#include "Chapter1.typ"
#include "Chapter2.typ"
#include "Chapter3.typ"
#include "Conclusions.typ"
#include "Suggestions.typ"
#include "Annexes.typ"