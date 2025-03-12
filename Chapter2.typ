#import "@preview/fletcher:0.5.6" as fletcher: diagram, node, edge
#import fletcher.shapes: house, hexagon

= Propuesta de solución

Este capítulo se enfoca en la formulación y desarrollo de la solución propuesta, derivada de un riguroso proceso de investigación. Bajo el marco metodológico adoptado, se identifican y establecen los requisitos funcionales y no funcionales que definirán las características esenciales del sistema. Paralelamente, se examina la arquitectura de base que sustentará la implementación, generando los artefactos correspondientes a la fase de análisis y diseño.

== Descripción de la propuesta de solución

Luego de llevar a cabo un análisis exhaustivo de los conceptos y herramientas clave que se emplearán en esta investigación, se presenta la propuesta de solución en la @prototype, la cual se describe de la siguiente manera.

El usuario inicia la interacción proporcionando una consulta (query), que el sistema reformula para mejorar su claridad. A la par, el PDF se divide en fragmentos manejables, y tanto la consulta como los fragmentos se convierten en representaciones vectoriales de dos tipos: densas (que capturan la relación semántica profunda) y dispersas (que se basan más en la coincidencia de términos clave). La búsqueda híbrida combina ambas representaciones mediante una suma de pesos, equilibrando la relevancia semántica con la coincidencia exacta de términos. Los fragmentos más relevantes se almacenan en una base de datos vectorial (VectorDB) para posibles futuras consultas y luego pasan por un proceso de refinamiento y filtrado. En esta etapa, se comprime el contexto ("Context Zip") eliminando información innecesaria para optimizar la eficiencia del modelo de lenguaje (LLM). Finalmente, el LLM utiliza el contexto seleccionado para generar una respuesta precisa y alineada con la consulta del usuario.

// todo: debería incluir la parte web? 

#let blob(pos, label, tint: white, ..args) = (
  node(
    pos, align(center, label),
    width: 28mm,
    fill: tint.lighten(90%),
    stroke: tint,
    corner-radius: 5pt,
    ..args,
  ),
)

#figure(
    diagram(
      	edge-stroke: 1pt,
        node-corner-radius: 5pt,
        edge-corner-radius: 5pt,
        mark-scale: 70%,
        spacing: (5pt, 15pt),

        blob((0,0), [query], name: <query>, tint: color.silver),
        blob((1,0), [pdf], name: <pdf>, tint: color.silver),
        node(<pdf.north-west>, [
          #rect(
            image("Images/pdf.svg", height: 7pt),
            fill: color.silver,
            stroke: 0.5pt + color.silver.darken(20%),
            radius: 3pt,
            inset: 2.5pt
          )
        ] ),

        blob((0,1), [Rewrite], name: <rewrite>, tint: color.olive),
        blob((1,1), [Split], name: <split>, tint: color.olive),
      
        edge(<pdf>, "->", <split>),
        edge(<query>, "->", <rewrite>),

        node([Embedding], enclose: ((0,2), (1,2)), stroke: red, fill: red.lighten(90%), name: <e>, width: 170pt),

        edge(<rewrite>, "->", (0,2)),
        edge(<split>, "->", (1,2)),

        blob((1, 3), [VectorDB], name: <db>, tint: color.aqua),

        edge((1,2),"->",<db>), // multiple

        node([Hybrid Search], enclose: ((0, 4), (1,4)), stroke: olive, fill: olive.lighten(90%), name: <hs>, width: 170pt),

        edge((0, 2),"->", (0, 4)),
        edge(<db>,"->",(1,4)), // multiple

        blob((1, 5), [Rerank], name: <rr>, tint: color.olive),

        edge((1,4),"->",<rr>), // multiple

        blob((1, 6), [Context Zip], name: <cc>, tint: color.olive),

        edge(<rr>,"->",<cc>), // multiple rand

        node([Prompt], enclose: ((0, 7), (1,7)), stroke: blue, fill: blue.lighten(90%), name: <p>, width: 170pt),

        edge(<cc>,"->",(1,7)),
        edge((0,4),"->",(0, 7)),

        node([LLM], enclose: ((0, 8), (1,8)), stroke: red, fill: red.lighten(90%), name: <llm>, width: 170pt),

        edge(<p>, "->", <llm>),
    ),
    caption: [Propuesta de Solución (Elaboración Propia)]
)<prototype>

// == Modelo conceptual

== Requisitos de software

=== Requisitos funcionales 

- *HU1*: Envío de consultas
- *HU2*: Generación de respuestas
- *HU3*: Envío de archivos PDF
- *HU4*: Procesamiento de archivos
- *HU5*: Búsqueda de documentos relevantes
- *HU6*: Visualización de resultados
- *HU7*: Regeneración de respuestas
- *HU8*: Retroalimentación sobre respuestas
- *HU9*: Edición de consultas previas
- *HU10*: Ajuste de parámetros del sistema
- *HU11*: Gestión de múltiples conversaciones
- *HU12*: Limpieza del chat.
- *HU13*: Inclusión de citas en las respuestas.

=== Requisitos no funcionales

*Interfaz Gráfica*
- *RnF1*: Los mensajes y respuestas deben seguir una estructura y lenguaje natural.

*Usabilidad*
- *RnF2*: Se podrá interactuar de forma fácil por cualquier usuario.
- *RnF3*: Se podrá emplear cualquier idioma.

*Accesibilidad*
- *RnF4*: Las funcionalidades del sistema estarán disponibles en todo momento.

*Rendimiento*
- *RnF5*: El sistema permitirá que multiple usuarios lo empleen a la vez.
- *RnF6*: Los tiempos de respuesta no serán demasiado largos.

// todo: arreglar

*Legales*
- *RnF7*: Las herramientas seleccionadas para el desarrollo de la propuesta de solución estarán respaldadas por licencias libres.

*Hardware* 
- *RnF8*: El sistema debe ejecutarse en una computadora con procesador mayor a Intel Core i7 7700k u homólogos.
- *RnF9*: El sistema debe ejecutarse en una computadora con memoria RAM mínima de 4 Gigabytes.
- *RnF10*: El sistema debe ejecutarse en una computadora con GPU superior a Nvidia 1050ti u homólogos.
- *RnF11*: El sistema debe ejecutarse en una computadora con memoria VRAM mínima de 4 Gigabytes.

== Historias de usuario

== Diseño 

=== Arquitectura de software

=== Patrones de diseño 

=== Diagrama de clases

no si es XP

== Evaluación

== Conclusiones parciales
