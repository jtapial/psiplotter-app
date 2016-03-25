library(shiny)
library(psiplot)
library(reshape2)


shinyServer(function(input, output, session) {
  
  cfg_loaded <<- FALSE
  
  Data <- reactive({
    if (is.null(input$file)) {
      data <- psi
    }  else {
#       write("Reading data", stderr())
      data <- read.delim(input$file$datapath, stringsAsFactor=FALSE)
    }
    return(data)
  })
  
  PsiConfig <- reactive({
    if (is.null(input$configfile)) {
      cfg <- psiplot::config
    } else {      
      if (input$noconfig) {
        cfg <- NULL
      } else {
        write("Reading config", stderr())
        cfg <- read.delim(input$configfile$datapath, stringsAsFactor=FALSE)
        cfg_loaded <<- TRUE
        print(cfg_loaded)
      }
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
      updateRadioButtons(session, "color", selected = "black")
    } else if (!(is.null(input$file) || is.null(input$configfile))) {
      print(paste("observe:", cfg_loaded))
      if (!cfg_loaded) {
#         browser()
        updateCheckboxInput(session, "noconfig", value = FALSE)
        updateRadioButtons(session, "color", selected = "config")
      }
    }
    
    # Update events upon new data
    updateSelectInput(session, "event", 
                      choices = paste(Data()$GENE, Data()$EVENT, sep = ", "))
    
    #  Update samples list
    if (input$noconfig) {
      smp <- get_psi_samples(Data())
      updateSelectInput(session, "samples", choices = smp, selected = smp)
      updateRadioButtons(session, "color", selected = "black")
    } else {
      smp <- get_psi_samples(Data())
      ix <- match(PsiConfig()$SampleName, smp)
      ix <- ix[!is.na(ix)]
      updateSelectInput(session, "samples", choices = smp[ix], selected = smp[ix])
      updateRadioButtons(session, "color", selected = "config")
    }
  })
  
  UserConfig <- reactive({
    cfg <- PsiConfig()
    validate(need(length(input$samples) > 0, "No samples selected"))
    
    # if samples do not match config, update config with new order
    if (input$noconfig == FALSE) {
      cfg <- cfg[which(cfg$SampleName %in% input$samples),]  
      if (!identical(cfg[order(cfg$Order), "SampleName"], input$samples)) {
        cfg <- cfg[match(input$samples, cfg$SampleName),]
        cfg$Order <- 1:length(input$samples)
      }
    } else {
      cfg <- data.frame(
        Order = 1:length(input$samples),
        SampleName = input$samples,
        GroupName = rep(NA, length(input$samples)),
        RColorCode = rep("black", length(input$samples))
        )      
    }
    return(cfg)  
  })
  
  output$chart <- renderPlotly({
    if (input$color == "black") {
      col <- rep("black", length(input$samples))
    } else {
      col <- NULL  
    }
    
s
    # generate bins based on input$bins from ui.R
    gp <- plot_event(Event(), config = UserConfig(), 
               errorbar = input$errorbars,
#                col = col,
               gridlines = input$gridlines,
               groupmean = input$groupmean,
               pch = as.numeric(input$pch),
               ylim = input$ylim,
               cex.pch = input$cex.pch,
               cex.xaxis = input$cex.xaxis,
               cex.yaxis = input$cex.yaxis,
               cex.main = input$cex.main)

    p <- ggplotly(gp)
    p
  
    # if (is.null(input$file)) {
    #   watermark <- "Sample data\nUpload input data to remove this watermark"
    #   mtext(watermark, side = 1, line = -1.3, adj = 1, col = rgb(1, 0, 0, .4), cex = 1.2)
    # }
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
  }, options = list(scrollX = TRUE))

  output$configdata <- renderDataTable({
    PsiConfig()
  }, options = list(scrollX = TRUE))

})
