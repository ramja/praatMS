
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#
if(!require(shiny)) { install.packages("shiny",
                      repos="http://cran.us.r-project.org", dependencies=TRUE) }

if(!require(shinydashboard)) { install.packages("shinydashboard",
                                repos="http://cran.us.r-project.org", dependencies=TRUE) }

if(!require(igraph)) {  install_inplace("igraph") }

if(!require(networkD3)) { install.packages("networkD3", 
                           repos="http://cran.us.r-project.org", dependencies=TRUE) }

if(!require(plotly)) { install.packages("plotly", 
                        repos="http://cran.us.r-project.org", dependencies=TRUE) }

if(!require(ggplot2)) { install.packages("ggplot2",
                        repos="http://cran.us.r-project.org", dependencies=TRUE) }


ui<-dashboardPage(
  
  dashboardHeader(title ="Prosodic Analisys"),
  dashboardSidebar(
    sidebarMenu(
      
      checkboxInput("comp", "Compare"),
      uiOutput("fileControl"),
      conditionalPanel(
        condition = "input.comp == true",
        uiOutput("fileControl2")
      ),
      menuItem("A) Signals", tabName = "senal"), 
      menuItem("B) Segment Analisys", tabName = "segmentos"), 
      menuItem("C) Participants", tabName = "comparacion"),
      menuItem("D) Visualizatión", tabName = "grafo")        
    )
  ),
  dashboardBody(
    tabItems(

      tabItem(tabName = "senal",h2("Signals")
              , column(12,plotlyOutput("sigPlot")),
              conditionalPanel(
                condition = "input.comp == true",
                column(12,plotlyOutput("sigPlot2"))
              )
              
      ),
      
      tabItem(tabName = "segmentos",h2("Segments")
              , plotlyOutput("custPlot"),
              conditionalPanel(
                condition = "input.comp == true",
                plotlyOutput("custPlot2")
              )
      ), 
      
      tabItem(tabName = "comparacion",h2("Participants"),
              #,fluidRow(
              #   # box(title = "Box title",plotlyOutput("his1Plot")),
              #   # box(title = "Box title",plotlyOutput("hisPlot2")),
              #   box(title = "Box title",dataTableOutput("mytable"))
              #   #splitLayout(cellWidths = c("50%", "50%"), plotlyOutput("his1Plot"), plotlyOutput("his2Plot"))
              # ),
              column(12,splitLayout(cellWidths = c("50%", "50%"), plotlyOutput("hisF01Plot"), plotlyOutput("hisF02Plot")),
              splitLayout(cellWidths = c("50%", "50%"), plotlyOutput("hisInt1Plot"), plotlyOutput("hisInt2Plot"))),
              conditionalPanel(
                condition = "input.comp == true",
                column(12,splitLayout(cellWidths = c("50%", "50%"), plotlyOutput("hisF01Plot2"), plotlyOutput("hisF02Plot2")),
                splitLayout(cellWidths = c("50%", "50%"), plotlyOutput("hisInt1Plot2"), plotlyOutput("hisInt2Plot2")))
              )

      ),
      tabItem(tabName = "grafo",h2("Graphs")
              ,forceNetworkOutput("force"),
              conditionalPanel(
                condition = "input.comp == true",
                forceNetworkOutput("force2")
              )
      )
    )
    
  )
)

