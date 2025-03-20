#import "@preview/fletcher:0.5.6" as fletcher: diagram, node, edge
#import fletcher.shapes: trapezium

= Fundamentación Teórica

En el presente capítulo se describen los conceptos relevantes que conforman el marco teórico relacionado con la investigación. También se detallan las herramientas, metodología y tecnologías que serán utilizadas para el proceso de desarrollo del software.

== Modelos de Lenguaje de Gran Tamaño (LLM)

// Que es un modelo de Aprendizaje Automático?

Un *modelo de aprendizaje automático* es un sistema computacional diseñado para aprender patrones y relaciones a partir de datos sin una programación explícita para cada tarea. Utiliza algoritmos estadísticos y técnicas de optimización para ajustar sus parámetros, permitiendo realizar predicciones o tomar decisiones basadas en la experiencia adquirida. Entre las categorías más comunes se encuentran el aprendizaje supervisado, el no supervisado y el aprendizaje por refuerzo. En el aprendizaje supervisado, el modelo es entrenado con datos etiquetados, es decir, cada entrada se encuentra asociada a una salida esperada. Este enfoque es ampliamente utilizado en tareas como la clasificación de texto, el reconocimiento de imágenes y la predicción de series temporales, ya que permite a los modelos aprender patrones a partir de ejemplos concretos. Por otro lado, en el aprendizaje no supervisado, el modelo trabaja con datos no etiquetados y debe identificar patrones o estructuras ocultas en los datos por sí mismo. Se emplea en problemas como la agrupación (clustering), la reducción de dimensionalidad y la detección de anomalías. Finalmente, el aprendizaje por refuerzo se basa en un sistema de recompensas en el que un agente interactúa con un entorno y aprende a tomar decisiones óptimas mediante prueba y error. Este enfoque ha demostrado ser particularmente efectivo en aplicaciones como el control de robots, la optimización de procesos y los juegos, donde el modelo mejora progresivamente su desempeño en función de la retroalimentación recibida @Goodfellow-et-al-2016.

#figure(
    diagram(
        node-stroke: teal + 0.3pt,
        node-fill: gradient.radial(white, teal, radius: 200%),

        node((0,0), [inputs], name: <inputs>, radius: 2em),
        node((0,1), [weights], name: <weights>, radius: 2em),
        node((1,0), [model], name: <model>, radius: 2em, shape: "rect"),
        node((2, 0), [results], name: <results>, radius: 2.1em),
        node((3, 0), [perf], name: <perf>, radius: 2em),

        edge(<inputs>, "->", <model>),
        edge(<weights>, "->", <model>),
        edge(<model>, "->", <results>),
        edge(<results>, "->", <perf>),
        edge(<perf>, "->", <weights>, bend: 40deg),
    ),
    caption: [Esquema general del proceso de aprendizaje profundo @Gugger2020-on]
)<ml-diagram>

En el contexto del aprendizaje automático, @ml-diagram ilustra de manera esquemática el flujo de trabajo de un modelo de aprendizaje de profundo, se observa que el proceso comienza con la entrada de datos (inputs), que alimenta al modelo (model). El modelo genera predicciones o resultados (results), los cuales son evaluados mediante una métrica de desempeño (perf). Adicionalmente, el modelo ajusta sus parámetros a través de un mecanismo de pesos (weights), permitiendo la optimización y mejora progresiva del rendimiento @Gugger2020-on.

// ¿Qué es un modelo del Lenguaje?

Un *modelo de lenguaje* es una representación estadística o basada en redes neuronales que asigna probabilidades a secuencias de palabras, permitiendo predecir la siguiente palabra en un texto o generar textos coherentes. Inicialmente, se utilizaron modelos de n-gramas, pero el advenimiento de las técnicas de deep learning ha permitido construir modelos mucho más sofisticados que comprenden contextos largos y capturan matices semánticos y sintácticos complejos. Los modelos del lenguaje son la base para tareas de generación y comprensión de texto, siendo esenciales en aplicaciones como sistemas de traducción automática, resumen de textos y respuestas a preguntas @Goodfellow-et-al-2016.


// El reciente desarrollo gracias a la introducción de la arquitectura Transformers? 

