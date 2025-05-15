#import "template.typ": table_user_story

#import "@preview/fletcher:0.5.6" as fletcher: diagram, node, edge
#import fletcher.shapes: house, hexagon

#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *
#show: codly-init.with()

= Propuesta de solución <chapter2>

Este capítulo se enfoca en la formulación y desarrollo de la solución propuesta, derivada de un riguroso proceso de investigación. Bajo el marco metodológico adoptado, se identifican y establecen los requisitos funcionales y no funcionales que definirán las características esenciales del sistema. Paralelamente, se examina la arquitectura de base que sustentará la implementación, generando los artefactos correspondientes a la fase de análisis y diseño.

== Descripción de la propuesta de solución

Luego de llevar a cabo un análisis exhaustivo de los conceptos y herramientas clave que se emplearán en esta investigación, se presenta la propuesta de solución en la @prototype, la cual se describe de la siguiente manera.

El sistema permite al usuario indexar documentos PDF que son segmentados en fragmentos más pequeños (chunks). A cada fragmento se le calculan representaciones vectoriales (embeddings), las cuales se almacenan en una base de datos vectorial en memoria. Cuando el usuario realiza una consulta, esta se reformula en preguntas más específicas, que también se convierten en embeddings. Luego, el sistema ejecuta una búsqueda híbrida (semántica y léxica) para recuperar los k fragmentos más relevantes desde la base vectorial. Estos se reordenan según su pertinencia y se combinan con la consulta original para formar un prompt que es procesado por el modelo de lenguaje (LLM), el cual genera una respuesta. Si la respuesta no resuelve completamente la consulta, el sistema puede formular nuevas preguntas basadas en la información aún no cubierta, repitiendo el ciclo hasta alcanzar una respuesta satisfactoria o agotar un número máximo de iteraciones. Este enfoque permite enriquecer dinámicamente el contexto ofrecido al modelo, mejorando la precisión y pertinencia de las respuestas.

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

        blob((0,0), [Query],     name: <query>,   tint: color.silver),
        blob((0,1), [Decompose], name: <decompose>, tint: color.olive),
        blob((1,0), [PDF/s], name: <pdf>,   tint: color.silver),
        blob((1,1), [Split], name: <split>, tint: color.olive),
        node([Embedding], enclose: ((0,2), (1,2)), stroke: red, fill: red.lighten(90%), name: <e>, width: 170pt),
        blob((1, 3), [VectorDB], name: <db>, tint: color.aqua),
        node([Hybrid Search], enclose: ((0, 4), (1,4)), stroke: olive, fill: olive.lighten(90%), name: <hs>, width: 170pt),
        node([Rerank], enclose: ((0, 5), (1,5)), stroke: olive, fill: olive.lighten(90%), name: <rr>, width: 170pt),
        node([Prompt], enclose: ((0, 6), (1,6)), stroke: blue, fill: blue.lighten(90%), name: <p>, width: 170pt),
        node([LLM], enclose: ((0, 7), (1,7)), stroke: red, fill: red.lighten(90%), name: <llm>, width: 170pt),
        node([Answer], enclose: ((0, 8), (1,8)), name: <res>, stroke: silver, fill: silver.lighten(90%), width: 170pt),

        edge(<query>,     "->",   <decompose>),
        edge(<pdf>,       "->",   <split>),
        edge(<decompose>, "->",   (0,2)),
        edge(<split>,     "->",   (1,2)),
        edge((1,2),       "->",   <db>),
        edge((0, 2),      "->",   (0, 4)),
        edge(<db>,        "->",   (1,4)),
        edge(<hs>,       "->",    <rr>),
        edge(<rr>,        "->",   <p>),
        edge(<p>,         "->",   <llm>),
        edge(<llm>,       "->",   <res>),
        edge(<llm.west>,  "->",   <decompose.west>, `retry`, bend: 40deg),
    ),
    caption: [Propuesta de Solución (Elaboración Propia)]
)<prototype>

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
  [Alta], [Bajo],
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
  3, 1,
  [Joaquin Enrique Rivas Sánchez],
  [El sistema procesa los archivos enviados y almacena la información extraída.], 
  []
)

#table_user_story(5, [Buscar documentos relevantes],
  [Alta], [Alta],
  [],
  2, 1,
  [Joaquin Enrique Rivas Sánchez],
  [El sistema identifica y recupera documentos pertinentes en función de la consulta realizada.], 
  [En caso de no encontrar documentos relevantes no devuelve nada.]
)

#table_user_story(6, [Mostrar documentos recuperados],
  [Media], [Bajo],
  [Investigador],
  1, 2,
  [Joaquin Enrique Rivas Sánchez],
  [El sistema muestra una lista de documentos con sus respectivas puntuaciones.], 
  [En caso de no recibir documentos recuperados no se mostrara nada],
  picture: "Images/hu-mostrar-chunks.png"
)

