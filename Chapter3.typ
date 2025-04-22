#import "@preview/lilaq:0.2.0" as lq
#import "template.typ": unit_test


= Implementación y realización de pruebas <chapter3>

// - [ ] una breve explicación del objetivo que persigue el capítulo, 
// - [ ] los principales contenidos que aborda, 
// - [ ] la estructura que puede encontrar el lector en su composición
// - [ ] un breve texto introductorio a las temáticas principales que aborda el capítulo

Este capítulo presenta la implementación de la solución propuesta y las pruebas realizadas para evaluar su funcionamiento. Se detallan los mecanismos empleados para la verificación del sistema, así como los resultados obtenidos. Además, se analiza la transformación alcanzada en el objeto de estudio y la factibilidad técnica de la solución.

// CAP 3.1
// - [ ] el diseño de los mecanismos utilizados para la verificación y validación de la solución propuesta
// - [ ] su ejecución y los resultados obtenidos

// CAP 3.2
// - [ ] la aplicación de los métodos y técnicas científicos que demuestran la transformación lograda por la solución propuesta en el objeto de estudio, es decir los datos que demuestren el tránsito del estado actual descrito en el capítulo 1 al estado deseado de dicho objeto

// CAP 3.3
// - [ ] estudio de factibilidad para la realización de la solución propuesta que igualmente demuestra la viabilidad de la solución desarrollada


== Tareas de Ingeniería

// same fucking shit that HU

== Evaluación 

La evaluación de aplicaciones que integran LLMs exige protocolos más estrictos que el software convencional, pues sus salidas son inherentemente no deterministas #footnote([Cada invocación puede generar respuestas distintas incluso con el mismo prompt]). Por ello, se recurre a métricas cuantitativas (e.g., exactitud, coherencia, robustez) y a revisiones humanas estructuradas para calibrar tanto la fidelidad de los resultados como su adecuación al contexto de uso @RAGAS. 

En el caso de sistemas RAG, la evaluación se fragmenta en dos componentes:

1. *Retrieval*: métricas como Precisión\@k o MRR miden la idoneidad y posición de los documentos recuperados.

2. *Generation*: indicadores de fidelidad y relevancia de la respuesta garantizan que el texto generado refleje correctamente la información recuperada.

=== Métricas de Recuperación

- *Precision\@k*: Esta métrica calcula la proporción de documentos relevantes entre los primeros k documentos recuperados por el sistema. Su objetivo es medir la capacidad del sistema para priorizar información útil en las primeras posiciones de la lista de resultados, lo cual es crucial dado que los usuarios suelen enfocarse en los primeros elementos presentados @Yu_2025.​
$ "Precision@k" = "# de documentos relevantes en los primeros k resultados" / k $

// -------------------------

- *Recall\@k*: Cuantifica la capacidad del sistema para recuperar el conjunto completo de documentos relevantes, calculando la proporción de documentos relevantes que se encuentran entre los k primeros resultados. Esta métrica evalúa qué tan exhaustivo es el sistema al recuperar información relevante @Yu_2025.

$ "Recall@k" = "# de documentos relevantes en los primeros k resultados" / "# total de documentos relevantes" $

// -------------------------

- *Mean Reciprocal Rank (MRR)*: Se utiliza para evaluar qué tan pronto un sistema presenta un documento relevante al usuario. Calcula el promedio del recíproco del rango del primer documento relevante para cada consulta, favoreciendo a los sistemas que muestran resultados útiles en posiciones tempranas del listado @Yu_2025.

$ "MRR" = 1 / N sum_(i=1)^N 1 / "rank"_i $

donde $"rank"_i$ es la posición del primer documento relevante para la consulta i, y _N_ es el número total de consultas evaluadas.

Esta métrica es especialmente útil cuando el usuario espera encontrar rápidamente al menos una respuesta útil entre los primeros resultados.

// -------------------------

- *Normalized Discounted Cumulative Gain (NDCG)*: Evalúa la calidad del ordenamiento considerando tanto la relevancia como la posición de los documentos. Asigna mayor peso a los documentos relevantes que aparecen en los primeros lugares, aplicando un factor de descuento. Es especialmente útil cuando la relevancia se clasifica en distintos niveles @Yu_2025.