El desarrollo reciente en el campo de los modelos del lenguaje se debe en gran medida a la introducción de la arquitectura Transformer en 2017, presentada en el artículo "Attention is All You Need".

Esta arquitectura revolucionó el procesamiento del lenguaje natural al:

- Eliminar la dependencia secuencial: A diferencia de las redes neuronales recurrentes (RNN) y las LSTM, los Transformers procesan todas las palabras en paralelo, lo que mejora la eficiencia en el entrenamiento.
- Introducir el mecanismo de self-attention: Este mecanismo permite al modelo ponderar la importancia de cada palabra en una oración, capturando relaciones de largo alcance de manera efectiva.
- Escalar a grandes volúmenes de datos: Gracias a su arquitectura, se han desarrollado modelos de gran tamaño (como GPT, BERT y sus variantes) que utilizan billones de parámetros, lo que ha impulsado su capacidad para comprender y generar lenguaje de manera sorprendente @vaswani2023attentionneed.

Gracias a la arquitectura Transformer, los modelos de lenguaje han alcanzado un nivel sin precedentes de comprensión y generación de texto, superando enfoques tradicionales en términos de contextualización y manejo de dependencias a largo plazo @vaswani2023attentionneed. Esta evolución ha permitido aplicar estos modelos a una amplia variedad de tareas dentro del procesamiento del lenguaje natural, desde la generación automática de texto hasta sistemas avanzados de preguntas y respuestas, entre otras aplicaciones fundamentales para la inteligencia artificial moderna. A continuación, se detallan algunas de las principales tareas que estos modelos han revolucionado y los retos que aún persisten en su implementación

El impacto de la arquitectura Transformer ha sido determinante en la evolución de los Modelos de Lenguaje de Gran Tamaño (LLM), permitiendo que estos sean aplicados a una amplia variedad de tareas dentro del Procesamiento del Lenguaje Natural (PLN).

Los sistemas QA han sido profundamente transformados por los LLM, ya que permiten interpretar preguntas en lenguaje natural y proporcionar respuestas precisas, facilitando la interacción entre humanos y máquinas en asistentes virtuales y sistemas de búsqueda avanzada @gómezrodríguez2025grandesmodeloslenguajela. Del mismo modo, en la generación de texto y resumen automático, estos modelos han optimizado la creación de resúmenes concisos y coherentes a partir de grandes volúmenes de información, lo que es especialmente útil en entornos científicos @han2025retrievalaugmentedgenerationgraphsgraphrag. Por otra parte, en la traducción automática, modelos como GPT-4 han logrado capturar la semántica y gramática de múltiples idiomas, mejorando la calidad de las traducciones @openai2024gpt4technicalreport.

// Retos asociados en el uso de estos modelos para dichas tareas

Sin embargo, el uso de estos modelos en estas tareas no está exento de desafíos. Entre los principales retos se encuentran:

- *Alucinaciones y generación de información errónea*: A pesar de sus capacidades avanzadas, estos modelos pueden generar respuestas incorrectas o inconsistentes, lo que plantea riesgos en aplicaciones críticas.

- *Falta de interpretabilidad*: La naturaleza de los modelos basados en Transformers dificulta comprender cómo llegan a ciertas respuestas, lo que es un desafío en ámbitos como el derecho o la medicina, donde la transparencia es crucial.

- *Sesgos en los datos de entrenamiento*: Los LLM pueden heredar y amplificar sesgos presentes en sus datos de entrenamiento, lo que puede afectar la equidad y la objetividad de sus respuestas.

- *Limitaciones en el acceso a información actualizada*: Aunque los modelos pueden ser preentrenados con grandes volúmenes de datos, carecen de mecanismos nativos para acceder a información en tiempo real sin estrategias complementarias.


== Memoria paramétrica y no paramétrica

La *memoria paramétrica* se refiere al conocimiento almacenado directamente en los parámetros de un modelo de inteligencia artificial, como las redes neuronales profundas. Este tipo de memoria permite a los modelos generalizar información a partir de los datos con los que fueron entrenados, pero presenta desafíos como la dificultad para actualizar información sin un nuevo entrenamiento y la incapacidad de recordar datos específicos de manera precisa. Además, estos modelos pueden olvidar o distorsionar información si no han sido entrenados con suficientes ejemplos representativos.

