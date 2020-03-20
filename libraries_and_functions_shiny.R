library(shiny)
library(shinythemes)
library(reticulate)
library(knitr)
library(kableExtra)
library(ggplot2)
library(plotly)

ReadCsvParam <- function(inFile)
{
  if(is.null(inFile))
    return(NULL)
  else
    return(read_csv(inFile$datapath))
}

UpdateProgress <- function(renderVal, renderByShiny)
{
  if(renderByShiny & renderVal < 25)
  {
    shiny::setProgress(renderVal/25)
    renderVal = renderVal + 1
  }
  return(renderVal)
}