Primero se calcula la Ganancia Acumulada con Descuento (DCG\@k):

$ "DCG@k" = sum_(i=1)^k (2^("rel"_i) - 1) / (log_2(i+1)) $

Luego, se normaliza utilizando la DCG ideal (IDCG\@k):

$ "NDCG@k" = "DCG@k" / "IDCG@k" $

donde $"rel"_i​$ representa el nivel de relevancia del documento en la posición i.

// -------------------------

- *Mean Average Precision (MAP)*: Es una métrica que resume la precisión del sistema al recuperar todos los documentos relevantes para cada consulta. Calcula primero la precisión promedio (Average Precision) por consulta, y luego obtiene el promedio general sobre todas las consultas. Esta métrica refleja tanto la exactitud como la exhaustividad del sistema  @Yu_2025.

Para una consulta individual _q_, la precisión promedio se define como:

$ "AP"(q) = (sum_(i=1)^n P(i) * "rel"(i) ) / "# de documentos relevantes para q" $

donde $P(i)$ es la precisión en la posición _i_, y $"rel"(i)$ es una función indicadora que vale 1 si el documento en la posición ii es relevante, y 0 en caso contrario.

Luego, el 'Mean Average Precision' se obtiene promediando el _AP_ sobre todas las consultas _N_:

$ "MAP" = 1 / N sum_(q=1)^N "AP"(q) $

=== Métricas de Generación

Las métricas de generación tienen como fin valorar la calidad de las respuestas producidas una vez incorporada la información recuperada. Su objetivo es comprobar que las respuestas no solo sean coherentes y precisas, sino que atiendan de forma directa la pregunta planteada @Yu_2025. 

A continuación, se describen las principales métricas introducidas por RAGAS @RAGAS:

- *Fidelidad*: Una respuesta es fiel cuando no introduce hechos ajenos o inexactitudes que no estén respaldadas por las fuentes consultadas. Esta metrica es especialmente util para ayudar a detectar las alucinaciones @RAGAS.

    Para implementarla se siguen los siguientes pasos:

    1. Extraer afirmaciones atómicas de la respuesta generada utilizando un modelo de lenguaje (LLM).

    2. Para cada afirmación, determinar si puede inferirse del contexto recuperado.

    $ "Faithfulness" = "# de afirmaciones correctas" / "# total de afirmaciones" $

// -------------------------

- *Relevancia de la respuesta*: Que tan bien la respuesta responde la pregunta del usuario @RAGAS.

    Para implementarla se siguen los siguientes pasos:

    1. Usar un LLM para generar posibles preguntas a las que la respuesta podría corresponder.

    2. Calcular vectores de embedding tanto para la pregunta original como para las preguntas generadas.

    3. Calcular la similitud de coseno entre estos embeddings.

    4. Tomar el promedio de las similitudes como la puntuación de relevancia de la respuesta.

$ "Answer Relevance" = "Promedio de la similitud del coseno entre la pregunta original y generada" $

// -------------------------

- *Relevancia del contexto*: Determina si la información recuperada es suficiente para responder la pregunta, y no contiene contenido excesivamente irrelevante @RAGAS.

Para implementarla se siguen los siguientes pasos:

1. Usar un LLM para identificar afirmaciones que son relevantes para responder la pregunta.

2. Calcular de la siguiente forma

$ "Context Relevance" = "# de afirmaciones relevantes" / "# total de afirmaciones" $

=== Resultados

En la @gen-params se muestran los parámetros de generación utilizados.

#figure(
    table(
        columns: (1.5fr, 1fr, 4fr),
        table.header([*Parámetro*], [*Valor*], [*Descripción*]),
        [Context Window],[8196],[Límite máximo de tokens que el modelo puede considerar como entrada],
        [Temperature],[0.25],[Controla la aleatoriedad en la generación; valores bajos producen respuestas más deterministas],
        [Max Tokens],[500],[Número máximo de tokens que el modelo puede generar como salida],
        [Top P],[0.95],[Limita la probabilidad acumulada de las opciones consideradas; afecta la diversidad de la respuesta],
        [Frequency Penalty],[0.5],[Penaliza tokens que ya han aparecido frecuentemente, reduciendo repeticiones],
        [Presence Penalty],[1.2],[Penaliza tokens ya mencionados, fomentando la aparición de ideas nuevas]
    ),
    caption: [Parámetros de Generación]
)<gen-params>

