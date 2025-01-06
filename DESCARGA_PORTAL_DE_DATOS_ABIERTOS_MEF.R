
rm(list=ls())

# PORTAL DE DATOS ABIERTOS DEL MINISTERIO DE ECONOMÍA Y FINANZAS DEL PERÚ 
# https://datosabiertos.mef.gob.pe/dataset/detalle-de-inversiones

library(tidyverse) ; library(arrow) ; library(httr) ; library(readr)

# directorio de datos
diccionario <- 
  read.csv( 
    text = content(httr::GET("https://fs.datosabiertos.mef.gob.pe/datastorefiles/Detalle_Inversiones_Diccionario.csv",config(ssl_verifypeer=FALSE,ssl_verifyhost=FALSE)),as="text",encoding="UTF-8") 
    ,colClasses   = 'character'
    ,header       = TRUE
    ,na.strings   = c('',' ','-','NULL','null','--','-.-')
    ,fileEncoding = 'utf-8'
  )


# (0) Indetificación del tipo de variables 

VARIABLES_CHARACTER <- c(  "NIVEL"              , "SECTOR"           , "ENTIDAD"        , "CODIGO_UNICO"          , "CODIGO_SNIP"    , "NOMBRE_INVERSION" , "NOMBRE_OPMI"      
                         , "NOMBRE_UF"          , "NOMBRE_UEI"       , "SEC_EJEC"       , "NOMBRE_UEP"            , "ESTADO"         , "SITUACION"        , "ALTERNATIVA"
                         , "FUNCION"            , "PROGRAMA"         , "SUBPROGRAMA"    , "MARCO"                 , "TIPO_INVERSION" , "DES_MODALIDAD"    , "ETAPA_F9"    
                         , "PRIMER_DEVENGADO"   , "ULTIMO_DEVENGADO" , "ETAPA_F8"       , "ULT_PERIODO_REG_F12B"  , "DES_TIPOLOGIA"  , "DEPARTAMENTO"     , "PROVINCIA"  
                         , "DISTRITO","UBIGEO"  , "LATITUD"          , "LONGITUD" )

VARIABLES_NUMERICAS <- c( "MONTO_VIABLE"       , "COSTO_ACTUALIZADO"  , "CTRL_CONCURR"      , "MONTO_LAUDO"            , "MONTO_FIANZA"     , "PMI_ANIO_1"
                         ,"PMI_ANIO_2"         , "PMI_ANIO_3"         , "PMI_ANIO_4"        , "DEVEN_ACUMUL_ANIO_ANT"  , "DEV_ANIO_ACTUAL"  , "PIA_ANIO_ACTUAL"
                         ,"PIM_ANIO_ACTUAL"    , "DEV_ENE_ANIO_VIG"   , "DEV_FEB_ANIO_VIG"  , "DEV_MAR_ANIO_VIG"       , "DEV_ABR_ANIO_VIG" , "DEV_MAY_ANIO_VIG"
                         ,"DEV_JUN_ANIO_VIG"   , "DEV_JUL_ANIO_VIG"   , "DEV_AGO_ANIO_VIG"  , "DEV_SET_ANIO_VIG"       , "DEV_OCT_ANIO_VIG" , "DEV_NOV_ANIO_VIG"
                         ,"DEV_DIC_ANIO_VIG"   , "CERTIF_ANIO_ACTUAL" , "SALDO_EJECUTAR"    , "AVANCE_FISICO"          , "AVANCE_EJECUCION" , "COMPROM_ANUAL_ANIO_ACTUAL" 
                         ,"MONTO_VALORIZACION" , "BENEFICIARIO"       , "MONTO_ET_F8"       , "ANIO_PROCESO"           , "PROG_ACTUAL_ANIO_ACTUAL")


VARIABLES_FECHA <- c( "FECHA_REGISTRO"      , "FECHA_VIABILIDAD"   , "FEC_REG_F9"          , "FECHA_ULT_ACT_F12B" , "ULT_FEC_DECLA_ESTIM"
                      ,"FEC_INI_EJECUCION"  , "FEC_FIN_EJECUCION"  , "FEC_INI_EJEC_FISICA" , "FEC_FIN_EJEC_FISICA")

VARIABLES_DICOTOMICAS <- c("REGISTRADO_PMI","EXPEDIENTE_TECNICO","INFORME_CIERRE","TIENE_F9","TIENE_F8","TIENE_F12B","TIENE_AVAN_FISICO","SANEAMIENTO")

