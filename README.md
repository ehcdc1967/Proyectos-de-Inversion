# Tesis de Maestría en Ciencia de Datos  
# APLICACIÓN DE TÉCNICAS DE CIENCIA DE DATOS PARA IDENTIFICAR FACTORES ASOCIADOS A SOBRECOSTOS Y EVALUAR LA EFICIENCIA EN LA FORMULACIÓN DE PROYECTOS DE INVERSIÓN PÚBLICA  

## Resumen  
El presente estudio hace uso de la Ciencia de Datos para analizar la eficiencia de los proyectos de inversión pública priorizados por el Sistema de Programación Multianual y Gestión de Inversiones del Perú- Invierte.pe, durante las fases iniciales de formulación y evaluación. Su objetivo es identificar y anticipar la ocurrencia de sobrecostos con el fin de mejorar la eficiencia en la planificación de proyectos y uso optimizado de los recursos públicos. Para ello se aplicaron técnicas de ciencia de datos, específicamente Random Forest y XGBoost, para predecir sobrecostos en proyectos ejecutados por los gobiernos locales entre 2022 y 2024. Los resultados muestran que el modelo XGBoost alcanzó un 89.60% de F1-Score, superando en desempeño al modelo Random Forest que obtuvo un F1-score de 88.56%. Además, se identificó que los principales factores asociados a los sobrecostos incluyen la modalidad de ejecución, la existencia de modificaciones previas al expediente técnico y el tipo de municipalidad ejecutora. Estos hallazgos sugieren que la aplicación de técnicas de ciencia de datos puede fortalecer la evaluación ex ante de los proyectos de inversión pública contribuyendo a mejorar la eficiencia en la asignación del presupuesto público.

## Objetivos  

### General:  
- Aplicar técnicas de ciencia de datos para analizar la formulación de proyectos de inversión pública en Perú, identificando factores y patrones asociados con los sobrecostos con el fin de mejorar la precisión presupuestaria y optimizar la gestión de recursos en futuros proyectos.  

### Específicos:  
- Analizar los factores asociados a sobrecostos en proyectos de inversión pública, considerando variables como ubicación geográfica y nivel de gobierno.  
- Desarrollar un modelo de ciencia de datos que prediga la probabilidad de desviaciones presupuestarias en la etapa de formulación de proyectos de inversión pública.  
- Identificar patrones recurrentes de ineficiencia que permita mejorar el diseño y planificación de proyectos de inversión pública. 

## Metodología  
La investigación utiliza un enfoque cuantitativo y modelos predictivos como Random Forest y XGBoost para analizar datos históricos del Banco de Proyectos de INVIERTE.PE. Se emplearon técnicas de validación cruzada y métricas como precisión, recall y F1-score para evaluar los modelos.  

### Fuente de información  
El análisis se basa en datos obtenidos del portal de datos abiertos del Ministerio de Economía y Finanzas del Perú, específicamente del conjunto de datos relacionado con proyectos de inversión pública, disponible en [https://datosabiertos.mef.gob.pe/dataset?q=INVERSION&page=1](https://datosabiertos.mef.gob.pe/dataset?q=INVERSION&page=1). Este recurso proporciona información detallada sobre proyectos registrados, su estado, presupuestos asignados y modificaciones, entre otros aspectos clave para el estudio.  

### Diccionario de datos  
Los datos analizados contienen las siguientes variables clave:

| N  | **Variable**               | **Descripción**                                                                                                                                             |
|----|----------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------|
| 1  | CODIGO_UNICO               | Identificador único del proyecto de inversión en Sistema "Invierte.pe".                                                                                     |
| 2  | SOBRECOSTO                 | Indica si el proyecto de inversión pública tiene sobrecosto.                                                                                                |
| 3  | TIEMPO_VIABILIDAD          | Tiempo transcurrido desde registrar el proyecto hasta ser declarado viable.                                                                                 |
| 4  | TIEMPO_EJECUCION           | Tiempo de duración de la ejecución del proyecto.                                                                                                            |
| 5  | BENEFICIARIO               | Número de personas que se espera sean beneficiarios por el proyecto.                                                                                        |
| 6  | CTRL_CONCURR               | Monto de control concurrente.                                                                                                                               |
| 7  | MONTO_LAUDO                | Monto en soles debido a procesos arbitrales del proyecto.                                                                                                   |
| 8  | MODALIDAD_DIRECTA          | Modalidad de ejecución total o parcial del proyecto a cargo del gobierno local.                                                                             |
| 9  | MODALIDAD_INDIRECTA        | Modalidad de ejecución total o parcial del proyecto a cargo de institución especializada.                                                                   |
| 10 | TIPO_MUNICIPALIDAD         | Clasificación de las municipalidades (PMM-PI) elaborada por el MEF.                                                                                         |
| 11 | MODIFICACION_F8            | Modificaciones del proyecto antes del expediente técnico.                                                                                                   |
| 12 | EXPEDIENTE_TECNICO         | Expediente técnico de un proyecto de inversión pública inscrito en el Sistema Invierte.pe.                                                                  |
| 13 | REGISTRADO_PMI             | Proyecto de inversión pública formalmente incluido en el Programa Multianual de Inversiones (PMI).                                                          |
| 14 | NATURALEZA_MEJORAMIENTO    | Naturaleza del proyecto que busca mejorar la calidad, eficiencia o funcionalidad de bienes o servicios existentes.                                          |
| 15 | NATURALEZA_AMPLIACION      | Naturaleza del proyecto que busca incrementar la capacidad o el alcance de un bien o servicio público existente.                                            |
| 16 | NATURALEZA_RECUPERACION    | Naturaleza del proyecto que busca restaurar o restablecer la funcionalidad de un bien o servicio público dañado o inoperativo.                              |
| 17 | NATURALEZA_CREACION        | Naturaleza del proyecto que busca generar un bien o servicio público nuevo.                                                                                 |
| 18 | FUNCION                    | Descripción de la función.                                                                                                                                  |
| 19 | DPTO                       | División política administrativa de mayor nivel del Perú.                                                                                                   |

## Impacto
Los resultados tienen el potencial de:
- Fortalecer el control ex-ante de proyectos.
- Mejorar la asignación de recursos.
- Reducir ineficiencias y promover la transparencia en la gestión pública.

## Información del proyecto
Este proyecto corresponde a mi tesis aprobada para optar por el grado de **Maestro en Ciencia de Datos** en la **Universidad Continental**. La investigación aborda un problema de relevancia nacional, centrado en mejorar la eficiencia en la formulación de proyectos de inversión pública mediante el uso de ciencia de datos.

## Palabras clave
Ciencia de datos, inversión pública, sobrecostos, modelos predictivos, gestión de proyectos.

---

**Autor**: Eduardo Hugo Cáceres del Carpio  
           Maestrando en Ciencia de Datos  
**Universidad**: Universidad Continental  
**Año**: 2025
