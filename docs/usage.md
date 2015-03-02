`psiplotter-app` is a Shiny app for visualizing percent spliced-in (PSI) values of
alternatively-spliced exons that were computed by
[VAST-TOOLS](https://github.com/vastgroup/vast-tools).

**This app is still under heavy development and subject to ongoing changes. Some 
features may be buggy and not work as described. Please report 
all issues and feedback using the GitHub 
[issue tracker](https://github.com/kcha/psiplotter-app/issues).**

## Tabs

The following is a description of the tabs available in this Shiny app:

- *Plot*: where PSI plots are viewed
- *Input Data*: browse your input data
- *Config*: browse your configuration file, if applicable
- *Usage*: this page
- *Known Issues*: a list of known issues with the app

## Upload data

**This document assumes that you have already run your analysis using
[VAST-TOOLS](https://github.com/vastgroup/vast-tools).**

Upload your input file from VAST-TOOLS containing the PSI values.

By default, a sample dataset has been pre-loaded as a demo.

## Upload configuration file (optional)

See the [documentation](https://github.com/kcha/psiplot#the-config-file-way) for
`psiplot` on how to create a config file.

By default, a sample config file has been pre-loaded as a demo.

To disable or enable the use of a config file, check or uncheck the box next to
*Do not use config file*.

## Selecting events

PSI plots are displayed under the *Plot* tab. To select an event to plot, use
the pull down menu under *Select event from list or type to search*. You can also
search for a particular event by simply typing into the menu bar. This is useful
if you have a large number of events loaded.

## Selecting samples

To customize which samples are plotted, you can edit the list of samples under
*Select samples to plot*. By default, all samples are shown. If a config file is
used, then the samples and ordering defined in the config are loaded.

The ordering of samples can be overridden by manually changing the order in the
input field.

Note, whenever the *Do not use config file* checkbox is checked/unchecked, the list of samples
will be reset and you will lose your any manual changes.

## Additional plot customizations

In addition, to using the configuration file. You can adjust the plot settings 
using the control panel on the left sidebar.

## Known issues
- ~~Plots may get cut off and introduce a vertical scroll bar to see entire image~~ *Fixed in 0.1.4*