#table_user_story(7, [Regenerar respuesta],
  [Media], [Bajo],
  [Investigador],
  1, 2,
  [Joaquin Enrique Rivas Sánchez],
  [El usuario puede solicitar al sistema que regenere una respuesta si la inicial no satisface sus necesidades.], 
  [],
  picture: "Images/hu-regenerate.png"
)

#table_user_story(8, [Dar retroalimentación de una respuesta],
  [Media], [Bajo],
  [Investigador],
  1, 2,
  [Joaquin Enrique Rivas Sánchez],
  [El usuario puede proporcionar retroalimentación sobre las respuestas del sistema. Los criterios para retroalimentar son los siguientes: Me gusta, No me gusta, Alucinación, Inapropiado, Dañino.], 
  [],
  picture: "Images/hu-retroalimentacion.png"
)

#table_user_story(9, [Editar una consulta previa],
  [Media], [Bajo],
  [Investigador],
  1, 2,
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
  1, 2,
  [Joaquin Enrique Rivas Sánchez],
  [El usuario puede iniciar múltiples conversaciones independientes para gestionar diferentes temas o consultas.], 
  [Cada conversación maneja su propio historial y contexto.],
  picture: "Images/hu-nuevos-chats.png"
)

#table_user_story(12, [Limpiar el chat],
  [Baja], [Bajo],
  [Investigador],
  1, 2,
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
)  // todo: add picture or remove

== Plan de iteraciones

Habiendo identificado previamente las historias de usuario se debe crear el plan de iteraciones donde cada HU se convierte en tareas especificas de desarrollo y para cada uno se establecen pruebas. En cada ciclo se analizan las pruebas fallidas para prevenir que no vuelvan a ocurrir y ser corregidas.

Se acordaron 2 iteraciones que a continuación serán descritas:

- *Iteración 1:* se desarrollan las HU 1,2,3,4,5 las cuales corresponden al envió de consultas y archivos PDF; la generación de respuestas; procesamiento de archivos; la búsqueda de documentos relevantes. Al finalizar la iteración se realizaran las pruebas.

- *Iteración 2:* se desarrollan las HU 6,7,8,9,10,11,12,13 las cuales corresponden a la capacidad de mostrar documentos recuperados; regenerar, dar retroalimentación de las respuestas; editar una consulta previa; ajustar los parámetros del sistema; crear multiples conversaciones; limpiar el chat y por ultimo incluir citas en las respuestas. Al finalizar la iteración se realizaran las pruebas faltantes y la entrega final de la propuesta de solución. 

En la @hu-estimation se muestra el plan de iteraciones y se incluye el tiempo estimado por iteración asi como las HU a desarrollar. Se tomo como unidad de mediada que cada semana contaba de 5 días laborales de los cuales se trabajaran 8 horas cada día.

#figure(
  table(
    align: left,
    columns: (1.2fr, 0.4fr, 4fr, 2fr),
    stroke: .5pt + black,
    table.header(
      [*Iteración*], 
      table.cell(colspan: 2)[*Historias de usuario*], 
      [*Duración (semanas)*]
    ),
    table.cell(rowspan: 5, align: center)[1],
    [1],[Enviar consultas]                       ,table.cell(align: center)[1],
    [2],[Enviar archivos PDF]                    ,table.cell(align: center)[1],
    [3],[Generar respuestas]                     ,table.cell(align: center)[2],
    [4],[Procesar archivos]                      ,table.cell(align: center)[3],
    [5],[Buscar documentos relevantes]           ,table.cell(align: center)[2],

    table.cell(rowspan: 8, align: center)[2],
    [6] ,[Mostrar documentos recuperados]        ,table.cell(align: center)[1],
    [7] ,[Regenerar respuesta]                   ,table.cell(align: center)[1],
    [8] ,[Dar retroalimentación de una respuesta],table.cell(align: center)[1],
    [9] ,[Editar una consulta previa]            ,table.cell(align: center)[1],
    [10],[Ajustar los parámetros del sistema]    ,table.cell(align: center)[2],
    [11],[Crear múltiples conversaciones]        ,table.cell(align: center)[1],
    [12],[Limpiar el chat]                       ,table.cell(align: center)[1],
    [13],[Incluir citas en las respuestas]       ,table.cell(align: center)[2],

    table.cell(colspan: 2)[*Total*],[],table.cell(align: center)[19]
  ),
  caption: [Estimación de esfuerzo por historia de usuario]
)<hu-estimation>

#show heading.where(level: 1): set block[
  #line(length: 100%),
  heading
  #line(length: 100%),
]

== Arquitectura de software