Por otro lado, la *memoria no paramétrica* almacena información fuera de los parámetros del modelo, permitiendo acceder a datos específicos cuando es necesario. Esto resuelve algunos problemas de la memoria paramétrica, como la dificultad de actualizar información, ya que los datos pueden modificarse sin necesidad de reentrenar el modelo. También permite acceder a conocimientos más precisos y actualizados, mejorando la interpretabilidad y adaptabilidad del sistema a nuevas situaciones sin comprometer su capacidad de generalización @lewis2021retrievalaugmentedgenerationknowledgeintensivenlp.

== Técnicas para extender la memoria de un modelo

Dado que los modelos de lenguaje de gran tamaño (LLM) tienen una capacidad limitada para almacenar y actualizar información de manera eficiente, han surgido diversas técnicas para extender su memoria y mejorar su capacidad de adaptación. Estas técnicas permiten que los modelos accedan a información externa, se actualicen sin necesidad de un nuevo entrenamiento costoso y retengan conocimientos previos sin sufrir degradación @lewis2021retrievalaugmentedgenerationknowledgeintensivenlp.

=== Transferencia del Aprendizaje 

La transferencia del aprendizaje es una técnica clave para extender la memoria de un modelo, permitiendo que un modelo preentrenado en una tarea general se adapte a una tarea específica con una cantidad reducida de datos adicionales. En lugar de entrenar un modelo desde cero, se reutilizan los pesos y representaciones aprendidas en un dominio más amplio para mejorar el desempeño en un nuevo contexto.

Este enfoque ha demostrado ser particularmente útil en modelos de lenguaje, donde un modelo preentrenado en grandes corpus de texto puede especializarse en tareas más específicas como análisis de sentimientos, traducción de idiomas o recuperación de información. Sin embargo, uno de los desafíos principales es evitar el catastrophic forgetting, donde el modelo puede perder información valiosa del preentrenamiento al ajustarse a nuevos datos @vandeven2024continuallearningcatastrophicforgetting.

Una de las principales técnicas para extender la memoria de un modelo es el *fine-tuning*, que consiste en ajustar un modelo de lenguaje preentrenado con un conjunto de datos específico para adaptar su conocimiento a una nueva tarea. En este proceso, se reutilizan los parámetros aprendidos durante el entrenamiento previo y se afinan en función de nuevos ejemplos, permitiendo que el modelo retenga su conocimiento general y lo especialice en un contexto particular. A pesar de su efectividad, el fine-tuning implica un costo computacional elevado y la necesidad de datos etiquetados relevantes, lo que puede limitar su aplicabilidad en entornos con información en constante cambio @gao2024retrievalaugmentedgenerationlargelanguage.

=== Generación Aumentada por Recuperación (RAG)

La Generación Aumentada por Recuperación (RAG) es un enfoque híbrido que combina la capacidad de generación de los modelos de lenguaje con técnicas de recuperación de información externa. Con RAG, el modelo no se limita únicamente a su conocimiento almacenado en sus parámetros (memoria paramétrica), sino que además consulta fuentes externas (memoria no paramétrica) para complementar y actualizar la información que utiliza en la generación de respuestas.

Este proceso se lleva a cabo en dos fases principales:

1. *Recuperación de Información*: Se emplean técnicas de búsqueda para identificar y extraer fragmentos o documentos relevantes de una base de datos o repositorio. Esto permite acceder a datos específicos y actualizados, superando la limitación inherente de los modelos preentrenados que no pueden incorporar nuevos conocimientos sin reentrenamiento.

2. *Generación de Texto*: La información recuperada se integra en el proceso de generación del modelo, enriqueciendo el contexto y permitiendo la elaboración de respuestas más precisas y especializadas. Esta fusión mejora la capacidad del modelo para manejar temas complejos o de nicho, lo que resulta especialmente valioso en el análisis semiautomático de artículos científicos @lewis2021retrievalaugmentedgenerationknowledgeintensivenlp.

