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
library(bslib)
library(plotly)



# Define UI for application that draws a histogram
fluidPage(

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
                                        choices = c("All ages", "65+", "26-65", "under 26")),
                            
                            selectInput("info", "Choose what u want to see:", 
                                        choices = c("Participant area", "Sleep quality", "Weight and bloodpressure T1"))
                        ),
                        
                        mainPanel(
                            tabsetPanel(
                                tabPanel("Plot", plotOutput("main_plot", width = "800px")),
                                tabPanel("Interactive Plot", plotlyOutput("barPlot")),
                                tabPanel("Summary", verbatimTextOutput("summary")),
                                tabPanel("Table", dataTableOutput("Lifelines_example"))
                            )
                        ),
                        
               ),
               
               
               tabPanel("FAQ",
                        h3("Frequently asked questions"),
                        p("From where does this data come from.")),
               
               tabPanel("Contact & info",
                        card(
                            card_title("Contact & Data info"),
                            card_header("info"),
                            card_body("This data dashboard shows different health problems / lifestyle choices that can be compared per province. 
                                      These health problems include; Depression, Burnout and Metabolic dissorders. 
                                      The lifestyle choices include; Smoking, Alcohol use in grams per week and weight. 
                                      Although weight isn't always something u can have influence on due to disease
                                      we can say that most people are able to control it with dieting, suplements and excersise. 
                                      The comparising is between multiple groups, these being a comparisin between provinces, male and female and it can be looked at through different age ranges."),
                            card_header("contact")
                        ))
               
               ),

    
    
    
)