La arquitectura de software se refiere a la estructura organizativa de un sistema de software, que incluye sus componentes principales y las relaciones entre ellos. Es el diseño de alto nivel que guía la evolución y el desarrollo del sistema, asegurando que cumpla con sus objetivos funcionales y no funcionales. Un patrón arquitectónico es una solución recurrente a problemas comunes en la construcción de software, proporcionando una estructura predefinida que se puede aplicar en diferentes contextos, ayudando a resolver desafíos de diseño. Finalmente, un estilo arquitectónico es un conjunto de reglas y restricciones que define la organización de los componentes del sistema y las interacciones entre ellos, reflejando un enfoque particular para abordar problemas de diseño en una categoría de sistemas. Un estilo puede incluir varios patrones arquitectónicos que estructuran el sistema de acuerdo con principios y prácticas específicas @richards2020fundamentals. En la propuesta de solución se hizo uso de la arquitectura por capas

*Arquitectura por Capas*

La arquitectura en capas es un patrón estructural que organiza un sistema en niveles jerárquicos, donde cada capa solo se comunica con la capa inmediatamente superior o inferior. Esta regla refuerza la separación de responsabilidades, facilita el mantenimiento y permite una evolución más controlada del sistema. Un aspecto clave de esta arquitectura es la distinción entre capas abiertas y cerradas: en una *capa cerrada*, el flujo debe pasar secuencialmente por cada capa, sin poder ser saltada; en cambio, una *capa abierta* permite que otras capas superiores accedan directamente a ella, lo que flexibiliza el diseño pero puede debilitar el aislamiento entre niveles @richards2020fundamentals.

Para la propuesta de solución se definieron 4 capas (@layered):

1. *Capa de Presentación (UI)*: Implementada con Gradio, esta capa gestiona la interacción con el usuario, permitiéndole introducir consultas y visualizar las respuestas del sistema.

2. *Capa de Lógica*: Orquesta el flujo general de la aplicación, conectando los distintos componentes.

3. *Capa de Inferencia (AI/ML)*: Aquí se realiza la generación de respuestas mediante modelos de lenguaje. Esta capa encapsula la lógica relacionada con los clientes LLM y su ejecución.

4. *Capa de Persistencia*: Representada por una 'base del conocimiento' (Vector DB) almacenada en memoria.

#figure(
    diagram(
      	edge-stroke: 1pt,
        node-corner-radius: 5pt,
        edge-corner-radius: 5pt,
        mark-scale: 70%,
        spacing: (5pt, 15pt),

        blob((0,0), [UI], name: <ui>, tint: color.red),
        blob((0,1), [Lógica], name: <logic>, tint: color.red),
        blob((0,2), [AI/ML], name: <ai>, tint: color.green),
        blob((0,3), [Persistencia], name: <persist>, tint: color.red),

        edge(<ui>, <logic>, "<->"),
        edge(<logic>, <ai>, "<->"),
        edge(<ai>, <persist>, "<->"),
    ),
    caption: [Capas del Sistema (Elaboración Propia)]
)<layered>

== Patrones de diseño 

Un patrón de diseño es una solución reutilizable y probada para problemas comunes de diseño en el desarrollo de software. A diferencia de los patrones arquitectónicos, que se enfocan en la estructura general del sistema, los patrones de diseño abordan problemas específicos en la implementación y organización del código a nivel de componentes y clases. Estos patrones ayudan a mejorar el rendimiento, mantenibilidad, la escalabilidad y la flexibilidad del software, proporcionando estructuras estandarizadas que facilitan la comunicación entre desarrolladores @GangOfFour.

=== Patrón Generador

En este proyecto, el patrón Generador (Generator) se emplea para implementar iteradores ligeros que evitan la creación de colecciones completas en memoria. Gracias a él, la interfaz gráfica puede recibir actualizaciones parciales—por ejemplo, fragmentos de respuesta o estados de avance—en cuanto estén disponibles, en lugar de esperar a que todo el procesamiento de datos finalice. Esto resulta esencial para el streaming de resultados en aplicaciones interactivas, pues mejora la capacidad de respuesta y la experiencia del usuario @vanrossum2011python.

#codly(highlights: (
  (line: 5, start: 5, end: none, fill: green),
  (line: 18, start: 5, end: none, fill: green),
), languages: codly-languages)
```python
def create_query_plan(
    query: str, plan: QueryPlan
) -> Generator[ChatMessageAndChunk, None, None]:
    # Mensaje indicando el inicio de la operación
    yield (
        ChatMessage(
            role="assistant",
            content=f"Creating Query Plan for {query}",
            metadata={
                "title": "✍ Creating Query Plan",
                "status": "pending",
            },
        ),
        [],
    )
    # ... (Lógica para generar el plan con LLM) ...
    # Mensaje indicando el fin de y el resultado
    yield (
        ChatMessage(
            role="assistant",
            content=str(plan),
            metadata={ # ... metadata ...},
        ),
        [],
    )
```

