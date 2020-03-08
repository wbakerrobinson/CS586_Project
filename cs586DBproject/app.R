library(shiny)
library(data.table)

# Define UI for application that draws a histogram
ui <- fluidPage(
    titlePanel("Portland State Capstone Setup"),
    fileInput("csv1", label="Student Availability Survey", multiple = FALSE),
    fileInput("csv2", label="Project Survey", multiple = FALSE),
    fileInput("csv3", label="Eligibility Criteria", multiple = FALSE),
    fileInput("csv4", label="Project Data", multiple = FALSE),
    textInput("server", label = "Server Path"),
    textInput("database", label = "Database Name"),
    textInput("username", label = "Database Username"),
    textInput("dbPassword", label = "Database Password"),
    downloadButton("report", "Generate report")
)

server <- function(input, output) {
    output$report <- downloadHandler(
        filename = "cs586Project.html",
        content = function(file){
            tempReport <- file.path(tempdir(), "cs586Project.Rmd")
            file.copy("cs586Project.Rmd", tempReport, overwrite = TRUE)
            #parameters passed to .rmd
            params <- list(csv1 = input$csv1, csv2 = input$csv2, csv3 = input$csv3,
                           csv4 = input$csv4, server = input$server, 
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
