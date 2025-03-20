#import "@preview/fletcher:0.5.6" as fletcher: diagram, node, edge
#import "lib.typ": table_user_story
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

- *HU1*: Enviar consultas
- *HU2*: Enviar archivos PDF
- *HU3*: Generar respuestas
- *HU4*: Procesar archivos
- *HU5*: Buscar documentos relevantes
- *HU6*: Mostrar documentos recuperados y sus puntuaciones
- *HU7*: Regenerar respuesta
- *HU8*: Dar retroalimentación de una respuesta
- *HU9*: Editar una consulta previa
- *HU10*: Ajustar los parámetros del sistema
- *HU11*: Crear múltiples conversaciones
- *HU12*: Limpiar el chat
- *HU13*: Incluir citas en las respuestas

=== Requisitos no funcionales
// todo: extender
*Usabilidad*
- *RnF1*: Se podrá interactuar de forma fácil por cualquier usuario.
- *RnF2*: Se podrá emplear el idioma Ingles y Español.

*Accesibilidad*
- *RnF3*: Las funcionalidades del sistema estarán disponibles en todo momento.

*Rendimiento*
- *RnF4*: El sistema permitirá que multiple usuarios lo empleen a la vez.

*Legales*
- *RnF5*: Las herramientas seleccionadas para el desarrollo de la propuesta de solución estarán respaldadas por licencias libres.

*Hardware* 
- *RnF6*: El sistema debe ejecutarse en una computadora con procesador mayor a Intel Core i7 7700k u homólogos.
- *RnF7*: El sistema debe ejecutarse en una computadora con memoria RAM mínima de 4 Gigabytes.
- *RnF8*: El sistema debe ejecutarse en una computadora con GPU Nvidia.
- *RnF9*: El sistema debe ejecutarse en una computadora con GPU superior a Nvidia 1050ti.
- *RnF10*: El sistema debe ejecutarse en una computadora con memoria VRAM mínima de 4 Gigabytes.

== Descripción de las historias de usuario

En este capítulo se definen los requisitos funcionales y no funcionales del sistema, los cuales describen, respectivamente, las funcionalidades que debe ofrecer la aplicación y las restricciones o cualidades que debe cumplir (como rendimiento, usabilidad y seguridad). En la metodología XP, estos requisitos se especifican mediante historias de usuario, redactadas en un lenguaje claro y accesible por el cliente, permitiendo encapsular de forma concisa lo que el sistema debe realizar. Este enfoque facilita la priorización, estimación y validación de cada historia, garantizando una comunicación efectiva entre desarrolladores y usuarios, y permitiendo iteraciones de desarrollo ágiles y adaptables a las necesidades reales @sommerville_ingenierisoftware_2005.


#table_user_story(1, [Enviar consultas],
  [Alta], [Bajo],
  [Investigador],
  1, 1,
  [Joaquin Enrique Rivas Sánchez],
  [El usuario puede escribir y enviar consultas al sistema.], 
  [],
  picture: "Images/hu-enviar-consulta.png"
)

#table_user_story(2, [Enviar archivos PDF],
  [Media], [Bajo],
  [Investigador],
  1, 1,
  [Joaquin Enrique Rivas Sánchez],
  [El usuario puede enviar archivos PDF al sistema para su procesamiento de hasta 300 megabytes.], 
  [En caso de intentar enviar otros formatos de archivo, se mostrara un mensaje de advertencia.],
  picture: "Images/hu-enviar-pdf.png",
)

#table_user_story(3, [Generar respuestas],
  [Alta], [Medio],
  [],
  2, 1,
  [Joaquin Enrique Rivas Sánchez],
  [El sistema genera respuestas basadas en las consultas realizadas por el usuario.], 
  [En caso de fallar se muestra un mensaje de error.]
)

