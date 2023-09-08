## Utility and functional routines
source('src/util.R', local = TRUE)
source('src/preProcFunctions.R', local = TRUE)

# We load libraries we gonna use
#



if(!require(git2r)) { install.packages("git2r", 
                                       repos="http://cran.us.r-project.org", dependencies=TRUE) }
if(!require(devtools)) { install.packages("devtools", 
                                          repos="http://cran.us.r-project.org", dependencies=TRUE) }
if(!require(dplyr)) { install.packages("dplyr",
                                       repos="http://cran.us.r-project.org", dependencies=TRUE) }
if(!require(plotly)) { install.packages("plotly", 
                                        repos="http://cran.us.r-project.org", dependencies=TRUE) }
if(!require(PraatR)) { devtools:::install_github('usagi5886/PraatR')}
if(!require(audio)) { install.packages("audio",
                                       repos="http://cran.us.r-project.org", dependencies=TRUE) }


if(!require(cluster)) { install.packages("cluster",
                                         repos="http://cran.us.r-project.org", dependencies=TRUE) }
if(!require(igraph)) {  install_inplace("igraph") }
if(!require(ggfortify)) { install.packages("ggfortify",
                                           repos="http://cran.us.r-project.org", dependencies=TRUE) }
if(!require(gridExtra)) { install.packages("gridExtra",
                                           repos="http://cran.us.r-project.org", dependencies=TRUE) }
if(!require(shinydashboard)) { install.packages("shinydashboard",
                                                repos="http://cran.us.r-project.org", dependencies=TRUE) }
if(!require(networkD3)) { install.packages("networkD3",
                                           repos="http://cran.us.r-project.org", dependencies=TRUE) }

##Load global variables

