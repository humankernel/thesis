#import "template.typ": template, BODY-MATTER
#import "@preview/hydra:0.6.0": hydra

#show: template.with(
  watermark: [],

  lang: "es",
  title: [Desarrollo de una herramienta basada en LLM y RAG para asistir el análisis de artículos científicos],
  faculty: [FACULTAD DE TECNOLOGÍAS INTERACTIVAS],
  authors: ("Joaquin Enrique Rivas Sánchez       "),
  advisors: ("Msc. Angel Alberto Vazquez Sánchez", 
             "Msc. Lisset Salazar Gómez   "),

  dedication: [
    _Le dedico esta tesis a mi Cleo, la perrita mas unica que jamas existirá, Aunque ya no estés, siempre pensaré en ti._
  ],
  acknowledgments: [
    Le doy gracias a mis padres sin los cuales no estaría vivo en primer lugar, por siempre estar ahi para mi cuando los necesite, por siempre apoyarme sin pedir nada a cambio, por impulsarme a conseguir lo que quiero, y por siempre creer en mi.

    Agradezco sinceramente al profesor Ángel y a la profesora Lisset, quienes me acompañaron como tutores a lo largo de este camino. Su orientación, paciencia y disposición para ayudarme a superar cada obstáculo han sido esenciales para la culminación de este trabajo de diploma.

    Gracias a todos los miembros de los tribunales por ayudarme a mejorar esta tesis.

    Finalmente gracias al verdadero héroe, mi computadora que frente a todos los problemas y el estrés al que la sometí nunca me defraudo y me a acompañado siempre en mis peores momentos.
  ],

  abstract: [La presente tesis de grado propone una herramienta de código abierto, basada en modelos de lenguaje de gran tamaño (LLM) y en generación aumentada por recuperación (RAG), para facilitar el análisis semiautomático de artículos científicos, adaptada al contexto tecnológico y lingüístico de Cuba. Enfrentando limitaciones como baja conectividad, restricciones geopolíticas y falta de recursos, la solución utiliza Python, vLLM y Gradio, con modelos como `DeepSeek-R1-Distill-Qwen-1.5B` y `BAAI/bge-m3`. Desarrollada bajo la metodología _Extreme Programming_ (XP), la herramienta incluye módulos de reformulación de consultas, recuperación y generación de respuestas. Evaluaciones automatizadas utilizando las métricas definidas por RAGAS revelaron resultados alentadores, validando la viabilidad técnica del sistema y sentando las bases para futuras mejoras.],
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
  appendix: (
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