#figure(
    diagram(
        spacing: (10mm, 5mm),
        node-stroke: 1pt,
        edge-stroke: 1pt,
        mark-scale: 60%,
        
        node((0,0), [$x_1$], name: <X1>),
        node((0,1), [$x_2$], name: <X2>),
        node((0,2), [$x_3$], name: <X3>),

        node((1,1), [$e$], name: <e>, shape: trapezium.with(dir: right, fit: 3)),

        edge(<X1>, "-|>", <e>),
        edge(<X2>, "-|>", <e>),
        edge(<X3>, "-|>", <e>),

        node((2,1), [$e(x)$], name: <ex>),

        node(enclose: (<e>, <ex>, <cos>, <z1>, <z2>, <zk>), stroke: teal, inset: 10pt, snap: false),

        edge(<e>, "-|>", <ex>),

        node((3, 1), text(white, $ plus.circle $), name: <cos>, fill: black),

        edge(<ex>,  "-|>", <cos>),

        node((4, 0), [$z_1$], name: <z1>),
        node((4, 1), [$z_2$], name: <z2>),
        node((4, 2), [$z_k$], name: <zk>),

        edge(<cos>, "-|>", <z1>),
        edge(<cos>, "-|>", <z2>),
        edge(<cos>, "-|>", <zk>),

        node(enclose: (<m>, <y1>, <y2>, <y3>), stroke: blue, inset: 10pt, snap: false),

        node((5, 1), [$m$], name: <m>, shape: trapezium.with(dir: left, fit: 3)),

        edge(<z1>, "..|>", <m>),
        edge(<z2>, "..|>", <m>),
        edge(<zk>, "..|>", <m>),

        node((6, 0), [$y_1$], name: <y1>, shape: rect),
        node((6, 1), [$y_2$], name: <y2>, shape: rect),
        node((6, 2), [$y_3$], name: <y3>, shape: rect),

        edge(<m>, "-|>", <y1>),
        edge(<m>, "-|>", <y2>),
        edge(<m>, "-|>", <y3>),

        node((0, -2), [pdf], name: <pdf>),
        node((1, -2), [$e$], name: <e2>, shape: trapezium.with(dir: right, fit: 3)),
        node((2, -2), [$e(x)$], name: <e2x>),

        node(enclose: (<pdf>, <e2>, <e2x>), stroke: green, inset: 15pt, snap: false),

        edge(<pdf>, "-|>", <e2>),
        edge(<e2>, "-|>", <e2x>),
        edge(<e2x>, "-|>", <cos>, corner: right),
    ),
    caption: [Descripción general de RAG (Elaboración propia)]
)<rag>

La @rag ilustra el flujo general de un sistema de Generación Aumentada por Recuperación (RAG) dividido en tres etapas, cada una señalada con un color distinto:

- *Indexado* (recuadro verde):
    Se muestran los documentos en PDF que, tras un proceso de extracción de información, se convierten en representaciones vectoriales (o word embeddings, denotadas como $e(x)$). Este paso permite crear una base de conocimiento indexada a partir de los textos originales.

- *Recuperación* (recuadro celeste):
    Aquí se representan las consultas del usuario ($x_1,x_2,x_3$), que también son transformadas en sus correspondientes embeddings $e(x)$. El círculo negro indica el cálculo de la similitud coseno (cosine similarity) entre los embeddings de la consulta y los de la base de conocimiento, con el fin de recuperar los top_k documentos más relevantes para cada pregunta.

- *Generación* (recuadro azul):
    Finalmente, el modelo mm utiliza los documentos recuperados ($z_1,z_2,…,z_k$) y las consultas para producir las respuestas ($y_1,y_2,y_3$). Este paso corresponde a la fase de generación, donde se integran los resultados de la recuperación para brindar información coherente y contextualizada al usuario.

*Word Embedding*:
Es una representación vectorial de palabras en un espacio numérico continuo. Cada palabra se asigna a un vector de números, de manera que palabras con significados o contextos similares tienen vectores cercanos entre sí. Estos vectores se obtienen mediante técnicas de aprendizaje automático, lo que permite que los modelos capten relaciones semánticas y sintácticas en los textos @mikolov2013efficientestimationwordrepresentations.

*Cosine Similarity*:
Es una medida de similitud entre dos vectores que calcula el coseno del ángulo entre ellos. En el contexto de los word embeddings, se utiliza para determinar cuán similares son dos palabras o documentos. Un valor cercano a 1 indica que los vectores son muy similares (es decir, las palabras tienen contextos o significados parecidos), mientras que valores cercanos a 0 o negativos indican poca o ninguna similitud @mikolov2013efficientestimationwordrepresentations.

