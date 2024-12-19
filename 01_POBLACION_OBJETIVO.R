
library(tidyverse)
library(arrow)

rm(list=ls())

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))


detalle <- arrow::read_parquet('DETALLE_INVERSIONES.parquet')

pob <- 
  detalle %>% 
  filter( MARCO     == "INVIERTE" ) %>% 
  filter( SITUACION == "VIABLE"   ) %>% 
  filter( ESTADO    == "ACTIVO"   ) %>% 
  mutate(
     SOBRECOSTO = case_when( COSTO_ACTUALIZADO<MONTO_VIABLE ~ "SUBCOSTO" , COSTO_ACTUALIZADO==MONTO_VIABLE ~ "SIN VARIACION" , COSTO_ACTUALIZADO>MONTO_VIABLE ~ "SOBRECOSTO")
    ,ANIO_VIABILIDAD = as.integer(format(FECHA_VIABILIDAD,'%Y'))
  ) %>% 
  filter( ANIO_VIABILIDAD>=2021   ) %>% 
  select( where(~ !all(is.na(.))) ) %>% 
  select( ANIO_VIABILIDAD , SOBRECOSTO , everything() ) %>% 
  select(-c(CODIGO_UNICO,CODIGO_SNIP,ENTIDAD,NOMBRE_INVERSION,NOMBRE_OPMI,NOMBRE_UF,NOMBRE_UEI,SEC_EJEC,NOMBRE_UEP,ALTERNATIVA,PRIMER_DEVENGADO,ULTIMO_DEVENGADO,DES_TIPOLOGIA))














# 01 CIERRE DE INVERSIONES -------------------------------------------------------------------------------------------------------------------------------------------------------------
library(tidyverse) ; library(rlang)
rm(list=ls())
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))


cierre <- 
  read.csv('https://fs.datosabiertos.mef.gob.pe/datastorefiles/CIERRE_INVERSIONES.csv'
           ,colClasses = 'character'
           ,header     = TRUE
           ,na.strings = c('',' ','-','NULL','null','--','-.-')
           ,fileEncoding = 'utf-8'
  ) %>% 
  rename( NIVEL=1,SECTOR=2,ENTIDAD=3,CODIGO_UNICO=4,CODIGO_SNIP=5,NOMBRE_INVERSION=6,ESTADO=7,SITUACION=8,MONTO_VIABLE=9,COSTO_ACTUALIZADO=10,CTRL_CONCURR=11,MONTO_LAUDO=12,MONTO_FIANZA=13,,FECHA_REGISTRO=14,FECHA_VIABILIDAD=15,FUNCION=16,PROGRAMA=17,SUBPROGRAMA=18,MARCO=19,TIPO_INVERSION=20,NOM_OPMI=21,NOM_UF=22,NOM_UEI=23,SEC_EJEC=24,NOM_UEP=25,EXPEDIENTE_TECNICO=26,INFORME_CIERRE=27,FEC_CIERRE=28,DES_CIERRE=29,TIENE_F9=30,FEC_REG_F9=31,CULMINADA=32,ETAPA_F9=33,FEC_INI_OPER=34,PRIMER_DEVENGADO=35,ULTIMO_DEVENGADO=36,DEVEN_ACUMULADO=37,TIENE_F8=38,TIENE_F12B=39,DES_TIPOLOGIA=40,DES_MODALIDAD=41,DEPARTAMENTO=42,PROVINCIA=43,DISTRITO=44,UBIGEO=45,LATITUD=46,LONGITUD=47,ANIO_PROCESO=48) %>% 
  mutate_if( is.character , trimws ) %>% 
  mutate(
    across( c("MONTO_VIABLE",,"MONTO_LAUDO","MONTO_FIANZA","COSTO_ACTUALIZADO","CTRL_CONCURR","DEVEN_ACUMULADO","LATITUD","LONGITUD") , as.numeric )
    ,across( c("FECHA_REGISTRO","FECHA_VIABILIDAD","FEC_CIERRE","FEC_REG_F9","FEC_INI_OPER")             , ~as.Date( .,format="%Y-%m-%d") )
    ,across( c("EXPEDIENTE_TECNICO","INFORME_CIERRE","TIENE_F9","TIENE_F8","TIENE_F12B","CULMINADA")     , function(x){x <- ifelse(x=="SI",1,ifelse(x=="NO",0,NA))} )
    ,across( c("ANIO_PROCESO") , as.integer  )
  )

arrow::write_parquet( cierre , 'CIERRE_INVERSIONES.parquet' )
rio::export( cierre , file="CIERRE_INVERSIONES.xlsx")
save( cierre , file="CIERRE_INVERSIONES.RData")

