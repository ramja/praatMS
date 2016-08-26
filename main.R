#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

# test if there is at least one argument: if not, return an error
if (length(args)==0) {
  stop("At least one argument must be supplied (input file).n", call.=FALSE)
} else if (length(args)==1) {
  # default output file
  args[2] = "out.txt"
}

# check if necessary libraries installed. If not install them
PraatRInstalled = require("PraatR") 
if(!PraatRInstalled){ install.packages("PraatR") } 
clusterInstalled = require("cluster") 
if(!clusterInstalled){ install.packages("cluster") } 
igraphInstalled = require("igraph") 
if(!igraphInstalled){ install.packages("igraph") } 

## Local Base Directory. Change to the one you'll use to store your audios
PitchDirectory = args[2]
fileName = args[1]

## Utility and functional routines
source('src/util.R', local = TRUE)
source('src/preProcFunctions.R', local = TRUE)

data<-getProsodicData(fileName)
## We obtain intervals from file data
inter <- getIntervals(data)

##now we focus on spoken intervals and obtain descriptive data
# Duration. Duration of the spoken segment in miliseconds
# F0. Mean F0 of the segment
# F0Var. Variance of FO in the segment
# Q4F0. Last quantile of the F0 distribution (.9)
# MaxF0. Maximum value of F0 in the interval
# F0Range.= .9 .1 quantile
# Strength. Mean Strength of the segment
# StrengthVar. Variance of Strength in the interval
# IntensityVar Variance of Strength in the interval
# Intensity Mean of Strength in the interval
# Q4Intensity Last quantile of the Intensity distribution (.9)
# MaxIntensity. Maximum value of Intensity0 in the interval

gStat<-gStats(data,inter$Intervals)

#Then we select which statistic to use for clustering segments
gDesc<-gStat#[,c("F0","Q4F0","F0Range","MaxF0","Strength","Intensity","Q4Intensity","MaxIntensity")]
## we cluster the spoken intervals
cl3 <- pam(gDesc, 2)$clustering


#obtain first 5 letters of fileName to name the nodes of the graph
prefix<-paste(substr(fileName, 1, 4),"-",sep = "")
#compute al the edges of the graph
edges <- c(paste(prefix, 1))
for (i in inter$SilIntervals[, 1]) {
  edges <-
    c(edges, paste(prefix, round(i * 100)), paste(prefix, round(i * 100)))
}
edges <- edges[-length(edges)]
##We create a graph representing a secuence of segments
dataGraph<-graph(edges, n=length(SilIntervals), directed=TRUE)

##We enrich the graph with information of the voice segments

E(dataGraph)$weight <- inter$SilIntervals[, 2]


V(dataGraph)$group <- c(0, cl3, 0)

V(dataGraph)$weight <- c(0, gStat$Duration, 0)

V(dataGraph)$pitchr <- c(0, gStat$F0Range, 0)

V(dataGraph)$intensity <- c(0, gStat$Intensity, 0)

##write graph to a .graphml format
graphFileName=paste(substr(fileName, 1, 4),".graphml", sep="")

write.graph(dataGraph,graphFileName, "graphml")