$"cosine similarity" = S_c (A, B) := cos(theta) = (A dot B) / (||A||||B||) = (sum_(i=1) A_i B_i) / ( sqrt(sum_(i=1)^n) A_i^2 dot sqrt(sum_(i=1)^n B_i^2) ) $

=== Comparativa

La @finetuning-v-rag compara los dos enfoques anteriormente mencionados: Fine-Tuning y RAG @gao2024retrievalaugmentedgenerationlargelanguage. Se analizan y contrastan estos métodos según diferentes características clave, incluyendo la adaptación a nuevos conocimientos, los requerimientos computacionales, la latencia, sus aplicaciones ideales y sus limitaciones.

#figure(
    table(
        columns: (auto, auto, auto),
        inset: 10pt,
        align: horizon,
        table.header(
            [*Características*], [*Fine-Tuning*], [*RAG*],
        ),
        [Adaptación],
        [Ajusta un modelo preentrenado sin necesidad de reentrenarlo completamente para cada nueva actualización de conocimiento],
        [No requiere reentrenamiento o reajuste; permite agregar conocimiento externo en tiempo real],
        [Requerimientos Computacionales],
        [Altos: necesita grandes cantidades de datos y recursos computacionales para entrenar],
        [Menores en comparación, ya que se enfoca en la adaptación, integración y recuperación de la información],
        [Latencia],
        [Baja, ya que el modelo responde directamente con el conocimiento integrado],
        [Mayor, debido al proceso de recuperación y generación de respuestas],
        [Aplicaciones],
        [Ideal para tareas que requieren replicar estructuras o estilos específicos],
        [Perfecto para tareas de recuperación de información y generación basada en fuentes externas],
        [Limitaciones],
        [No adecuado para incorporar rápidamente
nuevos conocimientos, posibles preocupaciones
éticas sobre la recuperación de datos],
        [Mayor complejidad técnica y, debido a tener más partes móviles, se incrementa el riesgo de un único punto de falla]
    ),
    caption: [Comparativa entre Fine-Tuning y RAG]
)<finetuning-v-rag>

Teniendo en cuenta lo anterior la arquitectura RAG para este proyecto es la mas adecuada.


== Estudio de sistemas a nivel internacional

A partir del estudio de los sistemas internacionales detallados en la @comparison (Elicit @elicit-2025, ChatGPT @chatgpt-2025, ChatPDF @chatpdf-2025, Humata @humata-2025 y Scholarcy @scholarcy-2025), se identificaron limitaciones que afectan su usabilidad en el contexto nacional. Estos servicios, desarrollados bajo modelos de software propietario y dependientes de servidores remotos, enfrentan barreras geopolíticas (como bloqueos en Cuba) y restricciones de uso (límites mensuales de artículos, páginas o mensajes), lo que limita su escalabilidad y adaptabilidad a entornos con necesidades intensivas, como la investigación académica o la implementación en regiones con censura. Estas restricciones contradicen los principios de accesibilidad universal y soberanía tecnológica, fundamentales para proyectos que buscan autonomía en el manejo de datos y herramientas.

#figure(
    table(
        columns: 6,
        inset: 10pt,
        align: horizon,
        table.header(
            [*Servicio*], [*Accesibilidad*], [*Uso Limitado*], [*Localización*], [*Código Abierto*], [*Seguridad y Privacidad*]
        ),
        [Elicit],[Si],[20 Artículos / mes],[Ingles mayormente],[No],[Servidor remoto],
        [ChatGPT],[Bloqueada],[No permite registrase desde Cuba],[Todos],[No],[Servidor remoto],
        [ChatPDF],[Bloqueada],[2 pdf y 20 mensajes / dia ],[Todos],[No],[Servidor remoto],
        [Humata],[Si],[60 paginas / mes],[Ingles mayormente],[No],[Servidor remoto],
        [Scholarcy],[Bloqueada],[10 resúmenes],[Ingles mayormente],[No],[Servidor remoto],
    ),
    caption: [Comparativa entre homólogos]
)<comparison>