=== Resultados

// TODO: Retrieval Results
// TODO: Generation Results

== Pruebas de Rendimiento

En aplicaciones como los sistemas RAG, donde intervienen múltiples componentes como modelos de embeddings, y LLMs, el rendimiento puede impactar directamente en la experiencia del usuario. Estas pruebas permiten identificar cuellos de botella, tiempos de respuesta inadecuados o requerimientos excesivos de recursos, aspectos críticos especialmente en contextos donde se espera una interacción fluida y en tiempo real. Además, los resultados de estas pruebas ayudan a tomar decisiones informadas sobre optimización, escalabilidad y viabilidad del sistema en distintos entornos de implementación.

Para ello, se realizaron microbenchmarks #footnote([Es una prueba que evalúa el rendimiento de una unidad específica del sistema de forma aislada, permitiendo obtener métricas detalladas de su comportamiento.]) con el fin de medir el rendimiento individual de componentes clave del sistema, como el generador de embeddings, el reranker y el modelo generativo.

Las pruebas fueron ejecutadas en el siguiente hardware:
- i7 7700K
- 16GB RAM
- RTX 2070 (8GB VRAM)

=== Embeddings: Tiempos

Para evaluar el rendimiento del componente de generación de embeddings del sistema, se desarrolló un script que mide el tiempo promedio de codificación de un conjunto de oraciones bajo diferentes configuraciones del modelo de embeddings. Las pruebas se realizaron sobre tres conjuntos de entrada: corto (2 oraciones - 17 tokens), medio (100 oraciones - 850 tokens) y largo (1000 oraciones - 8500 tokens), utilizando distintos tamaños de lote ('batch') #footnote([El batching es una técnica que consiste en procesar múltiples entradas al mismo tiempo en lugar de una por una, optimizando así el uso de recursos y acelerando la inferencia en modelos.]).

Se consideraron cinco configuraciones del modelo: 
1. solo embeddings densos
2. solo dispersos
3. solo ColBERT
4. combinación de densos + dispersos
5. combinación completa (densos + dispersos + ColBERT).

Para cada configuración, se realizó una fase de calentamiento inicial, seguida de 10 ejecuciones cronometradas, cuyo tiempo promedio fue registrado. Esta metodología permitió comparar el rendimiento relativo de cada variante del modelo bajo diferentes volúmenes de entrada.

En la @emb-tests se muestra los resultados, donde crear los embeddings para 1000 oraciones no supera los *2 segundos*.

#figure(
  lq.diagram(
    xlabel: [\# Oraciones],
    ylabel: [Tiempo (seg)],
    width: 10cm,
    lq.plot(
      (2, 100, 1000), 
      (0.0271, 0.1839, 1.7538),
      label: [batch 32]
    ),

    lq.plot(
      (2, 100, 1000), 
      (0.0264, 0.1418, 1.4945),
      label: [batch 64]
    ),
    
    lq.plot(
      (2, 100, 1000), 
      (0.0266, 0.1312, 1.2654),
      label: [batch 256]
      )
  ),
  caption: [Benchmark Embeddings (Elaboración propia)]
)<emb-tests>

// === Reranker: Memoria y Tiempo
// TODO: hacer las del reranker o quitarlas

=== LLM: Tiempos y Memoria

Para cuantificar de forma precisa el rendimiento del componente de generación de texto, se implementó un script que simula tres escenarios de uso mediante conjuntos de prompts de distinta longitud (Short #sym.tilde 34 tokens, Medium #sym.tilde 128 tokens y Long #sym.tilde 342 tokens). Tras realizar una fase de calentamiento de tres invocaciones al modelo, el script ejecuta cinco iteraciones cronometradas con `timeit` y calcula dos métricas fundamentales: la latencia #footnote([Tiempo total que tarda el sistema en procesar una petición y ofrecer la respuesta completa]) y el throughput #footnote([Tasa de producción del sistema, expresada como la cantidad de unidades procesadas (en este caso, tokens) por segundo]).

#figure(
  lq.diagram(
    xlabel: [Throughput (tok/s)],
    ylabel: [Total (s)],
    width: 10cm,
    lq.plot(
      (16.72, 40.39, 97.76), 
      (2.0336, 3.1692, 3.4985),
    ),
  ),
  caption: [Benchmark LLM (Elaboración propia)]
)<llm-tests>