# 02 DETALLE DE INVERSIONES -------------------------------------------------------------------------------------------------------------------------------------------------------------
rm(list=ls())
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

detalle <- 
  read.csv('https://fs.datosabiertos.mef.gob.pe/datastorefiles/DETALLE_INVERSIONES.csv'
           ,colClasses = 'character'
           ,header     = TRUE
           ,na.strings = c('',' ','-','NULL','null','--','-.-')
           ,fileEncoding = 'utf-8')  %>% 
  rename(NIVEL=1,SECTOR=2,ENTIDAD=3,CODIGO_UNICO=4,CODIGO_SNIP=5,NOMBRE_INVERSION=6,NOMBRE_OPMI=7,NOMBRE_UF=8,NOMBRE_UEI=9,SEC_EJEC=10,NOMBRE_UEP=11,ESTADO=12,SITUACION=13,MONTO_VIABLE=14,COSTO_ACTUALIZADO=15,CTRL_CONCURR=16,MONTO_LAUDO=17,MONTO_FIANZA=18,ALTERNATIVA=19,FECHA_REGISTRO=20,FECHA_VIABILIDAD=21,FUNCION=22,PROGRAMA=23,SUBPROGRAMA=24,MARCO=25,TIPO_INVERSION=26,DES_MODALIDAD=27,REGISTRADO_PMI=28,PMI_ANIO_1=29,PMI_ANIO_2=30,PMI_ANIO_3=31,PMI_ANIO_4=32,EXPEDIENTE_TECNICO=33,INFORME_CIERRE=34,TIENE_F9=35,FEC_REG_F9=36,ETAPA_F9=37,PRIMER_DEVENGADO=38,ULTIMO_DEVENGADO=39,DEVEN_ACUMUL_ANIO_ANT=40,DEV_ANIO_ACTUAL=41,PIA_ANIO_ACTUAL=42,PIM_ANIO_ACTUAL=43,DEV_ENE_ANIO_VIG=44,DEV_FEB_ANIO_VIG=45,DEV_MAR_ANIO_VIG=46,DEV_ABR_ANIO_VIG=47,DEV_MAY_ANIO_VIG=48,DEV_JUN_ANIO_VIG=49,DEV_JUL_ANIO_VIG=50,DEV_AGO_ANIO_VIG=51,DEV_SET_ANIO_VIG=52,DEV_OCT_ANIO_VIG=53,DEV_NOV_ANIO_VIG=54,DEV_DIC_ANIO_VIG=55,CERTIF_ANIO_ACTUAL=56,COMPROM_ANUAL_ANIO_ACTUAL=57,SALDO_EJECUTAR=58,TIENE_F8=59,ETAPA_F8=60,TIENE_F12B=61,FECHA_ULT_ACT_F12B=62,ULT_PERIODO_REG_F12B=63,TIENE_AVAN_FISICO=64,AVANCE_FISICO=65,AVANCE_EJECUCION=66,ULT_FEC_DECLA_ESTIM=67,DES_TIPOLOGIA=68,PROG_ACTUAL_ANIO_ACTUAL=69,MONTO_VALORIZACION=70,SANEAMIENTO=71,DEPARTAMENTO=72,PROVINCIA=73,DISTRITO=74,UBIGEO=75,LATITUD=76,LONGITUD=77,FEC_INI_EJECUCION=78,FEC_FIN_EJECUCION=79,FEC_INI_EJEC_FISICA=80,FEC_FIN_EJEC_FISICA=81,BENEFICIARIO=82,MONTO_ET_F8=83,ANIO_PROCESO=84) %>% 
  mutate_if(is.character,trimws) %>% 
  mutate(
    across( 
      c("MONTO_VIABLE","COSTO_ACTUALIZADO","CTRL_CONCURR","MONTO_LAUDO","MONTO_FIANZA","PMI_ANIO_1","PMI_ANIO_2","PMI_ANIO_3","PMI_ANIO_4","DEVEN_ACUMUL_ANIO_ANT","DEV_ANIO_ACTUAL","PIA_ANIO_ACTUAL","PIM_ANIO_ACTUAL","DEV_ENE_ANIO_VIG","DEV_FEB_ANIO_VIG","DEV_MAR_ANIO_VIG","DEV_ABR_ANIO_VIG","DEV_MAY_ANIO_VIG","DEV_JUN_ANIO_VIG","DEV_JUL_ANIO_VIG","DEV_AGO_ANIO_VIG","DEV_SET_ANIO_VIG","DEV_OCT_ANIO_VIG","DEV_NOV_ANIO_VIG","DEV_DIC_ANIO_VIG","CERTIF_ANIO_ACTUAL","SALDO_EJECUTAR","AVANCE_FISICO","AVANCE_EJECUCION","PROG_ACTUAL_ANIO_ACTUAL","MONTO_VALORIZACION","BENEFICIARIO","MONTO_ET_F8")
      ,as.numeric)
    ,across(
      c("FECHA_REGISTRO","FECHA_VIABILIDAD","FEC_REG_F9","FECHA_ULT_ACT_F12B","ULT_FEC_DECLA_ESTIM","FEC_INI_EJECUCION","FEC_FIN_EJECUCION","FEC_INI_EJEC_FISICA","FEC_FIN_EJEC_FISICA")
      , ~as.Date( .,format="%Y-%m-%d"))
    ,across(
      c("REGISTRADO_PMI","EXPEDIENTE_TECNICO","INFORME_CIERRE","TIENE_F9","TIENE_F8","TIENE_F12B","TIENE_AVAN_FISICO","SANEAMIENTO")
      ,function(x){x <- ifelse(x=="SI",1,ifelse(x=="NO",0,NA))})
    ,across(
      c("ANIO_PROCESO")
      ,as.integer)
  )