Si bien las soluciones analizadas no resuelven integralmente los desafíos identificados, ofrecen referencias valiosas para el diseño de un sistema alternativo. Por ejemplo:

- Estandarización de funcionalidades: La capacidad de ChatGPT para operar en múltiples idiomas (aunque su accesibilidad sea limitada) destaca la importancia del soporte multilingüe en plataformas globales @chatgpt-2025.

- Gestión de recursos: Las restricciones de uso, como las 60 páginas/mes de Humata, aunque insuficientes, establecen un marco base para implementar modelos de suscripción escalables.

- Seguridad básica: La dependencia de servidores remotos, si bien plantea riesgos, subraya la necesidad de protocolos de privacidad robustos en futuros desarrollos.

- Gestión de referencias bibliográficas: ChatPDF se distingue por su eficacia en el manejo de referencias bibliográficas, ya que permite identificar y vincular citas con el texto original, facilitando su visualización y verificación @chatpdf-2025.

== Metodología de desarrollo de software

Una metodología es un conjunto organizado de procedimientos, técnicas, herramientas y documentos auxiliares que guían a los desarrolladores en la implementación de sistemas de información. Se estructura en fases y subfases que facilitan la elección de las técnicas más adecuadas en cada etapa del proyecto, permitiendo una planificación, gestión, control y evaluación efectivas, y asegurando la calidad y coherencia del producto final @sommerville_ingenierisoftware_2005.

Dado que el proyecto es pequeño, el tamaño del equipo consta es de un solo integrante, el tiempo es limitado, la metodología XP (Programación Extrema) es ideal porque permite recibir retroalimentación frecuente y realizar ajustes rápidos en el desarrollo. Su enfoque en ciclos iterativos cortos y pruebas constantes ayuda a garantizar que cada avance sea funcional y alineado con los objetivos del proyecto, optimizando el uso del tiempo y asegurando mejoras continuas sin desviaciones significativas.


*Metodología de desarrollo de software Programación Extrema (XP)*

XP, o Extreme Programming, es una metodología de desarrollo de software que lleva las prácticas tradicionales al extremo. Se fundamenta en iteraciones frecuentes y breves ciclos de lanzamiento, donde los requisitos se definen mediante "historias de usuario" que se transforman en tareas con pruebas de aceptación. Entre sus prácticas clave se encuentran la programación en pareja, el desarrollo guiado por pruebas (TDD) y la integración continua, lo que garantiza la calidad y la adaptabilidad del software a lo largo del proceso. Además, XP incorpora valores fundamentales y técnicas como el diseño simple, tarjetas CRC, pruebas unitarias, soluciones spike, prototipos y refactorización, lo que la hace especialmente efectiva para desarrollar sistemas complejos con equipos pequeños @sommerville_ingenierisoftware_2005. Esta se desarrolla a través de varias fases fundamentales iterativas y flexibles: Planificación, Diseño, Codificación y Pruebas.

En la *fase de planificación*, se recopilan y definen las historias de usuario que expresan de forma práctica los requisitos y objetivos del sistema. Aquí, el equipo estima el esfuerzo y los recursos necesarios para cada historia, lo que permite establecer prioridades basadas en el valor que aportan al proyecto y en las restricciones de tiempo. Este enfoque iterativo posibilita la adaptación de la planificación a medida que se van clarificando los requerimientos y surgen nuevos desafíos.

En la *fase de diseño*, se busca mantener la solución lo más sencilla posible, evitando complejidades innecesarias. El diseño es emergente, es decir, se va refinando conforme se avanza en el desarrollo, permitiendo incorporar cambios y mejoras de forma gradual. La práctica de la refactorización es fundamental en esta etapa, ya que implica reorganizar y mejorar el código sin modificar su comportamiento externo, lo que ayuda a mantener una estructura clara y eficiente.

La *fase de codificación* se centra en la implementación efectiva de las historias de usuario. Aquí, la programación en parejas fomenta la colaboración y la revisión constante del código, reduciendo errores y mejorando la calidad del software. Además, se integra el Desarrollo Basado en Pruebas (TDD), donde se escriben primero las pruebas unitarias que definen el comportamiento esperado, y luego se desarrolla el código que cumpla con estas pruebas, asegurando así que cada parte del sistema funcione correctamente desde el inicio.

