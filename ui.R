library(shiny)
library(psiplot)
require(markdown)

version <- "0.2.0"

shinyUI(fluidPage(

  # Application title
  titlePanel(paste0("VAST-TOOLS PSI Plotter (version ", version, ")")),
  
  sidebarLayout(
    sidebarPanel(
      wellPanel(
        helpText(HTML("<b>UPLOAD DATA</b>")),
        fileInput(
          "file", "To begin, upload your VAST-TOOLS input file.", 
          multiple=FALSE,
          accept = c('text/plain', 'text/tab-separated-values', '.tab')
        ),
        fileInput(
          "configfile", "[Optional] Upload a config file", 
          multiple=FALSE,
          accept = c('text/plain','text/tab-separated-values', '.tab', '.config')
        ),
        checkboxInput("noconfig", "Do not use config file"),
        helpText('Check this box if you do not want to use a config file')
      ),
      
      conditionalPanel(
        'input.dataset == "Plot"',
        wellPanel(
          helpText(HTML("<b>PLOT SETTINGS</b>")),
                  
          checkboxInput("groupmean", "Show group-specific averages (requires config)"),
          
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
                         "Black" = "black"), inline = TRUE),
                  
          sliderInput("cex.pch", "Data point size (i.e. cex.pch)", 
                      min = 0, max = 16, value = 3, step = 0.5),
          
          sliderInput("cex.main", "Title font size (choose 0 to remove)", 
                      min = 0, max = 30, value = 14, step = 1),
          
          sliderInput("cex.xaxis", "X-axis font size",
                      min = 1, max = 30, value = 12, step = 1),
          
          sliderInput("cex.yaxis", "Y-axis font size",
                      min = 1, max = 30, value = 12, step = 1),
          
          sliderInput("ylim", "Set y-axis range", min = 0, max = 100,
                      value = c(0, 100), step = 1)
          
#           br(),
#           HTML("Note on selecting samples:"),
#           HTML('<ul>'),
#           HTML('<li>The samples are restricted by config.</li>'),
#           HTML('<li>The order of samples can also be modified and will override the order defined by config.</li>'),
#           HTML('</ul>')
#           actionButton("go", "Update")
        )
      ),
      
      wellPanel(
        helpText(HTML("<b>ABOUT</b>")),
        HTML(paste('Source Code:', '<a href="https://github.com/kcha/psiplotter-app" target="_blank">GitHub</a>')),
        HTML('<br/>'),
        HTML(paste('Version:', version)),
        HTML('<br/>'),
        HTML(paste('Issues/Questions/Feedback: Report', 
                   '<a href="https://github.com/kcha/psiplotter-app/issues" target="_blank">here</a>'))
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
                 selectizeInput(
                   "event", "Select event from list or type to search:",  
                   paste(psi$GENE, psi$EVENT, sep = ", "), 
                   width = "100%",
                   options = list(placeholder = 'Select/Type GENE or EVENT')),
                 selectInput(
                   "samples", 
                   "Select samples to plot:",
                   get_psi_samples(psi),
                   selected = get_psi_samples(psi),
                   width = "100%",
                   multiple = TRUE),
                 plotOutput('chart', height = "600px", width = "95%"),
                 tableOutput('selectedevent'), align = "center"
         ),
        tabPanel('Input Data', dataTableOutput('inputdata')),
        tabPanel('Config', dataTableOutput('configdata')),
        tabPanel('Usage', includeMarkdown('docs/usage.md')),
        tabPanel('News', includeMarkdown('docs/news.md')),
        type = "pills"
      )
    )
  )
))
