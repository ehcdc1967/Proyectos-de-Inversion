
library(tidyverse)

setwd( dirname(rstudioapi::getActiveDocumentContext()$path) )

rm(list=ls())

detalle_inversiones <- 
  arrow::read_parquet('DETALLE_INVERSIONES.parquet') %>% 
  mutate( 
    COMPROM_ANUAL_ANIO_ACTUAL = as.numeric(COMPROM_ANUAL_ANIO_ACTUAL) 
    )

tipo_municipalidad  <- arrow::read_parquet('tipo_municipalidad.parquet')

# naturaleza de la inversión pública

CLAVES_MEJORAMIENTO <- c( "MEJORAMIENTO", "MEJORAR","MEJORA", "CONSTRUCCION"     , "ADQUISICION"  , "FORTALECIMIENTO", "OPTIMIZACION"
                         ,"ADECUACION"  , "REMODELACION"    , "ACONDICIONAMIENTO", "EQUIPAMIENTO" , "REPOTENCIACION" , "REFORZAMIENTO")

CLAVES_AMPLIACION   <- c("AMPLIACION","DESARROLLO","DESARROLLAR","EXPANSION","EXTENSION","CRECIMIENTO")

CLAVES_RECUPERACION <- c( "RECUPERACION", "RECUPERAR"     , "REPARACION", "RESTAURACION" , "REPOSICION" , "REHABILITACION" , "RENOVACION" 
                         ,"RENOVAR"     , "RECONSTRUCCION", "REEMPLAZO" , "MANTENIMIENTO", "REFUERZO"   , "REINSTALACION"  , "RECICLAJE" )

CLAVES_CREACION     <- c( "CREACION"    , "CREAR"      , "INSTALACION" , "IMPLEMENTACION" , "PUESTA EN MARCHA" , "NUEVA INFRAESTRUCTURA"
                         ,"CONSTRUCCION", "EDIFICACION", "OBRA NUEVA"  , "DESARROLLO")