Por último, en la *fase de pruebas*, se verifica de manera continua la funcionalidad y calidad del software. Se realizan pruebas unitarias para cada módulo y pruebas de aceptación basadas en las historias de usuario, lo que permite detectar y corregir errores de forma temprana. La integración continua facilita que los cambios se incorporen de inmediato al proyecto, garantizando que el sistema evolucione de manera estable y acorde a los requisitos establecidos.

== Tecnologías a utilizar

A continuación se detallan las tecnologías y herramientas utilizadas asi como la Metodología del desarrollo. 

// === Herramienta CASE
=== Lenguaje de Programación

*Python v3.12*: es un lenguaje de programación multiparadigma que prioriza la legibilidad del código y la productividad. Aunque soporta programación orientada a objetos (OOP), también integra enfoques funcionales y procedurales, lo que lo hace versátil para abordar problemas complejos.

*Ventajas de Python*:

- Sencillez: Su diseño enfocado en la legibilidad reduce la curva de aprendizaje y facilita la colaboración en equipos.

- Multiparadigma y flexible: Permite implementar OOP (herencia, polimorfismo, encapsulación) junto con técnicas funcionales (lambda, mapeo, filtrado), adaptándose a arquitecturas diversas, desde scripts simples hasta sistemas distribuidos.

- Ecosistema robusto y especializado: Cuenta con frameworks maduros como Pandas (análisis de datos), TensorFlow / PyTorch (machine learning) y FastAPI (APIs REST), que aceleran el desarrollo en dominios específicos.

- Portabilidad multiplataforma: Al ejecutarse en un intérprete, el código Python funciona en cualquier sistema operativo sin modificaciones, ideal para entornos heterogéneos.

- Gestión automática de memoria: Utiliza un recolector de basura para liberar recursos no utilizados, simplificando la administración de memoria.

- Comunidad activa y código abierto: Miles de librerías de terceros (PyPI) y documentación exhaustiva permiten resolver desafíos técnicos con rapidez, reduciendo costos de desarrollo y mantenimiento.

- Integración con lenguajes compilados: Mediante módulos como Cython o interoperabilidad con C/C++, optimiza segmentos críticos de rendimiento sin sacrificar la productividad @castro2023landscapehighperformancepythondevelop.

*Desventajas de Python*:

- Rendimiento en tiempo real limitado: Al ser interpretado, su ejecución es más lenta que lenguajes compilados como C/C++ o Rust. Esto puede ser un cuello de botella en aplicaciones de alta concurrencia o procesamiento masivo.

- Global Interpreter Lock (GIL): Restringe la ejecución paralela de hilos, limitando el aprovechamiento de multi-core en tareas intensivas.

- Dificultades en empaquetado y despliegue: La gestión de dependencias (ej. conflictos entre versiones con pip) y la creación de ejecutables autónomos pueden ser complejas, aunque herramientas como UV o Docker simplifican estos procesos.

- Tipado dinámico: Aunque favorece la flexibilidad, puede generar errores en tiempo de ejecución difíciles de depurar @castro2023landscapehighperformancepythondevelop.

=== Modelos LLM 

*DeepSeek-R1-Distill-Qwen-1.5B-Q8_0*: es una versión cuantizada #footnote[Técnica de compresión que reduce la precisión numérica de los pesos del modelo. Esto disminuye significativamente el tamaño del modelo y sus requisitos computacionales, lo que lo hace más eficiente en términos de memoria y energía] y distilada #footnote[Técnica que permite transferir el conocimiento de un modelo grande y complejo, denominado "modelo profesor", a un modelo más pequeño y eficiente, conocido como "modelo alumno". Este proceso busca reducir el tamaño y la complejidad del modelo original sin comprometer significativamente su rendimiento] del modelo de lenguaje DeepSeek-R1, diseñada para ser más eficiente y compacta mientras mantiene un rendimiento sólido, especialmente en tareas de razonamiento.

*Ventajas*

- *Rendimiento en razonamiento*: Hereda capacidades de razonamiento del modelo más grande DeepSeek-R1, mostrando un rendimiento impresionante en tareas de matemáticas y razonamiento lógico.

