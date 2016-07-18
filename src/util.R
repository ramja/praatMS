## Función que añade a un nombre de archivo la ruta absoluta 
FullPath = function(FileName){ return( paste(PitchDirectory,FileName,sep="") ) }

# Encontraremos los intervalos en que no existe voz
fIntervals<-function(X,sil=2000) {
  I<-which( (is.na(c(NA,X)-c(X,NA)) & !is.na(c(X,NA))) | (is.na(c(X,NA)-c(NA,X)) & !is.na(c(NA,X))) )
  min<-c()
  max<-c()
  for (i in 1:(floor(length(I)/2)-1)){
    if (I[2*i+1]-I[2*i] > sil) {
      min<-c(min,I[2*i])
      max<-c(max,I[2*i+1]-1)
    }
  }
  ref<-list()
  ref$min<-min
  ref$max<-max
  return(ref)
}

factExpan<-function(X,Intervals,f){ 
  fact<-as.numeric(f)
  clas<-c(rep(0,Intervals$min[1]-1))
  Duration<-c()
  for ( i in 1:(length(Intervals$min)-1)){
    clas<-c(clas,rep(0,Intervals$max[i]-Intervals$min[i]))
    Duration<-c(Duration,Intervals$min[i+1]-Intervals$max[i])
    clas<-c(clas,rep(fact[i],Intervals$min[i+1]-Intervals$max[i]))
    
    
  }
  clas<-c(clas,rep(0,(length(X$F0)-length(clas))))
  nf<-factor(clas)
  res<-list()
  res$Duration<-Duration
  res$factor<-nf
  res
  
}
###Prueba Unitaria####
# imin=c(1,4,6)
# imax=c(3,5,10)
# ref<-list()
# ref$min<-imin
# ref$max<-imax
# f<-factor(c(1,2,1))
# data=data.frame('V1'=rep(1,10))
# v<-factExpan(data,ref,f )

gStats<-function(X,Intervals){
  F0<-c()
  F0Sum<-c()
  Duration<-c()
  F0Var<-c()
  Q4F0<-c()
  F0Range<-c()
  MaxF0<-c()
  Strength<-c()
  IntensityVar<-c()
  Intensity<-c()  
  Q4Intensity<-c()
  MaxIntensity<-c()
  F0Sum<-c()
  for ( i in 1:(length(Intervals$min)-1)){
    
    Duration<-c(Duration,Intervals$min[i+1]-Intervals$max[i])
    F0<-c(F0,mean(X[Intervals$max[i]:Intervals$min[i+1],'F0'],na.rm = TRUE))
    F0Var<-c(F0Var,var(X[Intervals$max[i]:Intervals$min[i+1],'F0'],na.rm = TRUE))
    Q4F0<-c(Q4F0,quantile(X[Intervals$max[i]:Intervals$min[i+1],'F0'], na.rm = TRUE, c(.9)))
    F0Range<-c(F0Range,(quantile(X[Intervals$max[i]:Intervals$min[i+1],'F0'], na.rm = TRUE, c(.9))-quantile(X[Intervals$max[i]:Intervals$min[i+1],'F0'], na.rm = TRUE, c(.1))))
    MaxF0<-c(MaxF0,max(X[Intervals$max[i]:Intervals$min[i+1],'F0'], na.rm = TRUE))
    Strength<-c(Strength,mean(X[Intervals$max[i]:Intervals$min[i+1],'Strength'],na.rm = TRUE))
    Intensity<-c(Intensity,mean(X[Intervals$max[i]:Intervals$min[i+1],'Intensity'],na.rm = TRUE))
    IntensityVar<-c(IntensityVar,sum(X[Intervals$max[i]:Intervals$min[i+1],'Intensity'],na.rm = TRUE))
    Q4Intensity<-c(Q4Intensity,quantile(X[Intervals$max[i]:Intervals$min[i+1],'Intensity'], na.rm = TRUE, c(.9)))
    MaxIntensity<-c(MaxIntensity,max(X[Intervals$max[i]:Intervals$min[i+1],'Intensity'], na.rm = TRUE))
  }
  data.frame('Duration'= Duration, 'F0'=F0, 'F0Var'=F0Var,'Q4F0'=Q4F0,'MaxF0'=MaxF0,
             'F0Range'= F0Range,'Strength'=Strength,'IntensityVar'=IntensityVar,'Intensity'=Intensity,
             'Q4Intensity'=Q4Intensity,'MaxIntensity'=MaxIntensity)
}

gMeans<-function(X,Intervals){
  F0<-c()
  Q4F0<-c()
  F0Range<-c()
  MaxF0<-c()
  Strength<-c()
  Intensity<-c()
  Q4Intensity<-c()
  MaxIntensity<-c()
  for ( i in 1:(length(Intervals$min)-1)){
    F0<-c(F0,mean(X[Intervals$max[i]:Intervals$min[i+1],'F0'],na.rm = TRUE))
    Q4F0<-c(Q4F0,quantile(X[Intervals$max[i]:Intervals$min[i+1],'F0'], na.rm = TRUE, c(.9)))
    F0Range<-c(F0Range,(quantile(X[Intervals$max[i]:Intervals$min[i+1],'F0'], na.rm = TRUE, c(.9))-quantile(X[Intervals$max[i]:Intervals$min[i+1],'F0'], na.rm = TRUE, c(.1))))
    MaxF0<-c(MaxF0,max(X[Intervals$max[i]:Intervals$min[i+1],'F0'], na.rm = TRUE))
    Strength<-c(Strength,mean(X[Intervals$max[i]:Intervals$min[i+1],'Strength'],na.rm = TRUE))
    Intensity<-c(Intensity,mean(X[Intervals$max[i]:Intervals$min[i+1],'Intensity'],na.rm = TRUE))
    Q4Intensity<-c(Q4Intensity,quantile(X[Intervals$max[i]:Intervals$min[i+1],'Intensity'], na.rm = TRUE, c(.9)))
    MaxIntensity<-c(MaxIntensity,max(X[Intervals$max[i]:Intervals$min[i+1],'Intensity'], na.rm = TRUE))
  }
  data.frame('F0'=F0,'Q4F0'=Q4F0,'MaxF0'=MaxF0,'F0Range'= F0Range,'Strength'=Strength,'Intensity'=Intensity,'Q4Intensity'=Q4Intensity)
}
