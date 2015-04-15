library(shiny)
library(psiplot)
library(reshape2)

shinyServer(function(input, output, session) {
  
  Data <- reactive({
    if (is.null(input$file)) {
      data <- psi
    }  else {
      data <- read.delim(input$file$datapath, stringsAsFactor=FALSE)
    }
    return(data)
  })
  
  Config <- reactive({
    if (is.null(input$configfile)) {
      cfg <- config
    } else {
      cfg <- read.delim(input$configfile$datapath, stringsAsFactor=FALSE)
                        
    }
    
    if (input$noconfig) {
      cfg <- NULL
    }
    return(cfg)
  })
  
  Event <- reactive({
    if (is.null(input$event)) {
      return(NULL)
    }
    ev <- strsplit(input$event, split = ", ")[[1]] 
    d <- Data()[which(Data()$EVENT == ev[2]),]
    validate(need(nrow(d) == 1, "Can't find event"))
    return(d)
  })
  
  observe({
    # Update noconfig checkbox
    if (!is.null(input$file) && is.null(input$configfile)) {
      updateCheckboxInput(session, "noconfig", value = TRUE)
    } else if (!(is.null(input$file) || is.null(input$configfile))) {
      updateCheckboxInput(session, "noconfig", value = FALSE)
    }
    
    # Update events upon new data
    updateSelectInput(session, "event", 
                      choices = paste(Data()$GENE, Data()$EVENT, sep = ", "))
    
    #  Update samples list
    if (input$noconfig) {
      smp <- get_psi_samples(Data())
      updateSelectInput(session, "samples", choices = smp, selected = smp)
    } else {
      smp <- get_psi_samples(Data())
      ix <- match(Config()$SampleName, smp)
      ix <- ix[!is.na(ix)]
      updateSelectInput(session, "samples", choices = smp[ix], selected = smp[ix])
    }
  })
  
  UserConfig <- reactive({
    cfg <- Config()
    
    # if samples do not match config, update config with new order
    if (input$noconfig == FALSE) {
      validate(need(length(input$samples) > 0, "No samples selected"))
      cfg <- cfg[which(cfg$SampleName %in% input$samples),]  
      if (!identical(cfg[order(cfg$Order), "SampleName"], input$samples)) {
        cfg <- cfg[match(input$samples, cfg$SampleName),]
        cfg$Order <- 1:length(input$samples)
      }
    }
    
    return(cfg)  
  })
  
  output$chart <- renderPlot({
    if (input$color == "black") {
      col <- rep("black", (ncol(Data()) - 6)/2)
    } else {
      col <- NULL  
    }
    
    validate(need(length(input$samples) >= 2, "Need two or more samples"))
    
    # generate bins based on input$bins from ui.R
    gp <- plot_event(Event(), config = UserConfig(), 
               errorbar = input$errorbars,
               col = col,
               gridlines = input$gridlines,
               groupmean = input$groupmean,
               pch = as.numeric(input$pch),
               ylim = input$ylim,
               cex.pch = input$cex.pch,
               cex.xaxis = input$cex.xaxis,
               cex.yaxis = input$cex.yaxis,
               cex.main = input$cex.main)

  
    if (is.null(input$file)) {
      watermark <- "Sample data\nUpload input data to remove this watermark"
      mtext(watermark, side = 1, line = -1.3, adj = 1, col = rgb(1, 0, 0, .4), cex = 1.2)
    }
  })
  
  output$selectedevent <- renderTable({
    # Show table of PSI and Q for selected event
    if (length(input$samples) < 2) {
      return(NULL)
    }
    ev <- Event()
    smp <- get_psi_samples(ev)
    q <- paste(smp, "Q", sep = ".")
    psi <- melt(ev[, smp], 
                   variable.name = "Sample", value.name = "PSI")
    qual <- melt(ev[, q], measure.vars = q,
                        variable.name = "Sample", value.name = "Q")
    df <- cbind(psi, Q = qual[,2])
    df[match(input$samples, df$Sample),]
  })

  output$inputdata <- renderDataTable({
    Data()
  })

  output$configdata <- renderDataTable({
    Config()
  })

})
