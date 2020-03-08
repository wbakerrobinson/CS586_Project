library(shiny)
library(readxl)

# Define UI for application that draws a histogram
ui <- fluidPage(
    titlePanel("Portland State CS Capstone Survey Analysis"),
    fileInput("availSurv", label="Student Availability Survey", multiple = FALSE,
              accept = c(
                  "text/csv",
                  "text/comma-separated-values,text/plain",
                  ".csv")),
    fileInput("projSurv", label="Project Survey", multiple = FALSE,
              accept = c(
                  "text/csv",
                  "text/comma-separated-values,text/plain",
                  ".csv")),
    fileInput("eligible", label="Eligibility Criteria", multiple = FALSE,
              accept = c(".xlsx")),
    fileInput("projInfo", label="Project Data", multiple = FALSE,
              accept = c(
                  "text/csv",
                  "text/comma-separated-values,text/plain",
                  ".csv")),
    tags$hr(),
    textInput("server", label = "Server Path"),
    textInput("database", label = "Database Name"),
    textInput("username", label = "Database Username"),
    passwordInput("dbPassword", label = "Database Password"),
    downloadButton("report", "Generate report")
)
readCSVparam <- function(inFile)
{
    if(is.null(inFile))
        return(NULL)
    else
        return(read.csv(inFile$datapath))
}
readXLparam <- function(inFile)
{
    if(is.null(inFile))
        return(NULL)
    else
        return(read_xlsx(inFile$datapath))
}

server <- function(input, output) {
    output$report <- downloadHandler(
        filename = "cs586Project.html",
        content = function(file){
            tempReport <- file.path(tempdir(), "cs586Project.Rmd")
            file.copy("cs586Project.Rmd", tempReport, overwrite = TRUE)
            #parameters passed to .rmd
            params <- list(availSurv = readCSVparam(input$availSurv), 
                           projSurv = readCSVparam(input$projSurv), 
                           eligible = readXLparam(input$eligibile),
                           projInfo = readCSVparam(input$projInfo), 
                           server = input$server, 
                           database = input$database, username = input$username, 
                           password = input$dbPassword)
            rmarkdown::render(tempReport, output_file = file,
                              params = params,
                              envir = new.env(parent = globalenv()))
        }
    )
}

# Run the application 
shinyApp(ui = ui, server = server)