arrow::write_parquet( detalle , 'DETALLE_INVERSIONES.parquet' )

save( detalle , file="DETALLE_INVERSIONES.RData")
rio::export( detalle , file="DETALLE_INVERSIONES.xlsx")

# 03 Directorio de Operadores del Invierte.pe -------------------------------------------------------------------------------------------------------------------------------------------------------------
rm(list=ls())
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

operadores <- 
  read.csv('https://fs.datosabiertos.mef.gob.pe/datastorefiles/DIRECTORIO_INVIERTE.csv'
           ,colClasses = 'character'
           ,header     = TRUE
           ,na.strings = c('',' ','-','NULL','null','--','-.-')
           ,fileEncoding = 'utf-8'
  ) %>% 
  mutate_if(is.character,trimws) %>% 
  rename(NIVEL=1,NOMBRE_SECTOR=2,NOMBRE_PLIEGO=3,ORGANO=4,NOMBRE_UNIDAD=5,DEPARTAMENTO=6,PROVINCIA=7,DISTRITO=8,NOMBRES=9,APELLIDOS=10,CARGO=11,DIRECCION=12,EMAIL=13,EMAIL_ALTERNATIVO=14,TELEFONO=15,TELEFAX=16)

arrow::write_parquet( operadores , 'DIRECTORIO_INVIERTE.parquet' )

save( operadores , file="DIRECTORIO_INVIERTE.RData")
rio::export( operadores , file="DIRECTORIO_INVIERTE.xlsx")

# 04 Estado situacional de inversiones -------------------------------------------------------------------------------------------------------------------------------------------------------------
rm(list=ls())
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

estado <- 
  read.csv('https://fs.datosabiertos.mef.gob.pe/datastorefiles/ESTADO_SITUACIONAL.csv'
           ,colClasses = 'character'
           ,header     = TRUE
           ,na.strings = c('',' ','-','NULL','null','--','-.-')
           ,fileEncoding = 'latin1'
  ) %>% 
  mutate_if(is.character,trimws) %>% 
  mutate( AVANCE=as.numeric(AVANCE) , CODIGO_SNIP=gsub(".0","",CODIGO_SNIP) ) %>% 
  rename(COD_UNICO=1,CODIGO_SNIP=2,FACTOR=3,PRODUCTO=4,ACCIONES=5,PERIODO=6,SITUACION=7,AVANCE=8)

arrow::write_parquet( estado , 'ESTADO_SITUACIONAL.parquet' )

save( estado , file='ESTADO_SITUACIONAL.RData' )
rio::export( estado , file="ESTADO_SITUACIONAL.xlsx")

# 05 Formato 12B de de inversiones -------------------------------------------------------------------------------------------------------------------------------------------------------------

# https://datosabiertos.mef.gob.pe/dataset/formato-12b-de-de-inversiones

rm(list=ls())
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

