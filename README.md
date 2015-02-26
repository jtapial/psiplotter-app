# psiplotter-app

A Shiny app for visualizing percent spliced-in (PSI) values of
alternatively-spliced exons that were computed by
[VAST-TOOLS](https://github.com/vastgroup/vast-tools).

## Usage

To run on your local machine, the following R packages must be installed:

```r
install.packages(c("devtools", "shiny"))
devtools::install_github('kcha/psiplot')
```

Then, to start the application, run the following command:

```r
shiny::runGitHub('psiplotter-app', 'kcha')
```

Alternatively, you can try out the app here:
http://kcha.shinyapps.io/psiplotter-app

## Related Projects
- [VAST-TOOLS](https://github.com/vastgroup/vast-tools)
- [psiplot](https://github.com/kcha/psiplot)
