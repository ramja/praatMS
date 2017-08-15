


# We load libraries we gonna use
#
if(!require(ggcorrplot)) { install.packages("ggcorrplot",
                      repos="http://cran.us.r-project.org", dependencies=TRUE) }
if(!require(qgraph)) { install.packages("qgraph",
                        repos="http://cran.us.r-project.org", dependencies=TRUE) }
if(!require(cluster)) { install.packages("cluster",
                        repos="http://cran.us.r-project.org", dependencies=TRUE) }
if(!require(igraph)) { install.packages("igraph",
                        repos="http://cran.us.r-project.org", dependencies=TRUE) }
if(!require(ggfortify)) { install.packages("ggfortify",
                          repos="http://cran.us.r-project.org", dependencies=TRUE) }
if(!require(gridExtra)) { install.packages("gridExtra",
                          repos="http://cran.us.r-project.org", dependencies=TRUE) }


## Local Base Directory. Change to the one you'll use to store your audios
PitchDirectory = "/tmp/"

## Utility and functional routines
#source('src/util.R', local = TRUE)
#source('src/preProcFunctions.R', local = TRUE)


## This functions adds local directory to file to make a full path
FullPath = function(FileName) {
  return(paste(PitchDirectory, FileName, sep = ""))
}

# We stablish our local directory as work directory
setwd(PitchDirectory)

# List of wav files to be analized
CurrentFileNames = c(list.files(pattern = "wav$"))