Los resultados (@llm-tests) muestran que, al aumentar la longitud del prompt, la latencia crece de 2,03 s (Short) a 3,50 s (Long), mientras que el throughput pasa de 16,7 tok/s a 97,8 tok/s. Esto indica que el modelo procesa lotes más grandes de forma más eficiente —generando muchos más tokens por segundo— aunque a costa de un ligero aumento en el tiempo total de respuesta, que en todo caso se mantiene dentro de un rango aceptable para aplicaciones interactivas.

Mas rendimiento puede ser obtenido si se optimizan los parámetros de vLLM y se hace uso de batching, adicionalmente el uso de formatos cuantizados '.gguf' tiene un soporte experimental y no esta completamente optimizado. 

Por otro lado en cuestión de consumo de memoria, se puede utilizar la siguiente formula para determinar la cantidad de VRAM o RAM requerida para ejecutar el modelo. Para ejecutar un modelo de 1.5B de parámetros con una cuantización de 8 bits el calculo seria el siguiente.

$ "M" = (P * 4B) / (32 \/ Q) * 1.2 = (1.5 * 4B) / (32 \/ 8) * 1.2 = 1.80 $ 

#figure(
  table(
    columns: (1fr, 5fr),
    stroke: 0.2pt,
    [Símbolo], [Descripción],
    [$M$], [Memoria de la GPU expresada en Gigabytes],
    [$P$], [Cantidad de parámetros en el modelo],
    [$4B$], [4 bytes, expresando los bytes usados para cada parámetro],
    [$32$], [Hay 32 bits en 4 bytes],
    [$Q$], [Cantidad de bits que se deben usar para cargar el modelo. 32, 16, 8, 4 bits.],
    [$1.2$], [Representa un 20% de sobrecarga por cargar elementos adicionales en la memoria de la GPU.]
  ),
  caption: [Memoria Requerida (GB)]
)

== Pruebas de Unidad

Las pruebas de unidad constituyen la primera línea de defensa para garantizar la calidad del sistema, validando el comportamiento correcto de funciones y componentes individuales de forma aislada. Estas pruebas se enfocan en unidades mínimas de código —como funciones, clases o métodos— con el objetivo de detectar errores lo antes posible en el ciclo de desarrollo. En este proyecto, se implementaron pruebas de unidad para cubrir los componentes clave del sistema, asegurando que cada parte funcione según lo esperado bajo diversas condiciones. Además, se utilizaron técnicas como la inyección de dependencias y el uso de mocks para aislar correctamente el entorno de ejecución y evitar efectos colaterales @pressman2019software. A continuación, se describen los módulos evaluados y los criterios utilizados para definir los casos de prueba.

Los módulos evaluados incluyen:

+ Componente de compresión de contexto: se validó que la reducción de contexto conserve la información relevante y no introduzca distorsiones.

+ Constructor de prompts: se verificó la correcta integración de los distintos elementos del prompt, así como la gestión de tokens.

+ Cliente LLM: se evaluó su comportamiento ante distintas configuraciones de generación y la correcta gestión de errores.

+ Sistema de recuperación: se comprobó que las consultas devuelvan resultados coherentes con los criterios esperados de relevancia.

+ Módulo de puntuación: se validó la aplicación correcta de las métricas y su influencia en el ordenamiento final.

Para cada componente, se definieron casos de prueba que cubren tanto escenarios típicos como
condiciones límite o errores esperados. Se utilizaron técnicas de aislamiento mediante mocks
para simular dependencias externas como llamadas a modelos, permitiendo así verificar el
comportamiento interno sin efectos colaterales ni dependencias del entorno.

Algunos ejemplos se muestran a continuación:

#unit_test(code: "1", 
  desc: "Verifica que la función `compress_history` conserve todo el historial si está dentro del límite de tokens.",
  input: "Historial de chat con 3 mensajes cortos, límite de 100 tokens.",
  expected: "La función devuelve una lista con los 3 mensajes sin truncar.",
  result: "Satisfactoria"
)

#unit_test(code: "2", 
  desc: "Evalúa que `generate_answer` utilice correctamente el modelo para generar respuestas en flujo.",
  input: "Consulta 'What is AI?', historial de 3 mensajes, 2 chunks de contexto y modelo simulado.",
  expected: "Se genera una secuencia de respuestas en orden: 'Step 1', 'Step 2', 'Answer'.",
  result: "Satisfactoria"
)

#unit_test(code: "3", 
  desc: "Verifica que el modelo de embeddings puede codificar entradas múltiples y devuelve vectores dense, sparse y colbert correctamente.",
  input: "Lista de textos: ['text1', 'text2', 'text3'], con flags return_dense=True, return_sparse=True, return_colbert=True",
  expected: "Diccionario con claves 'dense', 'sparse' y 'colbert' con tres elementos cada uno.",
  result: "Satisfactoria"
)

#unit_test(code: "4", 
  desc: "Prueba que dense_similarity devuelve una matriz de similitud con la forma esperada (consultas vs documentos).",
  input: "Vectores densos de 1 consulta y 2 documentos aleatorios",
  expected: "Matriz de salida de forma (1, 2).",
  result: "Satisfactoria"
)

#unit_test(code: "5", 
  desc: "Valida el cálculo de similitud ColBERT tomando el promedio del mejor match por token de la query.",
  input: "1 query (2 tokens) y 1 passage (3 tokens) con vectores explícitos y normalizados.",
  expected: "Similitud promedio esperada: 0.95.",
  result: "Satisfactoria"
)


#figure(
  lq.diagram(
    ylabel: [Pruebas],
    xlabel: [Iteraciones],
    width: 5cm,
    height: 6cm,
    ylim: (0, 70),
    legend: (position: (100% + .5em, 0%)),
    lq.bar(
      offset: -0.2, width: 0.4,
      (1, 2),
      (54, 62),
      label: [Aceptadas]
    ),
    lq.bar(
      offset: 0.2, width: 0.4,
      (1, 2),
      (8, 0),
      label: [Erroneas]
    ),
    lq.place(0.8, 55, align: bottom)[54],
    lq.place(1.2, 9, align: bottom)[8],
    lq.place(1.8, 63, align: bottom)[62],
    lq.place(2.2, 1, align: bottom)[0],
  ),
  caption: [Resultados de las pruebas unitarias por iteracion (Elaboración propia)]
)<unit-test-results>

== Conclusiones parciales

// - lista de conclusiones en este capítulo por lo general van dirigidas a establecer los argumentos y resultados que demuestran la veracidad, factibilidad y fiabilidad de la solución propuesta en términos de los datos obtenidos al aplicar técnicas y métodos de verificación y validación de software, técnicas y métodos de validación científica de la transformación o impacto sobre el objeto de estudio; así como la factibilidad económica de la solución propuesta

A partir del proceso de implementación y verificación de la solución propuesta, se derivan las siguientes conclusiones:

- Las pruebas de unidad y los mecanismos de evaluación sistemática aplicados demuestran que cada componente del sistema funciona conforme a lo esperado.

// - Los resultados cuantitativos obtenidos mediante métricas de recuperación y generación evidencian una mejora sustancial en la capacidad del sistema para responder consultas a partir de información distribuida. Esto valida que la solución logra efectivamente el tránsito desde el estado actual del objeto de estudio hacia un estado más avanzado y funcional.

- Las pruebas de rendimiento revelan tiempos de respuesta adecuados incluso con entradas de gran tamaño, así como un uso eficiente de recursos computacionales.

- Se incorporaron metodologías especializadas para la validación de sistemas con LLMs, que van más allá del paradigma tradicional del software. El uso de métricas de recuperación y generación aporta un marco sólido para la evaluación de sistemas RAG.

En conjunto, estos elementos validan la veracidad, fiabilidad y factibilidad técnica de la solución desarrollada, sentando las bases para su posible extensión, adaptación o implementación en contextos reales.