VARIABLES_ENTERAS <- c("ANIO_PROCESO")

# Identificación de la naturaleza de la inversión pública : palabras claves
PALABRAS_CLAVES_MEJORAMIENTO <- c("MEJORAMIENTO","MEJORAR","MEJORA","CONSTRUCCION","ADQUISICION","FORTALECIMIENTO","OPTIMIZACION","ADECUACION","REMODELACION","ACONDICIONAMIENTO","EQUIPAMIENTO","REPOTENCIACION","REFORZAMIENTO")
PALABRAS_CLAVES_AMPLIACION   <- c("AMPLIACION","DESARROLLO","DESARROLLAR","EXPANSION","EXTENSION","CRECIMIENTO")
PALABRAS_CLAVES_RECUPERACION <- c("RECUPERACION","RECUPERAR","REPARACION","RESTAURACION","REPOSICION","REHABILITACION","RENOVACION","RENOVAR","RECONSTRUCCION","REEMPLAZO","MANTENIMIENTO","REFUERZO","REINSTALACION","RECICLAJE")
PALABRAS_CLAVES_CREACION     <- c("CREACION","CREAR","INSTALACION","IMPLEMENTACION","PUESTA EN MARCHA","NUEVA INFRAESTRUCTURA","CONSTRUCCION","EDIFICACION","OBRA NUEVA","DESARROLLO")

# (1) Descarga de datos Portal de Datos Abiertos - Ministerio de Economía y Finanzas del Perú

detalle_inversiones <- 
  read.csv( 
       text = content(httr::GET("https://fs.datosabiertos.mef.gob.pe/datastorefiles/DETALLE_INVERSIONES.csv",config(ssl_verifypeer=FALSE,ssl_verifyhost=FALSE)),as="text",encoding="UTF-8") 
      ,colClasses   = 'character'
      ,header       = TRUE
      ,na.strings   = c('',' ','-','NULL','null','--','-.-')
      ,fileEncoding = 'utf-8'
    ) %>% 
  mutate_if(is.character,trimws) %>% 
  mutate(
     across( VARIABLES_NUMERICAS   , as.numeric )
    ,across( VARIABLES_FECHA       , ~as.Date(.,format="%Y-%m-%d"))
    ,across( VARIABLES_DICOTOMICAS , function(x){x <- ifelse(x=="SI",1,ifelse(x=="NO",0,NA))})
    ,across( VARIABLES_ENTERAS     , as.integer)
    ) 