formato12b <- 
  read.csv('https://fs.datosabiertos.mef.gob.pe/datastorefiles/FORMATO_12B.csv'
           ,colClasses = 'character'
           ,header     = TRUE
           ,na.strings = c('',' ','-','NULL','null','--','-.-')
           ,fileEncoding = 'utf-8'
  ) %>% 
  mutate_if(is.character,trimws) %>% 
  mutate(
    across( c("MONTO_PROGRAMADO_FINANCIERO","MONTO_ACTUALIZADO_FINANCIERO","MONTO_ACTUALIZADO_FISICO","MONTO_PROGRAMADO_FISICO","MONTO_EJECUTADO_FISICO")
            ,as.numeric)
    ,PERIODO = gsub("-","",PERIODO)
  ) %>% 
  rename(COD_UNICO=1,PERIODO=2,MONTO_PROGRAMADO_FINANCIERO=3,MONTO_ACTUALIZADO_FINANCIERO=4,MONTO_ACTUALIZADO_FISICO=5,MONTO_PROGRAMADO_FISICO=6,MONTO_EJECUTADO_FISICO=7)

arrow::write_parquet( formato12b      , 'FORMATO_12B.parquet' )

# exportar a EXCEL
a2019=formato12b[substring(formato12b$PERIODO,1,4)=='2019',]; a2020=formato12b[ substring(formato12b$PERIODO,1,4)=='2020',]; a2021=formato12b[substring(formato12b$PERIODO,1,4)=='2021',];a2022 = formato12b[ substring(formato12b$PERIODO,1,4)=='2022',];a2023 = formato12b[ substring(formato12b$PERIODO,1,4)=='2023',]; a2024=formato12b[substring(formato12b$PERIODO,1,4)=='2024',]; rio::export(list(a2019=a2019,a2020=a2020,a2021=a2021,a2022=a2022,a2023=a2023,a2024=a2024),file="FORMATO_12B.xlsx")

save( formato12b , file='FORMATO_12B.RData' )


# 06 Indicadores de brechas -------------------------------------------------------------------------------------------------------------------------------------------------------------
rm(list=ls())
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

brechas <- 
  read.csv('https://fs.datosabiertos.mef.gob.pe/datastorefiles/INVERSIONES_BRECHAS.csv'
           ,colClasses = 'character'
           ,header     = TRUE
           ,na.strings = c('',' ','-','NULL','null','--','-.-')
           ,fileEncoding = 'utf-8'
  ) %>% 
  mutate_if(is.character,trimws) %>% 
  mutate( across( c("ANIO","VALOR","CONTRIBUCION","ANIO_PROC") , as.numeric ) ) %>% 
  rename(CODIGO_UNICO=1,DES_SERVICIO=2,DES_BRECHA=3,DES_UM=4,ESPACIO_GEOGRAFICO=5,ANIO=6,VALOR=7,CONTRIBUCION=8,ANIO_PROC=9)

arrow::write_parquet( brechas      , 'INVERSIONES_BRECHAS.parquet' )

save( brechas , file='INVERSIONES_BRECHAS.RData' )
rio::export( brechas , file="INVERSIONES_BRECHAS.xlsx")

# 07 Inversiones desactivadas -------------------------------------------------------------------------------------------------------------------------------------------------------------
rm(list=ls())
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

desactivadas <- 
  read.csv('https://fs.datosabiertos.mef.gob.pe/datastorefiles/INVERSIONES_DESACTIVADAS.csv'
           ,colClasses = 'character'
           ,header     = TRUE
           ,na.strings = c('',' ','-','NULL','null','--','-.-')
           ,fileEncoding = 'utf-8'
  ) %>% 
  mutate_if( is.character , trimws ) %>% 
  mutate(
    across(c("MONTO_VIABLE","COSTO_ACTUALIZADO","CTRL_CONCURR","MONTO_LAUDO","MONTO_FIANZA","DEVENGADO_ACUMULADO","NUM_HABITANTES_BENEF") , as.numeric )
    ,across( c("FECHA_REGISTRO","FECHA_VIABILIDAD") , ~as.Date( .,format="%Y-%m-%d")) 
  ) %>% 
  rename(NIVEL=1,SECTOR=2,ENTIDAD=3,CODIGO_UNICO=4,COD_SNIP=5,NOMBRE_INVERSION=6,NOM_OPMI=7,NOM_UF=8,NOM_UEI=9,NOM_UEP=10,ESTADO=11,SITUACION=12,RESPONSABLE_OPMI=13,RESPONSABLE_UEI=14,RESP_NOMBRE_UF=15,OPI=16,RESPONSABLE_OPI=17,MONTO_VIABLE=18,COSTO_ACTUALIZADO=19,CTRL_CONCURR=20,MONTO_LAUDO=21,MONTO_FIANZA=22,FECHA_REGISTRO=23,FECHA_VIABILIDAD=24,FUNCION=25,PROGRAMA=26,SUBPROGRAM=27,MARCO=28,TIPO_INVERSION=29,DES_MODALIDAD=30,EXPEDIENTE_TECNICO=31,INFORME_CIERRE=32,DEVENGADO_ACUMULADO=33,DES_TIPOLOGIA=34,DEPARTAMENTO=35,PROVINCIA=36,DISTRITO=37,UBIGEO=38,LATITUD=39,LONGITUD=40,NUM_HABITANTES_BENEF=41,ANIO_PROC=42)

