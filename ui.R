library(shiny)
library(psiplot)

version <- "0.0.1 alpha"
  
shinyUI(fluidPage(

  # Application title
  titlePanel("VAST-TOOLS PSI Plotter"),
  
  sidebarLayout(
    sidebarPanel(
      wellPanel(
        helpText(HTML("<b>UPLOAD DATA</b>")),
        fileInput(
          "file", "To begin, upload your VAST-TOOLS input file.", 
          multiple=FALSE,
          accept = c('text/plain', 'text/tab-separated-values')
        ),
        fileInput(
          "configfile", "Also, upload an optional config file", 
          multiple=FALSE,
          accept = c('text/plain', 'text/tab-separated-values')
        ),
        checkboxInput("noconfig", "Do not use config file")
      ),
      
      conditionalPanel(
        'input.dataset == "Plot"',
        wellPanel(
          helpText(HTML("<b>PLOT SETTINGS</b>")),
                  
          checkboxInput("groupmean", "Show group-specific averages"),
          
          checkboxInput("gridlines", "Show grid lines", value = TRUE),
          
          checkboxInput("errorbars", "Show error bars", value = TRUE),
          
          checkboxInput("lines", "Draw line connecting data points"),
          
          selectInput(
            "pch", 
            HTML(paste("Plotting Symbol (see", '<a href="http://www.statmethods.net/advgraphs/parameters.html" target="_blank">Graphical Parameters</a> for help)')),  
            0:25, 
            selected = 20),
          
          radioButtons("color", "Set color",
                       c("Config Colors" = "config",
                         "Black" = "black")),
          
          sliderInput("ylim", "Set y-axis range", min = 0, max = 100,
                      value = c(0, 100), step = 1),
          
          sliderInput("cex.pch", "Data point size (i.e. cex.pch)", 
                      min = 0.4, max = 2.5, value = 1, step = 0.1)
          
#           actionButton("go", "Update")
        )
      ),
      
      wellPanel(
        helpText(HTML("<b>ABOUT</b>")),
        HTML(paste('Source Code:', '<a href="https://github.com/kcha/psiplotter-app" target="_blank">GitHub</a>')),
        HTML('<br/>'),
        HTML(paste('Version:', version))
      ),
            
      wellPanel(
        helpText(HTML("<b>RELATED LINKS</b>")),
        HTML('<a href="https://github.com/vastgroup/vast-tools" target="_blank">VAST-TOOLS</a>'),
        HTML('<br/>'),
        HTML('<a href="https://github.com/kcha/psiplot" target="_blank">psiplot</a>')
      ),
      
      wellPanel(
        helpText(HTML("<b>CONTACT</b>")),
        HTML('Kevin Ha'),
        HTML('<br/>'),
        HTML('<a href="mailto:k.ha@mail.utoronto.ca" target="_blank">k.ha@mail.utoronto.ca</a>')
      )
    ),
    mainPanel(
      tabsetPanel(
        id = 'dataset',
        tabPanel('Plot',
                 selectInput("event", "Select event",  
                             paste(psi$GENE, psi$EVENT, sep = ", "), 
                             width = "100%"),
                 plotOutput('chart')),
        tabPanel('Input Data', dataTableOutput('inputdata')),
        tabPanel('Config', dataTableOutput('configdata')),
        tabPanel('Usage', verbatimTextOutput('usage'))
      )
    )
  )
))
