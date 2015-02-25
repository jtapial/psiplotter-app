library(shiny)
library(psiplot)

shinyServer(function(input, output, session) {

  Data <- reactive({
    if (is.null(input$file)) {
      data <- psi
    }  else {
      data <- read.table(input$file$datapath, header=TRUE, sep="\t", 
                         stringsAsFactor=FALSE)
    }
    return(data)
  })
  
  Config <- reactive({
    if (is.null(input$configfile)) {
      cfg <- config
    } else {
      cfg <- read.table(input$configfile$datapath, header=TRUE, sep="\t", 
                        stringsAsFactor=FALSE,
                        comment.char="")
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
    if (!is.null(input$file) && is.null(input$configfile)) {
      updateCheckboxInput(session, "noconfig", value = TRUE)
    } else if (!(is.null(input$file) || is.null(input$configfile))) {
      updateCheckboxInput(session, "noconfig", value = FALSE)
    }
    
    updateSelectInput(session, "event", 
                      choices = paste(Data()$GENE, Data()$EVENT, sep = ", "))
  })
  
  output$chart <- renderPlot({
    
    if (input$color == "black") {
      col <- rep("black", (ncol(Data()) - 6)/2)
    } else {
      col <- NULL  
    }
    
    event <- Event()
    
    # generate bins based on input$bins from ui.R
    plot_event(event, config = Config(), 
               errorbar = input$errorbars,
               col = col,
               gridlines = input$gridlines,
               groupmean = input$groupmean,
               lines = input$lines,
               pch = as.numeric(input$pch),
               ylim = input$ylim,
               cex.pch = input$cex.pch,
               cex.xaxis = 1,
               cex.yaxis = 1,
               cex.main = 1.3)

  }, width = 900, height = 600)

  output$inputdata <- renderDataTable({
    Data()
  })

  output$configdata <- renderDataTable({
    Config()
  })
  
  output$usage <- renderText({
    print("Nothing here yet")
  })

})
