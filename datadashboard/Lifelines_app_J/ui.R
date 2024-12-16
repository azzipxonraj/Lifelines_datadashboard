#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)
library(ggplot2)
library(shinythemes)



# Define UI for application that draws a histogram
fluidPage(theme = shinytheme("readable"),

    # Application title
    titlePanel("Data lifelines - Project"),
    
    navbarPage("Lifelines",
               tabPanel("Dataviewer",
                        sidebarPanel(
                            checkboxGroupInput(
                                inputId = "provinces", 
                                label = "Select provinces to display:", 
                                choices = c("Groningen", "Drenthe", "Friesland"), 
                                selected = c("Groningen", "Drenthe", "Friesland") 
                            ),
                            
                            selectInput("gender", "Choose a Gender:", 
                                        choices = c("All genders", "Male", "Female")),
                            
                            selectInput("age", "Choose an age range:", 
                                        choices = c("All ages", "65+", "30-50", "under 26")),
                            
                            selectInput("info", "Choose what u want to see:", 
                                        choices = c("Participant area", "Sleep quality"))
                            ),
                        
                        mainPanel(
                            tabsetPanel(
                                tabPanel("Plot", plotOutput("main_plot", width = "800px")),
                                tabPanel("Summary", verbatimTextOutput("summary")),
                                tabPanel("Table", dataTableOutput("Lifelines_example"))
                            )
                        ),
                        
                        ),
               
               tabPanel("FAQ",
                        h3("Frequently asked questions"),
                        p("From where does this data come from.")),
               
               tabPanel("Contact & info")),

    
    
    
)