shinyServer(function(input, output, session) {
  observe(print(input$ohs))
  #observe(ohsInput())
  
  observe({
    if(input$selectall1 == 0) return(NULL) 
    else if (input$selectall1%%2 == 0)
    {
      updateCheckboxGroupInput(session,"cpn","Seleccione servidores:",choices=certisat_ara_cpn)
    }
    else
    {
      updateCheckboxGroupInput(session,"cpn","Seleccione servidores:",choices=certisat_ara_cpn,selected=certisat_ara_cpn)
    }
  })
  
  observe({
    if(input$selectall2 == 0) return(NULL) 
    else if (input$selectall2%%2 == 0)
    {
      updateCheckboxGroupInput(session,"adm","Seleccione servidores:",choices=rfc_weblogic_adm)
    }
    else
    {
      updateCheckboxGroupInput(session,"adm","Seleccione servidores:",choices=rfc_weblogic_adm,selected=rfc_weblogic_adm)
    }
  })
  
  observe({
    if(input$selectall3 == 0) return(NULL) 
    else if (input$selectall3%%2 == 0)
    {
      updateCheckboxGroupInput(session,"emp","Seleccione servidores:",choices=rfc_weblogic_emp)
    }
    else
    {
      updateCheckboxGroupInput(session,"emp","Seleccione servidores:",choices=rfc_weblogic_emp,selected=rfc_weblogic_emp)
    }
  })
  
  observe({
    if(input$selectall4 == 0) return(NULL) 
    else if (input$selectall4%%2 == 0)
    {
      updateCheckboxGroupInput(session,"contr","Seleccione servidores:",choices=rfc_weblogic_contr)
    }
    else
    {
      updateCheckboxGroupInput(session,"contr","Seleccione servidores:",choices=rfc_weblogic_contr,selected=rfc_weblogic_contr)
    }
  })
  
  observe({
    if(input$selectall5 == 0) return(NULL) 
    else if (input$selectall5%%2 == 0)
    {
      updateCheckboxGroupInput(session,"buz","Seleccione servidores:",choices=buzon_web_contr)
    }
    else
    {
      updateCheckboxGroupInput(session,"buz","Seleccione servidores:",choices=buzon_web_contr,selected=rfc_weblogic_contr)
    }
  })

  observe({
    if(input$selectall6 == 0) return(NULL) 
    else if (input$selectall6%%2 == 0)
    {
      updateCheckboxGroupInput(session,"certi_pres","Seleccione servidores:",choices=certisat_pres_jboss)
    }
    else
    {
      updateCheckboxGroupInput(session,"certi_pres","Seleccione servidores:",choices=certisat_pres_jboss,selected=certisat_pres_jboss)
    }
  })
  
  observe({
    if(input$selectall7 == 0) return(NULL) 
    else if (input$selectall7%%2 == 0)
    {
      updateCheckboxGroupInput(session,"ar","Seleccione servidores:",choices=certisat_pki_ar_proc)
    }
    else
    {
      updateCheckboxGroupInput(session,"ar","Seleccione servidores:",choices=certisat_pki_ar_proc,selected=certisat_pki_ar_proc)
    }
  })
  
  observe({
    if(input$selectall8 == 0) return(NULL) 
    else if (input$selectall8%%2 == 0)
    {
      updateCheckboxGroupInput(session,"ac","Seleccione servidores:",choices=certisat_pki_ac_proc)
    }
    else
    {
      updateCheckboxGroupInput(session,"ac","Seleccione servidores:",choices=certisat_pki_ac_proc,selected=certisat_pki_ac_proc)
    }
  })
  
  observe({
    if(input$selectall9 == 0) return(NULL) 
    else if (input$selectall9%%2 == 0)
    {
      updateCheckboxGroupInput(session,"qro","Seleccione servidores:",choices=certisat_ara_qro)
    }
    else
    {
      updateCheckboxGroupInput(session,"qro","Seleccione servidores:",choices=certisat_ara_qro,selected=certisat_ara_qro)
    }
  })
  
  # store as a vector to be called wherever desired
  # evaluated whenever inputs change
  ohsInput <- reactive({
    perm.vector <- as.vector(input$ohs)
    perm.vector
  }) 
  
  gFileNames <- reactive({
    # List of wav files to be analized
    c(list.files(pattern = "wav$"), "")
  })
  
  gInter <- reactive({
    data <- gFileData()
    if (!is.null(data)) {
      getIntervals(data)
    }
  })
  
  gInter2 <- reactive({
    data <- gFileData2()
    if (!is.null(data)) {
      getIntervals(data)
    }
  })
  
  gDesc <- reactive({
    data <- gFileData()
    if (!is.null(data)) {
      # on.exit(progress$close())
      
      # We get audio intervals from audio data
      inter <- gInter()
      # We obtain data to clasify parts of audio on participants
      gMeans(data, inter$Intervals)
      
      
    }
    
  })
  
  gDesc2 <- reactive({
    data <- gFileData2()
    if (!is.null(data)) {
      # on.exit(progress$close())
      
      # We get audio intervals from audio data
      inter <- gInter2()
      # We obtain data to clasify parts of audio on participants
      gMeans(data, inter$Intervals)
      
      
    }
    
  })
  
  gStat <- reactive({
    data <- gFileData()
    if (!is.null(data)) {

      # First we get the intervals of the file
      
      inter <- getIntervals(data)
      # Then we obtain descriptive statistics of each segment of the file
      gStats(data, inter$Intervals)
      
      
    }
    
  })
  
  gStat2 <- reactive({
    data <- gFileData2()
    if (!is.null(data)) {
      # First we get the intervals of the file
      inter <- getIntervals(data)
      # Then we obtain descriptive statistics of each segment of the file
      gStats(data, inter$Intervals)
      
      
    }
    
  })
  
  gApp1Data <- reactive({
    serv <- c()
    if (!is.null(m)) {
      
      if (input$comp1) {
        #serv <- c(serv, match(rfc_idc,cols))
        #serv <- c(serv, match(input$certi_pres,cols))
        serv <- c(serv, match(input$qro,cols))
      }
      if (input$comp2) {
        serv <- c(serv, match(input$emp,cols))
        serv <- c(serv, match(input$contr,cols))
        serv <- c(serv, match(input$adm,cols))
        #serv <- c(serv, match(input$buz,cols))
        #serv <- c(serv, match(input$ar,cols))
        #serv <- c(serv, match(input$ac,cols))
        #serv <- c(serv, match(input$cpn,cols))
        #serv <- c(serv, match(input$qro,cols))
      }
    } else {
      print("ERROR")
    }
    return( unique(serv[!is.na(serv)]))
  })
  
  gApp11Data <- reactive({
    serv <- c()
    if (!is.null(m)) {
      
      if (input$comp1) {
        #serv <- c(serv, match(rfc_idc,cols))
        #serv <- c(serv, match(input$certi_pres,cols))
        serv <- c(serv, match(input$qro,cols))
      }
     
    } else {
      print("ERROR")
    }
    return( unique(serv[!is.na(serv)]))
  })
 
  gApp12Data <- reactive({
    serv <- c()
    if (!is.null(m)) {
      
      if (input$comp2) {
        serv <- c(serv, match(input$emp,cols))
      }
      
    } else {
      print("ERROR")
    }
    return( unique(serv[!is.na(serv)]))
  })   
  
  gApp13Data <- reactive({
    serv <- c()
    if (!is.null(m)) {
      
      if (input$comp2) {
        serv <- c(serv, match(input$contr,cols))
      }
      
    } else {
      print("ERROR")
    }
    return( unique(serv[!is.na(serv)]))
  })  
  
  gApp14Data <- reactive({
    serv <- c()
    if (!is.null(m)) {
      
      if (input$comp2) {
        serv <- c(serv, match(input$adm,cols))
      }
      
    } else {
      print("ERROR")
    }
    return( unique(serv[!is.na(serv)]))
  })    
  
  gApp2Data <- reactive({
    serv <- c()
    if (!is.null(m)) {
      
      if (input$comp1) {
        #serv <- c(serv, match(rfc_idc,cols))
        #serv <- c(serv, match(input$certi_pres,cols))
      }
      if (input$comp2) {
        #serv <- c(serv, match(input$emp,cols))
        #serv <- c(serv, match(input$contr,cols))
        #serv <- c(serv, match(input$adm,cols))
        serv <- c(serv, match(input$buz,cols))
        #serv <- c(serv, match(input$ar,cols))
        #serv <- c(serv, match(input$ac,cols))
        #serv <- c(serv, match(input$cpn,cols))
        #serv <- c(serv, match(input$qro,cols))
      }
    } else {
      print("ERROR")
    }
    return( unique(serv[!is.na(serv)]))
  })
  
  gApp3Data <- reactive({
    serv <- c()
    if (!is.null(m)) {
      
      if (input$comp1) {
        #serv <- c(serv, match(rfc_idc,cols))
        serv <- c(serv, match(input$certi_pres,cols))
      }
      if (input$comp2) {
        #serv <- c(serv, match(input$emp,cols))
        #serv <- c(serv, match(input$contr,cols))
        #serv <- c(serv, match(input$adm,cols))
        #serv <- c(serv, match(input$buz,cols))
        serv <- c(serv, match(input$ar,cols))
        serv <- c(serv, match(input$ac,cols))
        serv <- c(serv, match(input$cpn,cols))
        serv <- c(serv, match(input$qro,cols))
      }
    } else {
      print("ERROR")
    }
    return( unique(serv[!is.na(serv)]))
  })  
  
  gFileData <- reactive({
    serv <- c()
    if (!is.null(m)) {
      
      if (input$comp1) {
        #serv <- c(serv, match(rfc_idc,cols))
        serv <- c(serv, match(input$certi_pres,cols))
      }
      if (input$comp2) {
        serv <- c(serv, match(input$ar,cols))
        serv <- c(serv, match(input$ac,cols))
        serv <- c(serv, match(input$cpn,cols))
        serv <- c(serv, match(input$qro,cols))     
        serv <- c(serv, match(input$buz,cols))
        serv <- c(serv, match(input$emp,cols))
        serv <- c(serv, match(input$contr,cols))
        serv <- c(serv, match(input$adm,cols))


      }
    } else {
      print("ERROR")
    }
    return( unique(serv[!is.na(serv)]))
  })
  
  gFileData2 <- reactive({
    inFile <- input$inFile2
    if (!is.null(inFile)) {
      withProgress(message = 'Analizando Conversación', value = 0, {
        # on.exit(progress$close())
        
        # We get prosodic data from file using PraatR
        getProsodicData(inFile)
      })
    }
    
  })
  
  dClust <- reactive({
    data <- gDesc()
    if (!is.null(data)) {
      cl3 <- pam(data, 2)
      factores <- factor(cl3$clustering)
      richData <- gFileData()
      if (!is.null(richData)) {
        inter <- getIntervals(gFileData())
        if (!is.null(inter)) {
          f <- factExpan(richData, inter$Intervals, factores)
          fs <- split(richData$F0, f$factor)
          fs
          is<- split(richData$Intensity, f$factor)
          res<-list()
          res$F0=fs
          res$Intensity=is
          res
        }
      }
    }
  })
 
  dClust2 <- reactive({
    data <- gDesc2()
    if (!is.null(data)) {
      cl3 <- pam(data, 2)
      factores <- factor(cl3$clustering)
      richData <- gFileData2()
      if (!is.null(richData)) {
        inter <- getIntervals(gFileData2())
        if (!is.null(inter)) {
          f <- factExpan(richData, inter$Intervals, factores)
          fs <- split(richData$F0, f$factor)
          is<- split(richData$Intensity, f$factor)
          res<-list()
          res$F0=fs
          res$Intensity=is
          res
        }
      }
    }
  })
  
  
  output$fileControl <- renderUI({
    files <- gFileNames()
    if (!is.null(files)) {
      selectInput(
        "inFile",
        "Audio",
        files,
        selected = "",
        multiple = FALSE,
        selectize = TRUE,
        width = NULL,
        size = NULL
      )
    }
    
    
  })
  
  output$fileControl2 <- renderUI({
    files <- gFileNames()
    if (!is.null(files)) {
      selectInput(
        "inFile2",
        "Audio",
        files,
        selected = "",
        multiple = FALSE,
        selectize = TRUE,
        width = NULL,
        size = NULL
      )
    }
    
    
  })
  

  
  output$custPlot <- renderPlotly({
    #data <- gDesc()
    if (!is.null(m)) {
      # Histogram overlaid with kernel density curve
      dat <- data.frame(x=interval, y=m[,1])
      ##Slicing
      serv <- c()
      if (input$comp1) {
      serv <- c(serv, match(rfc_idc,cols))
      serv <- c(serv, match(ohs_contibuyentes,cols))
      }
      if (input$comp2) {
        serv <- c(serv, match(rfc_weblogic_emp,cols))
        serv <- c(serv, match(rfc_weblogic_contr,cols))
        serv <- c(serv, match(rfc_weblogic_adm,cols))
      }
      #serv <- unique(serv[!is.na(serv)])
      serv <- gFileData()
      # # Compute correlations:
      CorMat <- cor_auto(m[,serv])
      # Visualize the correlation matrix
      # --------------------------------
      # method = "square" or "circle"
      #if (input$comp3) {
        gg<-ggcorrplot(CorMat,hc.order= FALSE,tl.cex = 3,sig.level = .60 ,insig = "blank")
      #} else {
      #  gg<-ggcorrplot(CorMat,hc.order= FALSE,tl.cex = 3 )#),insig = "blank")
      #}
      # Draw with black outline, white fill
      #gg<-qplot(dat) +
       # geom_histogram(binwidth=.5, colour="black", fill="white")
      # Density curve
      #gg <-ggplot(dat, aes(x=x)) #+ geom_density()
      #gg <- ggplot(dat, aes(x=x)) + 
      #  geom_histogram(aes(y=..density..),      # Histogram with density instead of count on y-axis
      #                 binwidth=.5,
      #                 colour="black", fill="white") +
      #  geom_density(alpha=.2, fill="#FF6666")  # Overlay with transparent density plot
      
      
      p <- ggplotly(gg)
      p
    }
  })
  
  output$corAppPlot <- renderPlotly({
    #data <- gDesc()
    if (!is.null(m)) {
      # Histogram overlaid with kernel density curve
      dat <- data.frame(x=interval, y=m[,1])
      #serv <- unique(serv[!is.na(serv)])
      serv <- gFileData()
      # # Compute correlations:
      CorMat <- cor_auto(m[,serv])
      # Visualize the correlation matrix
      # --------------------------------
      # method = "square" or "circle"
      gg<-ggcorrplot(CorMat,hc.order= TRUE,tl.cex = 3)
      # Draw with black outline, white fill
      #gg<-qplot(dat) +
      # geom_histogram(binwidth=.5, colour="black", fill="white")
      # Density curve
      #gg <-ggplot(dat, aes(x=x)) #+ geom_density()
      #gg <- ggplot(dat, aes(x=x)) + 
      #  geom_histogram(aes(y=..density..),      # Histogram with density instead of count on y-axis
      #                 binwidth=.5,
      #                 colour="black", fill="white") +
      #  geom_density(alpha=.2, fill="#FF6666")  # Overlay with transparent density plot
      
      
      p <- ggplotly(gg)
      p
    }
  })
  
  output$plot2 <- renderPlot({
    #data <- gDesc2()
    if (!is.null(m)) {
      #histogram(m[,1])
      serv <- gFileData()
      CorMat <- cor_auto(m[,serv])
      # 
      # # Compute graph with tuning = 0 (BIC):
      BICgraph <- EBICglasso(CorMat, nrow(m), 0)
      # # Compute graph with tuning = 0.5 (EBIC)
      EBICgraph <- EBICglasso(CorMat, nrow(m), 0.5)
      # 
      #gg <- autoplot(cl3, frame = TRUE, frame.type = 'norm')
      c<-input$control
      qgraph(BICgraph, layout = "spring", cut = c, title = "Gráfica de Correlación", details = TRUE, mode("Direct"))
      #p
    }
  })
  
  output$mytable = renderDataTable({
    data <- dClust()
    if (!is.null(data)) {
      # inFile <- input$file1
      #
      # Plot the result
      #plot( x=Time, y=F0, pch=16, xlab="Time (s)", ylab="F0 (Hz)", las=1, main=CurrentFilename, cex=0.0005)
      prep<-na.omit(data$F0$`2`)
      summary(prep)
    }
  })
  
  output$table12Plot <- renderPlotly({
    input$goButton
    data <- dClust()
    if (!is.null(data)) {
      # inFile <- input$file1
      #
      # Plot the result
      #plot( x=Time, y=F0, pch=16, xlab="Time (s)", ylab="F0 (Hz)", las=1, main=CurrentFilename, cex=0.0005)
      gg <- tableGrob(iris[1:4, 1:3])
      # g2 <- tableGrob(iris[1:4, 1:3])
      # gg<- grid.arrange(g1, g2, ncol=1, top="Participantes")
      
      #   gg<-qplot(x=Time, y=F0, data=PitchTierData, geom = "line")
      # Convert the ggplot to a plotly
      p <- ggplotly(gg)
      p
    }
  })
  output$hisF01Plot <- renderPlotly({
    data <- dClust()
    if (!is.null(data)) {
      # Extract first participant F0
      Entonación<-na.omit(data$F0$`1`)
      # Plot the result
      gg <- qplot(Entonación, geom = "histogram", fill=I("tomato2")) +
            geom_vline(aes(xintercept=mean(Entonación, na.rm=T)),   # Ignore NA values for mean
            color="red", linetype="dashed", size=1)
      
      # Convert the ggplot to a plotly
      p <- ggplotly(gg)
      p
    }
  })
  output$hisF02Plot <- renderPlotly({
    data <- dClust()
    if (!is.null(data)) {
      # Extract first participant F0
      Entonación<-na.omit(data$F0$`2`)
      # Plot the result
      gg <- qplot(Entonación, geom = "histogram", fill=I("steelblue2") ) +
            geom_vline(aes(xintercept=mean(Entonación, na.rm=T)),   # Ignore NA values for mean
            color="red", linetype="dashed", size=1)
      
      # Convert the ggplot to a plotly
      p <- ggplotly(gg)
      p
    }
  })
  output$hisF01Plot2 <- renderPlotly({
    data <- dClust2()
    if (!is.null(data)) {
      # Extract first participant F0
      Entonación<-na.omit(data$F0$`1`)
      # Plot the result
      gg <- qplot(Entonación, geom = "histogram", fill=I("tomato2")) +
            geom_vline(aes(xintercept=mean(Entonación, na.rm=T)),   # Ignore NA values for mean
            color="red", linetype="dashed", size=1)
      
      # Convert the ggplot to a plotly
      p <- ggplotly(gg)
      p
    }
  })
  output$hisF02Plot2 <- renderPlotly({
    data <- dClust2()
    if (!is.null(data)) {
      # Extract first participant F0
      Entonación<-na.omit(data$F0$`2`)
      # Plot the result
      gg <- qplot(Entonación, geom = "histogram", fill=I("steelblue2") ) +
            geom_vline(aes(xintercept=mean(Entonación, na.rm=T)),   # Ignore NA values for mean
            color="red", linetype="dashed", size=1)
      
      # Convert the ggplot to a plotly
      p <- ggplotly(gg)
      p
    }
  })  
  # output$hisF01Plot2 <- renderPlotly({
  #   data <- dClust2()
  #   if (!is.null(data)) {
  #     # Extract first participant F0
  #     Entonación<-na.omit(data$F0$`1`)      
  #     # Plot the result
  #     gg <- qplot(Entonación, geom = "histogram",  fill=I("tomato2")) 
  #     
  #     # Convert the ggplot to a plotly
  #     p <- ggplotly(gg)
  #     p
  #   }
  # })
  # output$hisF02Plot2 <- renderPlotly({
  #   data <- dClust2()
  #   if (!is.null(data)) {
  #     # Extract first participant F0
  #     Entonación<-na.omit(data$F0$`2`)
  #     # Plot the result
  #     gg <- qplot(Entonación, geom = "histogram",  fill=I("steelblue2"))
  #     
  #     # Convert the ggplot to a plotly
  #     p <- ggplotly(gg)
  #     p
  #   }
  # })
  output$hisInt1Plot <- renderPlotly({
    data <- dClust()
    if (!is.null(data)) {
      # Extract first participant F0
      Intensidad<-na.omit(data$Intensity$`1`)
      # Plot the result
      gg <- qplot(Intensidad, geom = "histogram", fill=I("tomato2"))
      
      # Convert the ggplot to a plotly
      p <- ggplotly(gg)
      p
    }
  })
  output$hisInt2Plot <- renderPlotly({
    data <- dClust()
    if (!is.null(data)) {
      # Extract first participant F0
      Intensidad<-na.omit(data$Intensity$`2`)
      # Plot the result
      gg <- qplot(Intensidad, geom = "histogram", fill=I("steelblue2"))
      
      # Convert the ggplot to a plotly
      p <- ggplotly(gg)
      p
    }
  })
  output$hisInt1Plot2 <- renderPlotly({
    data <- dClust2()
    if (!is.null(data)) {
      # Extract first participant F0
      Intensidad<-na.omit(data$Intensity$`1`)      
      # Plot the result
      gg <- qplot(Intensidad, geom = "histogram", fill=I("tomato2"))
      
      # Convert the ggplot to a plotly
      p <- ggplotly(gg)
      p
    }
  })
   
  output$mytable = renderDataTable({
   tabla
  })
  
  output$tabla1 <- renderPlot({
    #data <- dClust2()
    
    r<-t[1:12,]
    if (!is.null(r)) {
      grid.table(t(r))
    }

  })   
  
  output$tabla2 <- renderPlot({
    #data <- dClust2()
    
    r<-t[13:24,]
    if (!is.null(r)) {
      grid.table(t(r))
    }
  })  
  
  output$tabla3 <- renderPlot({
    #data <- dClust2()
    
    r<-t[25:36,]
    if (!is.null(r)) {
      grid.table(t(r))
    }
  })  
    
  output$tabla4 <- renderPlot({
    #data <- dClust2()
    
    r<-t[37:48,]
    if (!is.null(r)) {
      grid.table(t(r))
    }
  })  
  
  output$tabla5 <- renderPlot({
    #data <- dClust2()
    
    r<-t[49:60,]
    if (!is.null(r)) {
      grid.table(t(r))
    }
  })  
 
  output$tabla6 <- renderPlot({
    #data <- dClust2()
    
    r<-t[61:63,]
    if (!is.null(r)) {
      grid.table(t(r))
    }
  })  
  
  
  output$his2Plot <- renderPlotly({
    input$goButton
    data <- dClust()
    if (!is.null(data)) {
      # inFile <- input$file1
      #
      # Plot the result
      #plot( x=Time, y=F0, pch=16, xlab="Time (s)", ylab="F0 (Hz)", las=1, main=CurrentFilename, cex=0.0005)
      
      
      gg <- qplot(na.exclude(data$F0$`2`), geom = "histogram")
      g1 <- tableGrob(summary(data$F0$`2`))
      g <- grid.arrange(g1, gg, ncol = 1, top = "Participante 1")
      
      # Convert the ggplot to a plotly
      p <- ggplotly(gg)
      p
    }
  })
  
  
  output$force <- renderForceNetwork({
    inFile <- input$inFile
    if (!is.null(inFile)) {
      # We get audio intervals from audio data
      inter <- gInter()
      prefix<-substr(inFile, 1, 5)
      edges <- c(paste(prefix, 1))
      for (i in inter$SilIntervals[, 1]) {
        edges <-
          c(edges, paste(prefix, round(i * 100)), paste(prefix, round(i * 100)))
      }
      edges <- edges[-length(edges)]
      dataGraph <-
        graph(edges,
              n = length(inter$SilIntervals),
              directed = TRUE)
      # Convert to object suitable for networkD3
      convers_d3 <- igraph_to_networkD3(dataGraph)
      convers_d3$links$weight <- inter$SilIntervals[, 2]
      cl3 <- pam(gDesc(), 2)$clustering
      convers_d3$nodes$group <- c(0, cl3, 0)
      gData = gStat()
      convers_d3$nodes$weight <- c(0, gData$Duration, 0)
      convers_d3$pitchr <- c(0, gData$F0Range, 0)
      convers_d3$intensity <- c(0, gData$Intensity, 0)
      
      forceNetwork(
        Links = convers_d3$links,
        Nodes = convers_d3$nodes,
        Source = "source",
        Target = "target",
        Value = "weight",
        NodeID = "name",
        Nodesize = "weight",
        radiusCalculation = JS(" Math.sqrt(d.nodesize/10)"),
        Group = "group",
        charge = -50,
        bounded = TRUE,
        zoom = TRUE,
        linkColour = c("#0F0"),
        linkDistance = JS("function(d){ return Math.sqrt(d.value); }"),
        linkWidth = JS("function(d){return d.value * 10}")
      )
    } else { return(NULL)}
  })  
  output$force2 <- renderForceNetwork({
    inFile <- input$inFile2
    if (!is.null(inFile)) {
    # We get audio intervals from audio data
    inter <- gInter2()
    prefix<-substr(inFile, 1, 5)
    edges <- c(paste(prefix, 1))
    for (i in inter$SilIntervals[, 1]) {
      edges <-
        c(edges, paste(prefix, round(i * 100)), paste(prefix, round(i * 100)))
    }
    edges <- edges[-length(edges)]
    dataGraph <-
      graph(edges,
            n = length(inter$SilIntervals),
            directed = TRUE)
    # Convert to object suitable for networkD3
    convers_d3 <- igraph_to_networkD3(dataGraph)
    convers_d3$links$weight <- inter$SilIntervals[, 2]
    cl3 <- pam(gDesc2(), 2)$clustering
    convers_d3$nodes$group <- c(0, cl3, 0)
    gData = gStat2()
    convers_d3$nodes$weight <- c(0, gData$Duration, 0)
    convers_d3$pitchr <- c(0, gData$F0Range, 0)
    convers_d3$intensity <- c(0, gData$Intensity, 0)
    
    forceNetwork(
      Links = convers_d3$links,
      Nodes = convers_d3$nodes,
      Source = "source",
      Target = "target",
      Value = "weight",
      NodeID = "name",
      Nodesize = "weight",
      radiusCalculation = JS(" Math.sqrt(d.nodesize/10)"),
      Group = "group",
      charge = -50,
      bounded = TRUE,
      zoom = TRUE,
      linkColour = c("#0F0"),##, "F00"),
      linkDistance = JS("function(d){ return Math.sqrt(d.value); }"),
      linkWidth = JS("function(d){return d.value * 10}")
    )
    } else { return(NULL)}
  })
  
  output$sigPlot <- renderPlotly({
    inFile <- input$inFile
    if (inFile != "") {
      withProgress(message = 'Leyendo archivo', value = 0, {
        #on.exit(progress$close())
        # Number of times we'll go through the loop
        n <- 5
        if (!exists("amp")) {
          amp <- load.wave(FullPath(inFile))
        }
        # Increment the progress bar, and update the detail text.
        incProgress(1 / n, detail = paste(1 , "de", n))
        size <- length(amp)
        duration <- length(amp) / amp$rate
        sampleSize<-10000
        sam <-
          sample(
            1:size,
            size = sampleSize,
            replace = FALSE,
            prob = rep(1 / size, size)
          )
        # Increment the progress bar, and update the detail text.
        incProgress(1 / n, detail = paste(2 , "de", n))
        
        x <-
          data.frame("amp" = as.numeric(amp), "time" = seq(0, (length(amp) - 1)))
        y <- x[sam, ]
        # Increment the progress bar, and update the detail text.
        incProgress(1 / n, detail = paste(3 , "de", n))
        gg <- qplot(time, amp, data = y, geom = "line")
        # Convert the ggplot to a plotly
        p <- ggplotly(gg)
        # Increment the progress bar, and update the detail text.
        incProgress(1 / n, detail = paste(3 , "de", n))
        p
        
      })
    } else {
      return(NULL)
    }
  })
  
  output$sigPlot2 <- renderPlotly({
    inFile <- input$inFile2
    if (inFile != "") {
      withProgress(message = 'Leyendo archivo', value = 0, {
        # Number of times we'll go through the loop
        n <- 5
        if (!exists("amp")) {
          amp <- load.wave(FullPath(inFile))
        }
        # Increment the progress bar, and update the detail text.
        incProgress(1 / n, detail = paste(1 , "de", n))
        size <- length(amp)
        duration <- length(amp) / amp$rate
        sam <-
          sample(
            1:size,
            size = round(size / 1000),
            replace = FALSE,
            prob = rep(1 / size, size)
          )
        # Increment the progress bar, and update the detail text.
        incProgress(1 / n, detail = paste(2 , "de", n))
        
        x <-
          data.frame("amp" = as.numeric(amp), "time" = seq(0, (length(amp) - 1)))
        y <- x[sam, ]
        # Increment the progress bar, and update the detail text.
        incProgress(1 / n, detail = paste(3 , "de", n))
        gg <- qplot(time, amp, data = y, geom = "line")
        # Convert the ggplot to a plotly
        p <- ggplotly(gg)
        # Increment the progress bar, and update the detail text.
        incProgress(1 / n, detail = paste(4 , "de", n))
        p
        
      })
    } else {
      return(NULL)
    }
  })
})