- *Versatilidad*: Puede ser utilizado en una variedad de aplicaciones, desde generación de texto hasta tareas de comprensión del lenguaje.

- *Licencia permisiva*: Está disponible bajo la licencia Apache 2.0, que permite su uso comercial sin restricciones.

- *Flexibilidad de implementación*: Disponible en varios formatos y niveles de cuantización, lo que permite su uso en diferentes tipos de dispositivos y aplicaciones @deepseekai2025deepseekr1incentivizingreasoningcapability.

*BAAI/bge-m3*: es un modelo avanzado de embeddings #footnote[Los embeddings son representaciones numéricas de datos que capturan el significado o características de objetos como palabras, imágenes o conceptos en un espacio multidimensional. Elementos con significados similares se ubican cerca en el espacio vectorial, esto permite la búsqueda por cercanía]. Destaca por su versatilidad en tres dimensiones clave.

- Multifuncionalidad: Combina tres métodos de recuperación en un solo modelo:
  + Embeddings Densos: Vectores compactos para búsqueda semántica.
  + Recuperación léxica (sparse): Ponderación de tokens al estilo BM25.
  + Interacción multi-vector (Col-BERT): Múltiples vectores por texto para mayor precisión.

- Multilingüístico: Soporta más de 100 idiomas. Rendimiento optimizado para lenguas como inglés, español, chino, francés y árabe.

- Multigranularidad: Procesa textos desde frases cortas hasta documentos largos (hasta 8,192 tokens) esto lo hace ideal para RAG (Retrieval-Augmented Generation) con textos extensos @bge-m3.


=== Bibliotecas

*llama-cpp v0.3.17*: es un proyecto de código abierto que permite ejecutar modelos de lenguaje grandes (LLMs) de manera eficiente en hardware convencional, sin necesidad de GPUs potentes. Implementado en C/C++, optimiza el uso de CPU y RAM.

*Ventajas clave*:

- Formato GGUF: Cuantiza modelos para equilibrar rendimiento y precisión.
    
- Soporte multiplataforma: Funciona en Windows, Linux, macOS y hasta dispositivos móviles, con soporte para aceleración GPU.

- Eficiencia y privacidad: Optimizado para CPU, evita el alto consumo de energía y mantiene los datos locales.

- Flexibilidad y comunidad activa: Compatible con múltiples modelos y en constante desarrollo. @llama-cpp

*Gradio v5.20.1*: es una biblioteca de Python de código abierto diseñada para crear interfaces web interactivas para modelos de machine learning y aplicaciones de inteligencia artificial. Permite a los desarrolladores construir y desplegar interfaces gráficas de manera rápida y sencilla, sin necesidad de conocimientos avanzados en desarrollo web

*Ventajas clave*:

- Fácil de usar: Con solo unas pocas líneas de código, puedes crear una interfaz web funcional para probar o demostrar modelos de IA.
  
- Soporte para múltiples componentes: Incluye una amplia variedad de elementos interactivos, como cuadros de texto, botones, deslizadores, subida de archivos, imágenes, audio y más.

- Interactividad en tiempo real: Soporta streaming y actualizaciones dinámicas, ideal para aplicaciones como chatbot o generadores de texto.

- Personalización: Permite modificar el diseño, añadir temas personalizados y combinar múltiples componentes para crear interfaces complejas @gradio-app.

// === Entorno de desarrollo integrado

== Conclusiones parciales

Se dieron cumplimiento a los primeros objetivos específicos. por lo que se llego a las siguientes conclusiones:

- El análisis de los conceptos asociados estableció una base teórica sólida que facilitó la comprensión profunda de la problemática y los mecanismos subyacentes, permitiendo identificar las herramientas y técnicas más adecuadas para el proyecto.

- La elección de tecnologías como Python y llama.cpp definió las bases para un diseño optimizado y escalable, especialmente en entornos con recursos limitados, lo que garantiza una mayor eficiencia en el procesamiento de los modelos.

- Las características particulares del proyecto evidenciaron la necesidad de adoptar la metodología XP, que favoreció una gestión iterativa y flexible. Esta metodología permitió realizar ajustes continuos durante el desarrollo, asegurando la calidad del sistema y adaptándose rápidamente a los cambios emergentes.

