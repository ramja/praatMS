
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
  
  dashboardHeader(title ="Correlacionador de Errores (Draft)",titleWidth = 450),
  dashboardSidebar(
    sidebarMenu(
      withTags(div(class='row-fluid',
                   div(class='span3', checkboxInput("comp1", "Presentación", value=TRUE)),
                   div(class='span5', checkboxInput("comp2", "Procesamiento", value=TRUE))
      )),
      #conditionalPanel(condition="input.menu == 'grafo'", checkboxInput("xx", "XXX")),
      menuItem("A) Servidores RFC", tabName = "servers"), 
      menuItem("B) Servidores Buzón T", tabName = "serversB"), 
      menuItem("C) Servidores CertiSAT", tabName = "serversC"), 
      menuItem("D) Análisis de Correlación", tabName = "segmentos"), 
      menuItem("E) Visualización", tabName = "grafo"),
      id="menu"
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "servers",
              conditionalPanel(
                condition = "input.comp1 == true",
                h3("Presentación"),
                
                fluidRow(
                  # column(width = 4,
                  #       box(
                  #        title = "IDC", width = NULL, status = "warning",
                  #       checkboxGroupInput("idc", "Choose icons:",
                  #                          choices = rfc_idc,
                  #                          selected = rfc_idc
                  #       )
                  #     )
                  
                  #  ),
                  
                  #column(width = 4,
                  #       box(
                  #         title = "OHS Contr", width = NULL, status = "warning",
                  #         checkboxGroupInput("ohs", "Seleccione servidores:",
                  #                            choices = ohs_contibuyentes,
                  #                            selected = ohs_contibuyentes
                  #         ),
                  #         actionLink("selectall1","Seleccionar Todos")
                  #       )
                  #)
                )
              ),
              conditionalPanel(
                condition = "input.comp2 == true",
                h3("Procesamiento"),
                fluidRow(
                  column(width = 4,
                         box(
                           title = "ADM", width = NULL, status = "primary",
                           checkboxGroupInput("adm", "Seleccione servidores:",
                                              choices = rfc_weblogic_adm,
                                              selected = rfc_weblogic_adm
                           ),
                           actionLink("selectall2","Seleccionar Todos")
                         )
                         
                  ),
                  
                  column(width = 4,
                         box(
                           title = "RFC Emp", width = NULL, status = "primary",
                           checkboxGroupInput("emp", "Seleccione servidores:",
                                              choices = rfc_weblogic_emp,
                                              selected = rfc_weblogic_emp
                           ),
                           actionLink("selectall3","Seleccionar Todos")
                         )
                  ),
                  column(width = 4,
                         box(
                           title = "RFC Contr", width = NULL, status = "primary",
                           checkboxGroupInput("contr", "Seleccione servidores:",
                                              choices = rfc_weblogic_contr,
                                              selected = rfc_weblogic_contr
                           ),
                           actionLink("selectall4","Seleccionar Todos")
                         )
                         
                  )
                )
              )
              
      ),
      tabItem(tabName = "serversB",
              conditionalPanel(
                condition = "input.comp1 == true",
                h3("Presentación"),
                
                fluidRow(
                  # column(width = 4,
                  #       box(
                  #        title = "IDC", width = NULL, status = "warning",
                  #       checkboxGroupInput("idc", "Choose icons:",
                  #                          choices = rfc_idc,
                  #                          selected = rfc_idc
                  #       )
                  #     )
                  
                  #  ),
                  
                  #column(width = 4,
                  #       box(
                  #         title = "OHS Contr", width = NULL, status = "warning",
                  #         checkboxGroupInput("ohs", "Seleccione servidores:",
                  #                            choices = ohs_contibuyentes,
                  #                            selected = ohs_contibuyentes
                  #         ),
                  #         actionLink("selectall1","Seleccionar Todos")
                  #       )
                  #)
                )
              ),
              conditionalPanel(
                condition = "input.comp2 == true",
                h3("Procesamiento"),
                fluidRow(
                  column(width = 4,
                         box(
                           title = "Buzón Web", width = NULL, status = "primary",
                           checkboxGroupInput("buz", "Seleccione servidores:",
                                              choices = buzon_web_contr,
                                              selected = buzon_web_contr
                           ),
                           actionLink("selectall5","Seleccionar Todos")
                         )
                         
                  )
                  
                )
              )
              
      ),
      tabItem(tabName = "serversC",
              conditionalPanel(
                condition = "input.comp1 == true",
                h3("Presentación"),
                
                fluidRow(
                 # column(width = 4,
                  #       box(
                   #        title = "IDC", width = NULL, status = "warning",
                    #       checkboxGroupInput("idc", "Choose icons:",
                    #                          choices = rfc_idc,
                    #                          selected = rfc_idc
                    #       )
                    #     )
                         
                #  ),
                  
                  column(width = 4,
                         box(
                           title = "CertiSAT Web Presentación", width = NULL, status = "warning",
                           checkboxGroupInput("certi_pres", "Seleccione servidores:",
                                              choices = certisat_pres_jboss,
                                              selected = certisat_pres_jboss
                           ),
                           actionLink("selectall6","Seleccionar Todos")
                         )
                  )
                )
              ),
              conditionalPanel(
                condition = "input.comp2 == true",
                h3("Procesamiento"),
                fluidRow(
                  column(width = 4,
                         box(
                           title = "AR Procesamiento", width = NULL, status = "primary",
                           checkboxGroupInput("ar", "Seleccione servidores:",
                                              choices = certisat_pki_ar_proc,
                                              selected = certisat_pki_ar_proc
                           ),
                           actionLink("selectall7","Seleccionar Todos")
                         )
                         
                  ),
                  column(width = 4,
                         box(
                           title = "AC Procesamiento", width = NULL, status = "primary",
                           checkboxGroupInput("ac", "Seleccione servidores:",
                                              choices = certisat_pki_ac_proc,
                                              selected = certisat_pki_ac_proc
                           ),
                           actionLink("selectall8","Seleccionar Todos")
                         )
                         
                  ),
                  
                  column(width = 4,
                         box(
                           title = "ARA CPN", width = NULL, status = "primary",
                           checkboxGroupInput("cpn", "Seleccione servidores:",
                                              choices = certisat_ara_cpn,
                                              selected = certisat_ara_cpn
                           ),
                           actionLink("selectall1","Seleccionar Todos")
                         )
                  ),
                  column(width = 4,
                         box(
                           title = "ARA Qro", width = NULL, status = "primary",
                           checkboxGroupInput("qro", "Seleccione servidores:",
                                              choices = certisat_ara_qro,
                                              selected = certisat_ara_qro
                           ),
                           actionLink("selectall9","Seleccionar Todos")
                         )
                         
                  )
                )
              )
              
      ),
      
      tabItem(tabName = "segmentos",h2("Gráfica de Correlaciones"),
         #     checkboxInput("comp3", "Eliminar no significativas", value=TRUE),
          #    sliderInput("control2", "Nivel de Corte (Correlación):", min=0, max=.69, value=.12,
          #                step=.001),
              plotlyOutput("custPlot"),
              conditionalPanel(                condition = "input.comp == true",
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
      tabItem(tabName = "grafo",h2("Grafos"),
              sliderInput("control", "Nivel de Corte (Correlación):", min=0, max=.69, value=.12,
                          step=.001),
              plotOutput("plot2"),
              
              conditionalPanel(
                condition = "input.comp1 == true",
                fluidRow(
                #column(12,div(style = "height:20px;background-color: light-blue;", plotOutput("tabla1")))
                column(12, h2('Servidores'),
                       dataTableOutput('mytable'))
                )#,
               # fluidRow(
              #   column(12,plotOutput("tabla2"))
             #  ),
            #    fluidRow(
            #     column(12,plotOutput("tabla3"))
            #   ),
               # fluidRow(
              #   column(12,plotOutput("tabla4"))
              # ), 
              #  fluidRow(
               #  column(12,plotOutput("tabla5"))
              # ),
              # fluidRow(
              #   column(12,plotOutput("tabla6"))
               #)
              )

      )
    )
    
  )
)

