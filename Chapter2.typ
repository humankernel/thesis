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

- *HU1*: Envío de consultas.
- *HU2*: Envío de archivos PDF.
- *HU3*: Generación de respuestas. // review
- *HU4*: Procesamiento de archivos. // review
- *HU5*: Búsqueda de documentos relevantes. // review
- *HU6*: Visualización de resultados.
- *HU7*: Regeneración de respuestas.
- *HU8*: Retroalimentación sobre respuestas.
- *HU9*: Edición de consultas previas.
- *HU10*: Ajuste de parámetros del sistema.
- *HU11*: Creación de múltiples conversaciones.
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

== Descripción de las historias de usuario

En este capítulo se definen los requisitos funcionales y no funcionales del sistema, los cuales describen, respectivamente, las funcionalidades que debe ofrecer la aplicación y las restricciones o cualidades que debe cumplir (como rendimiento, usabilidad y seguridad). En la metodología XP, estos requisitos se especifican mediante historias de usuario, redactadas en un lenguaje claro y accesible por el cliente, permitiendo encapsular de forma concisa lo que el sistema debe realizar. Este enfoque facilita la priorización, estimación y validación de cada historia, garantizando una comunicación efectiva entre desarrolladores y usuarios, y permitiendo iteraciones de desarrollo ágiles y adaptables a las necesidades reales @sommerville_ingenierisoftware_2005.




Tabla 1. HU1 – Envío de consultas
Historia de Usuario

    Código: HU1
    Nombre: Envío de consultas
    Referencia: —
    Prioridad: Alta
    Iteración asignada: 1
    Puntos Estimados: 1 semana
    Descripción: Permite al usuario escribir su consulta en el sistema y enviarla para obtener respuestas.

Tabla 2. HU2 – Generación de respuestas
Historia de Usuario

    Código: HU2
    Nombre: Generación de respuestas
    Referencia: depende de HU1
    Prioridad: Alta
    Iteración asignada: 1
    Puntos Estimados: 1 semana
    Descripción: El sistema debe procesar la consulta y generar una respuesta coherente, presentándola al usuario de forma clara y útil.

Tabla 3. HU3 – Envío de archivos PDF
Historia de Usuario

    Código: HU3
    Nombre: Envío de archivos PDF
    Referencia: —
    Prioridad: Media
    Iteración asignada: 2
    Puntos Estimados: 1 semana
    Descripción: El usuario puede adjuntar archivos PDF al sistema para su posterior análisis y uso en las respuestas.

Tabla 4. HU4 – Procesamiento de archivos
Historia de Usuario

    Código: HU4
    Nombre: Procesamiento de archivos
    Referencia: depende de HU3
    Prioridad: Alta
    Iteración asignada: 2
    Puntos Estimados: 1 semana
    Descripción: El sistema procesa los PDF, extrayendo su contenido y preparándolo para su indexación y posterior consulta.

Tabla 5. HU5 – Búsqueda de documentos relevantes
Historia de Usuario

    Código: HU5
    Nombre: Búsqueda de documentos relevantes
    Referencia: depende de HU4
    Prioridad: Alta
    Iteración asignada: 3
    Puntos Estimados: 2 semanas
    Descripción: El sistema combina representaciones densas y dispersas para encontrar los documentos más pertinentes según la consulta, utilizando una suma de pesos para equilibrar ambas búsquedas.

Tabla 6. HU6 – Visualización de resultados y score
Historia de Usuario

    Código: HU6
    Nombre: Visualización de resultados y score
    Referencia: depende de HU5
    Prioridad: Media
    Iteración asignada: 3
    Puntos Estimados: 1 semana
    Descripción: Muestra al usuario los documentos recuperados junto con una puntuación de relevancia, ayudándole a comprender por qué se seleccionaron esos resultados.

Tabla 7. HU7 – Regeneración de respuestas
Historia de Usuario

    Código: HU7
    Nombre: Regeneración de respuestas
    Referencia: depende de HU2
    Prioridad: Media
    Iteración asignada: 4
    Puntos Estimados: 1 semana
    Descripción: Permite al usuario solicitar al sistema una nueva respuesta en caso de que la inicial no satisfaga sus necesidades.

Tabla 8. HU8 – Retroalimentación sobre respuestas
Historia de Usuario

    Código: HU8
    Nombre: Retroalimentación sobre respuestas
    Referencia: depende de HU2
    Prioridad: Media
    Iteración asignada: 4
    Puntos Estimados: 1 semana
    Descripción: El usuario puede calificar o comentar la calidad de la respuesta, ayudando al sistema a refinar sus resultados y mejorar con el tiempo.

Tabla 9. HU9 – Edición de consultas previas
Historia de Usuario

    Código: HU9
    Nombre: Edición de consultas previas
    Referencia: depende de HU1
    Prioridad: Media
    Iteración asignada: 5
    Puntos Estimados: 1 semana
    Descripción: El usuario puede modificar una consulta anterior para refinar su búsqueda sin tener que iniciar un nuevo hilo de conversación.

Tabla 10. HU10 – Ajuste de parámetros del sistema
Historia de Usuario

    Código: HU10
    Nombre: Ajuste de parámetros del sistema
    Referencia: —
    Prioridad: Baja
    Iteración asignada: 5
    Puntos Estimados: 1 semana
    Descripción: El usuario puede configurar opciones como el peso de las búsquedas densas y dispersas, así como otros parámetros de rendimiento, para personalizar el comportamiento del sistema.

Tabla 11. HU11 – Gestión de múltiples conversaciones
Historia de Usuario

    Código: HU11
    Nombre: Gestión de múltiples conversaciones
    Referencia: depende de HU1
    Prioridad: Media
    Iteración asignada: 6
    Puntos Estimados: 2 semanas
    Descripción: Permite al usuario mantener varias conversaciones paralelas con el sistema, facilitando la organización de diferentes contextos y temas de consulta.

Tabla 12. HU12 – Limpieza del chat
Historia de Usuario

    Código: HU12
    Nombre: Limpieza del chat
    Referencia: depende de HU11
    Prioridad: Baja
    Iteración asignada: 6
    Puntos Estimados: 1 semana
    Descripción: El usuario puede eliminar el historial de la conversación para iniciar una sesión limpia, sin referencias a interacciones anteriores.

Tabla 13. HU13 – Inclusión de citas en las respuestas
Historia de Usuario

    Código: HU13
    Nombre: Inclusión de citas en las respuestas
    Referencia: depende de HU2
    Prioridad: Media
    Iteración asignada: 7
    Puntos Estimados: 1 semana
    Descripción: El sistema debe proporcionar referencias o citas en las respuestas, cuando corresponda, para sustentar la información y permitir su verificación por parte del usuario.


== Diseño 

=== Arquitectura de software

=== Patrones de diseño 

=== Diagrama de clases

no si es XP

== Evaluación

== Conclusiones parciales
