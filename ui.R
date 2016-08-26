
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#
if(!require(shiny)) { install.packages("shiny",
                      repos="http://cran.us.r-project.org", dependencies=TRUE) }

if(!require(shinydashboard)) { install.packages("shinydashboard",
                                repos="http://cran.us.r-project.org", dependencies=TRUE) }

if(!require(networkD3)) { install.packages("networkD3", 
                           repos="http://cran.us.r-project.org", dependencies=TRUE) }

if(!require(plotly)) { install.packages("plotly", 
                        repos="http://cran.us.r-project.org", dependencies=TRUE) }

if(!require(ggplot2)) { install.packages("ggplot2",
                        repos="http://cran.us.r-project.org", dependencies=TRUE) }


ui<-dashboardPage(
  
  dashboardHeader(title ="Análisis de Prosodia"),
  dashboardSidebar(
    sidebarMenu(
      
      checkboxInput("comp", "Comparar"),
      uiOutput("fileControl"),
      conditionalPanel(
        condition = "input.comp == true",
        uiOutput("fileControl2")
      ),
      menuItem("A) Señales", tabName = "senal"), 
      menuItem("B) Análisis de Segmentos", tabName = "segmentos"), 
      menuItem("C) Participantes", tabName = "comparacion"),
      menuItem("D) Visualización", tabName = "grafo")      
    )
  ),
  dashboardBody(
    tabItems(

      tabItem(tabName = "senal",h2("Señales")
              , column(12,plotlyOutput("sigPlot")),
              conditionalPanel(
                condition = "input.comp == true",
                column(12,plotlyOutput("sigPlot2"))
              )
              
      ),
      
      tabItem(tabName = "segmentos",h2("Segmentos")
              , plotlyOutput("custPlot"),
              conditionalPanel(
                condition = "input.comp == true",
                plotlyOutput("custPlot2")
              )
      ), 
      
      tabItem(tabName = "comparacion",h2("Participantes"),
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
      tabItem(tabName = "grafo",h2("Grafos")
              ,forceNetworkOutput("force"),
              conditionalPanel(
                condition = "input.comp == true",
                forceNetworkOutput("force2")
              )
      )
    )
    
  )
)

