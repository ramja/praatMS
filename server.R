


# We load libraries we gonna use
#
library("audio")
library("PraatR")
library("cluster")
library("igraph")
library('ggfortify')
library('barcode')
library("gridExtra")
library("datasets")
## Local Base Directory. Change to the one you'll use to store your audios
PitchDirectory = "C:/Audio/pitch/"

## Utility and functional routines
source('src/util.R', local = TRUE)
source('src/preProcFunctions.R', local = TRUE)

## This functions adds local directory to file to make a full path
FullPath = function(FileName) {
  return(paste(PitchDirectory, FileName, sep = ""))
}

# We stablish our local directory as work directory
setwd(PitchDirectory)

# List of wav files to be analized
CurrentFileNames = c(list.files(pattern = "wav$"))




shinyServer(function(input, output) {
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
  
  gFileData <- reactive({
    inFile <- input$inFile
    if (!is.null(input$inFile)) {
      withProgress(message = 'Analizando Conversación', value = 0, {
        # on.exit(progress$close())
        
        # We get prosodic data from file using PraatR
        getProsodicData(inFile)
      })
    }
    
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
  
  output$barPlot <- renderPlotly({
    inter <- gInter()
    if (!is.null(inter)) {
      ggplotGrob(barcode(inter$SilIntervals[, 1]))
    }
  })
  
  output$custPlot <- renderPlotly({
    data <- gDesc()
    if (!is.null(data)) {
      cl3 <- pam(data, 2)
      
      gg <- autoplot(cl3, frame = TRUE, frame.type = 'norm')
      p <- ggplotly(gg)
      p
    }
  })
  
  output$custPlot2 <- renderPlotly({
    data <- gDesc2()
    if (!is.null(data)) {
      cl3 <- pam(data, 2)
      
      gg <- autoplot(cl3, frame = TRUE, frame.type = 'norm')
      p <- ggplotly(gg)
      p
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
      F0<-na.omit(data$F0$`1`)
      # Plot the result
      gg <- qplot(F0, geom = "histogram", fill=I("tomato2"))
      
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
      gg <- qplot(Entonación, geom = "histogram", fill=I("steelblue2") )
      
      # Convert the ggplot to a plotly
      p <- ggplotly(gg)
      p
    }
  })
  output$hisF01Plot2 <- renderPlotly({
    data <- dClust2()
    if (!is.null(data)) {
      # Extract first participant F0
      F0<-na.omit(data$F0$`1`)      
      # Plot the result
      gg <- qplot(F0, geom = "histogram",  fill=I("tomato2")) 
      
      # Convert the ggplot to a plotly
      p <- ggplotly(gg)
      p
    }
  })
  output$hisF02Plot2 <- renderPlotly({
    data <- dClust2()
    if (!is.null(data)) {
      # Extract first participant F0
      F0<-na.omit(data$F0$`2`)
      # Plot the result
      gg <- qplot(F0, geom = "histogram",  fill=I("steelblue2"))
      
      # Convert the ggplot to a plotly
      p <- ggplotly(gg)
      p
    }
  })
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
  output$hisInt2Plot2 <- renderPlotly({
    data <- dClust2()
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
      convers_d3$pitchr <- c(0, gStat$F0Range, 0)
      convers_d3$intensity <- c(0, gStat$Intensity, 0)
      
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
    convers_d3$pitchr <- c(0, gStat$F0Range, 0)
    convers_d3$intensity <- c(0, gStat$Intensity, 0)
    
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