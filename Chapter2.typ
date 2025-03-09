#import "@preview/fletcher:0.5.6" as fletcher: diagram, node, edge

= Propuesta de solución

Este capítulo se enfoca en la formulación y desarrollo de la solución propuesta, derivada de un riguroso proceso de investigación. Bajo el marco metodológico adoptado, se identifican y establecen los requisitos funcionales y no funcionales que definirán las características esenciales del sistema. Paralelamente, se examina la arquitectura de base que sustentará la implementación, generando los artefactos correspondientes a la fase de análisis y diseño.

== Descripción de la propuesta de solución

Luego de llevar a cabo un análisis exhaustivo de los conceptos y herramientas clave que se emplearán en esta investigación, se presenta la propuesta de solución en la @prototype, la cual se describe de la siguiente manera.

#figure(
    diagram(),
    caption: [Propuesta de Solución]
)<prototype>

== Modelo conceptual

== Requisitos de software

=== Requisitos funcionales 

- *RF1*: Recibir mensaje de consulta
    - Obtener el mensaje de texto 
    - Reescribir el mensaje 
- *RF2*: Procesar consulta  
    - Obtener información relevante para responder la consulta 
    - Verificar que es suficiente
    - Sintetizar una respuesta 
    - Citar referencias en la respuesta
- *RF3*: Enviar respuesta de consulta

=== Requisitos no funcionales

*Interfaz Gráfica*
- *RnF1*: Los mensajes y respuestas deben seguir una estructura y lenguaje natural.

*Usabilidad*
- *RnF2*: Se podrá interactuar de forma fácil por cualquier usuario.
- *RnF3*: Se podrá emplear cualquier idioma

*Accesibilidad*
- *RnF4*: Las funcionalidades del sistema estarán disponibles en todo momento

*Rendimiento*
- *RnF5*: El sistema permitirá que multiple usuarios lo empleen a la vez
- *RnF6*: Los tiempos de respuesta no excederán los 10 segundos

arreglar

*Legales*
- *RnF7*: Las herramientas seleccionadas para el desarrollo de la propuesta de solución estarán respaldadas por licencias libres

*Hardware* 
- *RnF8*: El sistema debe ejecutarse en una computadora con procesador mayor a Intel Core i7 7700k u homólogos.
- *RnF9*: El sistema debe ejecutarse en una computadora con memoria RAM mínima de 4 Gigabytes
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
