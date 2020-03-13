# load all necessar R libraries
library(shiny)
library(shinythemes)
library(reticulate)
library(stringr)
library(tibble)
library(dplyr)

# Non data-cleaning functions
# Functions to read in .csvs in shiny application
ReadCsvParam <- function(inFile)
{
  if(is.null(inFile))
    return(NULL)
  else
    return(read.csv(inFile$datapath))
}

# Function to updat shiny progress bar in .rmd
UpdateProgress <- function(renderVal, renderByShiny)
{
  if(renderByShiny & renderVal < 25)
  {
    shiny::setProgress(renderVal/25)
    renderVal = renderVal + 1
  }
}