arrow::write_parquet( desactivadas      , 'INVERSIONES_DESACTIVADAS.parquet' )

save( desactivadas , file="INVERSIONES_DESACTIVADAS.RData" )
rio::export( desactivadas , file="INVERSIONES_DESACTIVADAS.xlsx" )

# 08 Proceso de selección de inversiones -------------------------------------------------------------------------------------------------------------------------------------------------------------
rm(list=ls())
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

proceso.selecc <- 
  read.csv('https://fs.datosabiertos.mef.gob.pe/datastorefiles/PROCESO_SELECCION.csv'
           ,colClasses = 'character'
           ,header     = TRUE
           ,na.strings = c('',' ','-','NULL','null','--','-.-')
           ,fileEncoding = 'utf-8') %>% 
  mutate_if( is.character , trimws ) %>% 
  mutate( FECHA = as.Date(substring(FECHA,1,10),format="%Y-%m-%d") ) %>% 
  mutate( CODIGO_SNIP = gsub(".0","",CODIGO_SNIP) ) %>% 
  rename(COD_UNICO=1,CODIGO_SNIP=2,FACTOR=3,DESCRIPCION=4,TIPO=5,FECHA=6)

arrow::write_parquet( proceso.selecc , 'PROCESO_SELECCION.parquet' )
save( proceso.selecc , file="PROCESO_SELECCION.RData")
rio::export( proceso.selecc , file="PROCESO_SELECCION.xlsx")


# 09 Diccionario -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
rm(list=ls())
library(tidyverse) ; library(rlang)
setwd( dirname(rstudioapi::getActiveDocumentContext()$path) )

fuente <- 
  c('Proceso de seleccion'
    ,'Detalle inversiones'
    ,'Directorio Invierte.pe'
    ,'Estado situacional'
    ,'Formato 12B'
    ,'Brechas de inversiones'
    ,'Cierre de inversiones'
    ,'Inversiones desactiadas')

ruta <- 
  c('https://fs.datosabiertos.mef.gob.pe/datastorefiles/Proceso_Selecccion_Diccionario.csv'
    ,'https://fs.datosabiertos.mef.gob.pe/datastorefiles/Detalle_Inversiones_Diccionario.csv'
    ,'https://fs.datosabiertos.mef.gob.pe/datastorefiles/Directorio_Invierte_diccionario.csv'
    ,'https://fs.datosabiertos.mef.gob.pe/datastorefiles/Estado_Situacional_Diccionario.csv'
    ,'https://fs.datosabiertos.mef.gob.pe/datastorefiles/F12B_Diccionario.csv'
    ,'https://fs.datosabiertos.mef.gob.pe/datastorefiles/Inversiones_Brechas_Diccionario.csv'
    ,'https://fs.datosabiertos.mef.gob.pe/datastorefiles/Cierre_Inversiones_Diccionario.csv'
    ,'https://fs.datosabiertos.mef.gob.pe/datastorefiles/Inversiones_Desactivadas_Diccionario.csv')

diccionario <- purrr::map2_df( ruta , fuente , ~{read_csv(.x) %>% mutate(Fuente=.y) } )

arrow::write_parquet( diccionario , 'DICCIONARIO.parquet' )
save( diccionario , file='DICCIONARIO.RData'   )
rio::export( diccionario , file="DICCIONARIO.xlsx"    )



arrow::write_parquet( cierre         , 'CIERRE_INVERSIONES.parquet' )
arrow::write_parquet( detalle        , 'DETALLE_INVERSIONES.parquet' )
arrow::write_parquet( operadores     , 'DIRECTORIO_INVIERTE.parquet' )
arrow::write_parquet( estado         , 'ESTADO_SITUACIONAL.parquet' )
arrow::write_parquet( formato12b     , 'FORMATO_12B.parquet' )
arrow::write_parquet( brechas        , 'INVERSIONES_BRECHAS.parquet' )
arrow::write_parquet( desactivadas   , 'INVERSIONES_DESACTIVADAS.parquet' )
arrow::write_parquet( proceso.selecc , 'PROCESO_SELECCION.parquet' )
arrow::write_parquet( diccionario    , 'DICCIONARIO.parquet' )