#table_user_story(4, [Procesar archivos],
  [Alta], [Alto],
  [Investigador],
  3, 2,
  [Joaquin Enrique Rivas Sánchez],
  [El sistema procesa los archivos enviados y almacena la información extraída.], 
  []
)

#table_user_story(5, [Buscar documentos relevantes],
  [Alta], [Alta],
  [],
  2, 2,
  [Joaquin Enrique Rivas Sánchez],
  [El sistema identifica y recupera documentos pertinentes en función de la consulta realizada.], 
  [En caso de no encontrar documentos relevantes no devuelve nada.]
)

#table_user_story(6, [Mostrar documentos recuperados],
  [Media], [Bajo],
  [Investigador],
  1, 1,
  [Joaquin Enrique Rivas Sánchez],
  [El sistema muestra una lista de documentos con sus respectivas puntuaciones.], 
  [En caso de no recibir documentos recuperados no se mostrara nada],
  picture: "Images/hu-mostrar-chunks.png"
)

#table_user_story(7, [Regenerar respuesta],
  [Media], [Bajo],
  [Investigador],
  1, 1,
  [Joaquin Enrique Rivas Sánchez],
  [El usuario puede solicitar al sistema que regenere una respuesta si la inicial no satisface sus necesidades.], 
  [],
  picture: "Images/hu-regenerate.png"
)

#table_user_story(8, [Dar retroalimentación de una respuesta],
  [Media], [Bajo],
  [Investigador],
  1, 1,
  [Joaquin Enrique Rivas Sánchez],
  [El usuario puede proporcionar retroalimentación sobre las respuestas del sistema. Los criterios para retroalimentar son los siguientes: Me gusta, No me gusta, Alucinación, Inapropiado, Dañino.], 
  [],
  picture: "Images/hu-retroalimentacion.png"
)

#table_user_story(9, [Editar una consulta previa],
  [Media], [Bajo],
  [Investigador],
  1, 1,
  [Joaquin Enrique Rivas Sánchez],
  [El sistema permite la edición de consultas y genera nuevas respuestas basadas en los cambios.], 
  [],
  picture: "Images/hu-editar-consulta.png"
)

#table_user_story(10, [Ajustar los parámetros del sistema],
  [Baja], [Medio],
  [Investigador],
  2, 2,
  [Joaquin Enrique Rivas Sánchez],
  [El usuario accede a opciones de configuración para modificar parámetros específicos. Los parámetros incluyen: 
    - Selección del modelo LLM
    - Temperatura del modelo
    - Máximo de tokens de salida
    - Penalización de frecuencia y de presencia
    - top-p, top-k
    - Prompt del sistema
    - Estilo del lenguaje
    ], 
  [],
  picture: "Images/hu-model-params.png"
)

#table_user_story(11, [Crear múltiples conversaciones],
  [Media], [Bajo],
  [Investigador],
  1, 1,
  [Joaquin Enrique Rivas Sánchez],
  [El usuario puede iniciar múltiples conversaciones independientes para gestionar diferentes temas o consultas.], 
  [Cada conversación maneja su propio historial y contexto.],
  picture: "Images/hu-nuevos-chats.png"
)

#table_user_story(12, [Limpiar el chat],
  [Baja], [Bajo],
  [Investigador],
  1, 1,
  [Joaquin Enrique Rivas Sánchez],
  [El usuario puede limpiar el historial del chat para comenzar una nueva conversación.], 
  [],
  picture: "Images/hu-limpiar-chat.png"
)

#table_user_story(13, [Incluir citas en las respuestas],
  [Alta], [Medio],
  [],
  2, 2,
  [Joaquin Enrique Rivas Sánchez],
  [El sistema incluye citas de fuentes relevantes en las respuestas para respaldar la información proporcionada.], 
  []
  // todo: add picture
)


== Diseño 

=== Arquitectura de software

=== Patrones de diseño 

=== Diagrama de clases

no si es XP

== Evaluación

== Conclusiones parciales
