# Load R functions and libraries
source("library_and_non_cleaning_fx.R")
source("availability_clean_fx.R")
source("projects_clean_fx.R")
source("projects_clean_fx.R")

# Define UI for application that takes input
ui <- fluidPage(theme = shinytheme("superhero"),
    titlePanel("Portland State CS Capstone Survey Analysis"),
    fluidRow(
        column(4,
               h3("Data:"),
               fileInput("availSurv", 
                         label="Student Availability Survey", 
                         multiple = FALSE,
                         accept = c(
                            "text/csv",
                            "text/comma-separated-values,text/plain",
                            ".csv")),
               fileInput("projSurv", 
                         label="Project Survey", 
                         multiple = FALSE,
                         accept = c(
                            "text/csv",
                            "text/comma-separated-values,text/plain",
                            ".csv")),
               fileInput("eligible", 
                         label = "Eligibility Criteria", 
                         multiple = FALSE,
                         accept = c(
                            "text/csv",
                            "text/comma-separated-values,text/plain",
                            ".csv")),
               fileInput("projInfo", label = "Project Data", multiple = FALSE,
                         accept = c(
                            "text/csv",
                            "text/comma-separated-values,text/plain",
                            ".csv"))
        ),
        column(3, 
               h3("Database Credentials:"),
               textInput("host", label = "Host"),
               textInput("dbName", label = "Database Name"),
               textInput("username", label = "Database Username"),
               passwordInput("dbPassword", label = "Database Password"),
               hr(),
               downloadButton("report", "Generate report")
        )
    ),
    br(),
    a("https://github.com/wbakerrobinson/CS586_Project")
)

server <- function(input, output)
{
    output$report <- downloadHandler(
        filename = "cs586Project.html",
        content = function(file){
            withProgress(message = 'Rendering, please wait!', {
                tempReport <- file.path(tempdir(), "cs586Project.Rmd")
                file.copy("cs586Project.Rmd", tempReport, overwrite = TRUE)
                #parameters passed to .rmd
                params <- list(availSurv = ReadCsvParam(input$availSurv), 
                               projSurv = ReadCsvParam(input$projSurv), 
                               eligible = ReadCsvParam(input$eligible),
                               projInfo = ReadCsvParam(input$projInfo), 
                               host = input$host,
                               dbName = input$dbname,
                               username = input$username,
                               password = input$dbPassword,
                               rendered_by_shiny = TRUE
                )
                    rmarkdown::render(tempReport, 
                                      output_file = file, 
                                      params = params, 
                                      envir = new.env(parent = globalenv())
                                      )
                })
        }
    )
}
    

# Run the application 
shinyApp(ui = ui, server = server)