# (2) Determinación de la población objetivo:
poblacion <- 
  detalle_inversiones %>% 
  mutate(
     # año de viabilidad de los proyectos de inversión
     ANIO_VIABILIDAD  = as.integer(format(FECHA_VIABILIDAD,'%Y'))
     # identificar sobrecostos
    ,MTO_SOBRECOSTO   = COSTO_ACTUALIZADO - MONTO_VIABLE
    ,SOBRECOSTO_NIVEL = case_when( COSTO_ACTUALIZADO  < MONTO_VIABLE ~ "SUBCOSTO"
                                  ,COSTO_ACTUALIZADO == MONTO_VIABLE ~ "SIN VARIACION"
                                  ,COSTO_ACTUALIZADO  > MONTO_VIABLE ~ "SOBRECOSTO" )
    ,SOBRECOSTO       = ifelse( COSTO_ACTUALIZADO>MONTO_VIABLE , 1, 0 )
    # Calcular Monto UIT según año
    ,MTO_UIT          = case_when(ANIO_VIABILIDAD==2022  ~ MONTO_VIABLE/4600
                                  ,ANIO_VIABILIDAD==2023 ~ MONTO_VIABLE/4950
                                  ,ANIO_VIABILIDAD==2024 ~ MONTO_VIABLE/5150
                                  ,ANIO_VIABILIDAD< 2022 ~ NA) ) %>%
  # filtrar proyectos según criterios de inclusión de población objetivo
  filter( 
      MARCO             == "INVIERTE" 
    & SITUACION         == "VIABLE"
    & ESTADO            == "ACTIVO" 
    & TIPO_INVERSION    == "PROYECTO DE INVERSION"
    & ANIO_VIABILIDAD %in% 2022:2024 
    & MTO_UIT           <= 15000 
    ) %>% 
  select( where( ~!all(is.na(.))) ) %>% 
  # naturaleza del proyecto de inversion
  mutate(
     NATURALEZA_MEJORAMIENTO  = ifelse( grepl( paste(PALABRAS_CLAVES_MEJORAMIENTO,collapse="|") , toupper(chartr('ÁÉÍÓÚ','AEIOU',NOMBRE_INVERSION)))==TRUE , 1 , 0 )
    ,NATURALEZA_AMPLIACION    = ifelse( grepl( paste(PALABRAS_CLAVES_AMPLIACION  ,collapse="|") , toupper(chartr('ÁÉÍÓÚ','AEIOU',NOMBRE_INVERSION)))==TRUE , 1 , 0 )
    ,NATURALEZA_RECUPERACION  = ifelse( grepl( paste(PALABRAS_CLAVES_RECUPERACION,collapse="|") , toupper(chartr('ÁÉÍÓÚ','AEIOU',NOMBRE_INVERSION)))==TRUE , 1 , 0 )
    ,NATURALEZA_CREACION      = ifelse( grepl( paste(PALABRAS_CLAVES_CREACION    ,collapse="|") , toupper(chartr('ÁÉÍÓÚ','AEIOU',NOMBRE_INVERSION)))==TRUE , 1 , 0 )
    ) %>% 
  # Identificación de la modalidad del proyecto de inversión
  mutate(
     MODALIDAD_DIRECTA   = ifelse( grepl( "ADMINISTRACIÓN DIRECTA" , DES_MODALIDAD) , 1, 0) 
    ,MODALIDAD_INDIRECTA = ifelse( grepl( "POR CONTRATA|(APP)|NÚCLEO EJECUTOR|OBRAS POR IMPUESTOS", DES_MODALIDAD) , 1, 0) 
    ) %>% 
  # variables de tiempo
  mutate(
     TIEMPO_VIABILIDAD = as.numeric( FECHA_VIABILIDAD  - FECHA_REGISTRO    )
    ,TIEMPO_EJECUCION  = as.numeric( FEC_FIN_EJECUCION - FEC_INI_EJECUCION ) 
    ) %>% 
  # Identificación de proyectos modificados según Formular F8:
  mutate(
    MODIFICACION_F8 = if_else( TIENE_F8==1 & ETAPA_F8=="Aprobación de consistencia o modificaciones antes de la aprobación del ET o ET (A)" 
                               , 1 
                               , 0 
                               , missing=0 ) 
    ) %>% 
  # Identificación del tipo de municipalidad:
  left_join(  
      arrow::read_parquet('https://raw.githubusercontent.com/ehcdc1967/Proyectos-de-Inversion/main/TIPO_MUNICIPALIDAD.parquet') %>% select( UBIGEO , TIPO_MUNICIPALIDAD )
    , by = join_by(UBIGEO)  
    ) %>% 
  # Proporción de proyectos que tienen devengados a la fecha actual
    mutate(
       MONTO_ET_F8     = ifelse( is.na(MONTO_ET_F8) , 0 , MONTO_ET_F8 )  
      ,RATIO_ET_VIABLE = MONTO_ET_F8 / MONTO_VIABLE
      ,RATIO_ET_COSTO  = MONTO_ET_F8 / COSTO_ACTUALIZADO
      ) %>% 
  # determinación de la población objetivo
  select(
     CODIGO_UNICO
    ,SOBRECOSTO
    ,FUNCION
    ,TIEMPO_VIABILIDAD
    ,TIEMPO_EJECUCION
    ,BENEFICIARIO
    ,CTRL_CONCURR
    ,MONTO_LAUDO
    ,NATURALEZA_MEJORAMIENTO
    ,NATURALEZA_AMPLIACION
    ,NATURALEZA_RECUPERACION
    ,NATURALEZA_CREACION
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

# directorio actual de datos
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# Grabar datos Datos Abiertos
n <- nrow(detalle_inversiones)
partes <- split( detalle_inversiones , rep(1:3,length.out=n) )
for (i in seq_along(partes)) { write_parquet(partes[[i]], paste0("DETALLE_INVERSIONES_", i, ".parquet")) }
list.files(pattern = "DETALLE_INVERSIONES_.*\\.parquet$")

# Grabar dicicionario de datos
arrow::write_parquet( diccionario , 'DICCIONARIO.parquet' )

# Grabar datos de poblacion de estudio
arrow::write_parquet( poblacion , 'POBLACION.parquet'   )



