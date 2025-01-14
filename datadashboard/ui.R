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
library(tmap)
library(sf)



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
                        
                        h4("This data has been suplied by the lifelines project"),
                        tags$a(href = "https://www.lifelines.nl", "Lifelines", target = "_blank"),
                        
               ),
               
               
               tabPanel("FAQ",
                        h3("Frequently asked questions"),
                        sidebarPanel(
                        div(
                            h4("From where does this data come from."),
                            p("This data has been suplied by the lifelines project"),
                            tags$a(href = "https://www.lifelines.nl", "Lifelines", target = "_blank"),
                            ),
                        ),
                        sidebarPanel(
                        br(),
                        div(
                            h4("What area has this data been collected from?"),
                            p("These provinces have been used in the lifelines data"),
                            tmapOutput("map"),
                        ),
                    ),
               ),
                        
               

               
    ),

    
    
    
)