=== Máquina de Estados

Una Máquina de Estados es un patrón que permite a un objeto alterar su comportamiento cuando su estado interno cambia. Se utiliza para modelar sistemas que pueden existir en un número finito de estados y transicionan entre ellos en respuesta a eventos o condiciones. Es útil para gestionar flujos de control complejos y secuencias de operaciones ordenadas. En este código, el proceso general de la función `ask` sigue una secuencia (planificar, recuperar, generar, validar, refinar) que puede iterar hasta alcanzar un estado final ('completo'). @Finite-State-Machines.

#codly(highlights: (
  (line: 1, start: 0, end: 25, fill: green),
  (line: 2, start: 11, end: 24, fill: green),
  (line: 6, start: 38, end: 42, fill: green),
  (line: 9, start: 12, end: 25, fill: green),
  (line: 10, start: 44, end: 48, fill: green),
  (line: 15, start: 7, end: 18, fill: green),
))
```python   
state = GenerationState() # Inicializa el objeto que contendrá el estado
while not state.complete and iterations < max_iterations:
    # ... (Pasos de planificación, recuperación, generación) ...

    # El paso de validación actualiza explícitamente el estado
    yield from validate_answer(plan, state) # Puede cambiar state.complete

    # Si el estado aún no es completo, se refina el plan para la siguiente iteración
    if not state.complete:
        yield from refine_query_plan(plan, state)

    iterations += 1

# Al salir del bucle, se considera que se ha alcanzado un estado final
yield state.answer, chunks
```

=== Gestión de Configuración

Consiste en separar los datos de configuración (parámetros que pueden variar entre entornos como desarrollo o producción, rutas de los modelos, etc.) del código fuente de la aplicación. Esto mejora la flexibilidad, portabilidad y mantenibilidad, ya que permite modificar el comportamiento de la aplicación sin cambiar el código, simplemente ajustando las variables de entorno o configuración @SWEBOK.

#codly(highlights: (
  (line: 11, start: 31, end: 50, fill: green),
))
```python
class Settings(BaseModel):
    EMBEDDING_MODEL: str = os.getenv("EMBEDDING_MODEL", "BAAI/bge-m3")
    RERANKER_MODEL: str = os.getenv("RERANKER_MODEL", "BAAI/bge-reranker-v2-m3")
    LLM_MODEL: str = os.getenv("LLM_MODEL", "deepseek-ai/DeepSeek-R1-Distill-Qwen-1.5B")
    DTYPE: str = os.getenv("DTYPE", "float16")
    ...

# otro archivo.py
from settings import settings
llm_model = OpenAIClient() if settings.ENVIRONMENT == "dev" else vLLMClient()
```

=== Inyección de Dependencias

Es un patrón de diseño en el que un objeto recibe las otras instancias de objetos (sus "dependencias") que necesita, desde una fuente externa, en lugar de crearlas internamente. Esto promueve el bajo acoplamiento entre componentes y mejora la testeabilidad, ya que las dependencias pueden ser fácilmente reemplazadas por implementaciones alternativas o mocks durante las pruebas. Es una forma de implementar el principio de Inversión de Control (IoC) @Inversion-of-control.

#codly(highlights: (
  (line: 4,  start: 5,  end: 21, fill: green),
  (line: 15, start: 40, end: 41, fill: green),
  (line: 17, start: 5,  end: 29, fill: green),
  (line: 20, start: 46, end: 47, fill: green),
))
```python
def ask(
    message: Message,
    history: list[ChatMessage],
    db: KnowledgeBase, # <-- 'db' es una dependencia inyectada
    temperature: float,
    max_tokens: int,
    top_p: float,
    frequency_penalty: float,
    presence_penalty: float,
    max_iterations: int = 3,
) -> Generator[ChatMessageAndChunk, None, None]:
    query, files = extract_message_content(message)
   
    if files:
        yield from insert_files(files, db) # <- Pasa la dependencia 'db'

    use_rag = not db.is_empty
    if use_rag:
        # ...
        yield from iterative_retrieval(plan, db, chunks)
```

== Conclusiones parciales

Se llegaron a las siguientes conclusiones:
- La descripción general de la propuesta de solución ayudo a sentar las bases para la comprensión del flujo de la información y el contexto de la solución.
- Se definieron las funcionalidades especificas del sistema a traves de las historias de usuario asi como los requisitos no funcionales.
- Se obtuvo una planificación del tiempo de desarrollo a traves del plan de iteraciones asi como el orden en el que se implementaran las tareas.
- Se implementaron patrones de diseño con el fin de garantizar una mayor extensibilidad y mantenibilidad de la solución.
