library(shiny)
library(shinythemes)
library(reticulate)

ReadCsvParam <- function(inFile)
{
  if(is.null(inFile))
    return(NULL)
  else
    return(read.csv(inFile$datapath))
}

readCSVparam <- function(inFile)
{
  if(is.null(inFile))
    return(NULL)
  else
    return(read.csv(inFile$datapath))
}