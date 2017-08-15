library(dplyr)

##Load global variables
sistemas <- c("IDC", "Ohs Contr","ADM", "RFC Contr","RFC Emp" )
rfc_idc <- sort(c(
  "tqidcprowasj01" , "tqidcprowasj03",  "tqidcprowasj05"  ,"tqidcprowasj07",  "tqidcprowasj09",  "tqidcprowasj11",
  "tqidcprowasj02",  "tqidcprowasj04",  "tqidcprowasj06",  "tqidcprowasj08",  "tqidcprowasj10",  "tqidcprowasj12" ))
ohs_contibuyentes <- sort(c(
  "tqrfcprowebl22" , "tqrfcprowebl24" , "tqrfcprowebl26"  ,"tqrfcprowebl28",  "tqrfcprowebl30"  ,"tqrfcprowebl32",
  "tqrfcprowebl21",  "tqrfcprowebl23",  "tqrfcprowebl25",  "tqrfcprowebl27",  "tqrfcprowebl29",  "tqrfcprowebl31"))
rfc_weblogic_adm <- sort(c(
  "tqrfcprowebl34" , "tqrfcprowebl36",  "tqrfcprowebl38",  "tqrfcprowebl40",  "tqrfcprowebl65"  ,"tqrfcprowebl83",
  "tqrfcprowebl35",  "tqrfcprowebl37",  "tqrfcprowebl39",  "tqrfcprowebl41",  "tqrfcprowebl82",  "tqrfcprowebl84"))
rfc_weblogic_contr <- sort( c(
  "tqrfcprowebl27" , "tqrfcprowebl30",  "tqrfcprowebl46",  "tqrfcprowebl49",  "tqrfcprowebl52",  "tqrfcprowebl55", 
  "tqrfcprowebl58",  "tqrfcprowebl61",  "tqrfcprowebl25",  "tqrfcprowebl28",  "tqrfcprowebl31",  "tqrfcprowebl47", 
  "tqrfcprowebl50",  "tqrfcprowebl53",  "tqrfcprowebl56",  "tqrfcprowebl59",  "tqrfcprowebl62",  "tqrfcprowebl26", 
  "tqrfcprowebl29",  "tqrfcprowebl32",  "tqrfcprowebl48",  "tqrfcprowebl51",  "tqrfcprowebl54",  "tqrfcprowebl57", 
  "tqrfcprowebl60",  "tqrfcprowebl63"))
rfc_weblogic_emp <-sort( c("tqrfcprowebl21",  "tqrfcprowebl22",  "tqrfcprowebl23",  "tqrfcprowebl24",  "tqrfcprowebl42", 
                      "tqrfcprowebl43",  "tqrfcprowebl44",  "tqrfcprowebl45"))
##Hay discrepancia entre los servidores registrados
###Servidores CertiSAT
##Presentación
certisat_pres_jboss <- c("cpcewprojbos01","cpcewprojbos02")

##Procesamiento
certisat_pki_ar_proc <- c("ar_mediador","srv_ar")
certisat_pki_ac_proc <- c("srv_ac")
certisat_ara_cpn <- c("aras_cpn")
certisat_ara_qro <- c("tqpkiprofara01","tqpkiprofara02","tqpkiprofara03","tqpkiprofara04")

###Servidores BuzonT
buzon_web_contr <- sort(c("tqbznprowebc02","tqbznprowebc03","tqbznprowebc04","tqbznprowebc05","tqbznprowebc06","tqbznprowebc07",
                     "tqbznprowebc08","tqbznprowebc09","tqbznprowebc10","tqbznprowebc11","tqbznprowebc12","tqbznprowebc13",
                     "tqbznprowebc14","tqbznprowebc15"))

##We read the error log matrix
m <-read.table(file="data/mymatrix7.txt",sep =  ",",row.names = 1 )
##Get the X axis intervals
interval <-t <-strptime(row.names(m), format= "%b %d, %Y %H:%M:%S") 
##Get the column names
cols <- colnames(m)
ap <- c(rep("CertiSAT",10),rep("Buzón Tributario",14),rep("RFC Ampliado",39))
el <- c(rep("ARAS QRO",4),"AC Proc","ARAS CPN", "AR Proc", "AR Pres", "AR Pres", "AR Proc", rep("Buzon Web",14) , rep("RFC Emp",4), 
        rep("RFC Contr",7),rep("ADM",7), rep("RFC Emp",4), rep("RFC Contr",13),rep("ADM",4))
ac <- c("tqp01","tqp02","tqp03","tqp04","ars_", "srv_c", "ar_m", "cp01", "c02", "srv_r","tqb02","tqb03" ,"tqb04", "t05", "t06" ,"t07" ,"t08" ,"t09","t10", "t11",
        "t12", "t13", "t14", "t15", "t21", "t22", "t23" ,"t24", "t26", "t27" ,"t28", "t29", "t30", "t31" ,"t32", "t34" ,"t35",
        "t36", "t37", "t38", "t39", "t40" ,"t42", "t43", "t44" ,"t45","t46", "t47", "t48", "t49", "t50" ,"t51", "t52",
        "t53", "t54", "t55" ,"t56" ,"t57" ,"t58" ,"t65","t82", "t83", "t84" )

tabla<-data.frame(Aplicación=ap,Elemento=el,Servidor=cols,Acrónimo=ac)
t <- tabla %>% group_by(Aplicación)