detalle <- 
  detalle_inversiones %>% 
  # sobrecostos
  mutate(
      ANIO_VIABILIDAD  = as.integer(format(FECHA_VIABILIDAD,'%Y'))
    
     ,MTO_SOBRECOSTO   = COSTO_ACTUALIZADO - MONTO_VIABLE
     
     ,SOBRECOSTO_NIVEL = case_when( COSTO_ACTUALIZADO  < MONTO_VIABLE ~ "SUBCOSTO" 
                                  , COSTO_ACTUALIZADO == MONTO_VIABLE ~ "SIN VARIACION"
                                  , COSTO_ACTUALIZADO  > MONTO_VIABLE ~ "SOBRECOSTO"   )
     
    ,SOBRECOSTO       = ifelse( COSTO_ACTUALIZADO>MONTO_VIABLE , 1, 0 )
    
    ,MTO_UIT          = case_when( ANIO_VIABILIDAD==2022 ~ MONTO_VIABLE/4600
                                  ,ANIO_VIABILIDAD==2023 ~ MONTO_VIABLE/4950
                                  ,ANIO_VIABILIDAD==2024 ~ MONTO_VIABLE/5150
                                  ,ANIO_VIABILIDAD< 2022 ~ NA                )  
    ) %>%
  # filtrar según criterios de inclusión de población objetivo
  filter( 
        MARCO == "INVIERTE" 
      & SITUACION == "VIABLE" 
      & ESTADO == "ACTIVO" 
      & TIPO_INVERSION == "PROYECTO DE INVERSION"
      & ANIO_VIABILIDAD %in% 2022:2024 
      & MTO_UIT <=15000 
      ) %>% 
  select( where( ~!all(is.na(.))) ) %>% 
  select(
    ANIO_VIABILIDAD , SOBRECOSTO , everything() 
    ) %>% 
  # naturaleza del proyecto de inversion
  mutate(
     NOMBRE_INVERSION            = toupper(chartr('ÁÉÍÓÚ', 'AEIOU', NOMBRE_INVERSION))
    ,NATURALEZA_MEJORAMIENTO     = ifelse( grepl( paste(CLAVES_MEJORAMIENTO,collapse="|") , NOMBRE_INVERSION)==TRUE, 1, 0)
    ,NATURALEZA_AMPLIACION       = ifelse( grepl( paste(CLAVES_AMPLIACION  ,collapse="|") , NOMBRE_INVERSION)==TRUE, 1, 0)
    ,NATURALEZA_RECUPERACION     = ifelse( grepl( paste(CLAVES_RECUPERACION,collapse="|") , NOMBRE_INVERSION)==TRUE, 1, 0)
    ,NATURALEZA_CREACION         = ifelse( grepl( paste(CLAVES_CREACION    ,collapse="|") , NOMBRE_INVERSION)==TRUE, 1, 0)
    ,NATURALEZA_TOTAL            = NATURALEZA_MEJORAMIENTO + NATURALEZA_AMPLIACION + NATURALEZA_RECUPERACION + NATURALEZA_CREACION
  ) %>% 
  # MODALIDAD DEL PROYECTO DE INVERSION
  mutate(
     MODALIDAD_DIRECTA   = ifelse( grepl( "ADMINISTRACIÓN DIRECTA"                                , DES_MODALIDAD) , 1, 0) 
    ,MODALIDAD_INDIRECTA = ifelse( grepl( "POR CONTRATA|(APP)|NÚCLEO EJECUTOR|OBRAS POR IMPUESTOS", DES_MODALIDAD) , 1, 0) 
    ) %>% 
  # variables de tiempo
  mutate(
     TIEMPO_VIABILIDAD = as.numeric( FECHA_VIABILIDAD  - FECHA_REGISTRO    )
    ,TIEMPO_EJECUCION  = as.numeric( FEC_FIN_EJECUCION - FEC_INI_EJECUCION )
  ) %>% 
  # modificación del proyectos de inversión
  mutate(
    MODIFICACION_F8 = if_else( TIENE_F8==1 & ETAPA_F8=="Aprobación de consistencia o modificaciones antes de la aprobación del ET o ET (A)" 
                              , 1 
                              , 0 
                              , missing=0 )
    ) %>% 
  # tipo de municipalidad
  left_join(  tipo_municipalidad %>% select( UBIGEO , TIPO_MUNICIPALIDAD )  , by=join_by(UBIGEO)  ) %>% 
  # Proporción de proyectos que tienen devengados a la fecha actual
  mutate(
      PROP_DEVENGADA  = (DEV_ANIO_ACTUAL + DEVEN_ACUMUL_ANIO_ANT) / COSTO_ACTUALIZADO 
     ,MONTO_ET_F8     = ifelse( is.na(MONTO_ET_F8) , 0 , MONTO_ET_F8 )  
     ,RATIO_ET_VIABLE = MONTO_ET_F8 / MONTO_VIABLE
     ,RATIO_ET_COSTO  = MONTO_ET_F8 / COSTO_ACTUALIZADO
    )

# determinación de la población objetivo
pob <- 
  detalle %>% 
  select(
           CODIGO_UNICO
          ,FUNCION
          ,SOBRECOSTO
          ,TIEMPO_VIABILIDAD
          ,TIEMPO_EJECUCION
          ,BENEFICIARIO
          ,CTRL_CONCURR
          ,MONTO_LAUDO
          ,MONTO_FIANZA
          ,NATURALEZA_MEJORAMIENTO
          ,NATURALEZA_AMPLIACION
          ,NATURALEZA_RECUPERACION
          ,NATURALEZA_CREACION
          ,NATURALEZA_TOTAL
          ,MODALIDAD_DIRECTA
          ,MODALIDAD_INDIRECTA
          ,MODIFICACION_F8
          ,EXPEDIENTE_TECNICO 
          ,REGISTRADO_PMI
          ,DPTO = DEPARTAMENTO
          ,TIPO_MUNICIPALIDAD
          ,RATIO_ET_VIABLE
          ,RATIO_ET_COSTO
      ) %>% 
  na.omit()


arrow::write_parquet( pob , 'poblacion.parquet' )






