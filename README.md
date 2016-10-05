# psiplotter-app

A Shiny app for visualizing percent spliced-in (PSI) values of
alternatively-spliced exons that were computed by
[VAST-TOOLS](https://github.com/vastgroup/vast-tools).

![screenshot](https://camo.githubusercontent.com/66dcfa0aa9952649073fd5ad37255527b1478090/687474703a2f2f696e646976696475616c2e75746f726f6e746f2e63612f68616b6576696e2f696d616765732f707369706c6f747465725f707265766965772e706e67 "Screenshot")

**New** A v0.3.0 beta version that uses [`plotly`](https://plot.ly/r/) for
creating interactive plots is available under the [`plotly` branch](https://github.com/kcha/psiplotter-app/tree/plotly) or by running:
```r
install.packages(c("devtools", "shiny", "plotly"))
shiny::runGitHub('psiplotter-app', 'kcha', ref = "plotly")
```

## Usage

To run on your local machine, execute the following code in your R console to 
install the required packages:

```r
install.packages(c("devtools", "shiny"))
devtools::install_github('kcha/psiplot')
```

Then, to start the application, execute the following command:

```r
shiny::runGitHub('psiplotter-app', 'kcha')
```

Alternatively, you can try out the app here:
http://kcha.shinyapps.io/psiplotter-app

## Related Projects
- [VAST-TOOLS](https://github.com/vastgroup/vast-tools)
- [psiplot](https://github.com/kcha/psiplot)
