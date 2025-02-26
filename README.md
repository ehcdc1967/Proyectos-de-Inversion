# Tesis de Maestría en Ciencia de Datos  
# APLICACIÓN DE CIENCIA DE DATOS EN EL ANÁLISIS DE LA EFICIENCIA EN LA FORMULACIÓN DE PROYECTOS DE INVERSIÓN PÚBLICA  

## Resumen  
Este estudio aplica técnicas de ciencia de datos para analizar la eficiencia en la formulación de proyectos de inversión pública en el Perú. Se enfoca en identificar factores que contribuyen a sobrecostos y el uso de adendas, utilizando modelos predictivos como regresión logística, árboles de decisión y métodos avanzados de machine learning. Con estos enfoques, se busca anticipar desviaciones presupuestarias desde las primeras etapas, optimizando la planificación, ejecución y asignación de recursos públicos.  

## Objetivos  
### General:  
- Aplicar técnicas de ciencia de datos para analizar la eficiencia en la formulación de proyectos de inversión pública en Perú, identificando factores y patrones asociados con los sobrecostos y el uso de adendas, con el fin de proponer recomendaciones para mejorar la precisión en las estimaciones presupuestarias y optimizar la gestión de recursos en futuros proyectos.  

### Específicos:  
- Realizar un análisis descriptivo de los factores que contribuyen a los sobrecostos en proyectos de inversión pública, como tipo de proyecto, ubicación geográfica y nivel de gobierno.  
- Desarrollar un modelo predictivo para anticipar desviaciones presupuestarias, permitiendo identificar proyectos con riesgo de sobrecostos.  
- Identificar patrones de ineficiencia y sobrecostos recurrentes en proyectos para proponer recomendaciones que optimicen la formulación y ejecución de futuros proyectos públicos. 

## Metodología  
La investigación utiliza un enfoque cuantitativo y modelos predictivos como Random Forest y XGBoost para analizar datos históricos del Banco de Proyectos de INVIERTE.PE. Se emplearon técnicas de validación cruzada y métricas como precisión, recall y AUC-ROC para evaluar los modelos.  

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
**Grado Académico**: Tesista de la Maestría en Ciencia de Datos  
**Universidad**: Universidad Continental  
**Año**: 2024
