library(shiny)
library(data.table)

# Define UI for application that draws a histogram
ui <- fluidPage(
    titlePanel("Portland State CS Capstone Survey Analysis"),
    fileInput("csv1", label="Student Availability Survey", multiple = FALSE,
              accept = c(
                  "text/csv",
                  "text/comma-separated-values,text/plain",
                  ".csv")),
    fileInput("csv2", label="Project Survey", multiple = FALSE,
              accept = c(
                  "text/csv",
                  "text/comma-separated-values,text/plain",
                  ".csv")),
    fileInput("csv3", label="Eligibility Criteria", multiple = FALSE,
              accept = c(
                  "text/csv",
                  "text/comma-separated-values,text/plain",
                  ".csv")),
    fileInput("csv4", label="Project Data", multiple = FALSE,
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

server <- function(input, output) {
    output$report <- downloadHandler(
        filename = "cs586Project.html",
        content = function(file){
            tempReport <- file.path(tempdir(), "cs586Project.Rmd")
            file.copy("cs586Project.Rmd", tempReport, overwrite = TRUE)
            #parameters passed to .rmd
            params <- list(csv1 = readCSVparam(input$csv1), 
                           csv2 = readCSVparam(input$csv2), 
                           csv3 = readCSVparam(input$csv3),
                           csv4 = readCSVparam(input$csv4), 
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
