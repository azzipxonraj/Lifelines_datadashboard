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
library(dplyr)
library(psych)
library(hexbin)
library(RColorBrewer)
library(ggiraph)
library(DT)
library(plotly)
library(tmap)
library(sf)
library(ggbeeswarm)
library(markdown)



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
                            
                            sliderInput( "age_slider", "Age Slider", min = 0, max = 100, 
                                value = c(0, 100)),
                            
                            selectizeInput("select_finance",
                                           "Select Financial situation :",
                                           list("Financial situation" = list("I do not know" = 1, 
                                                           "I don't want to awnser" = 2, 
                                                           "less then 750" = 3,
                                                           "750-1000" = 4, 
                                                           "1000-1500" = 5, 
                                                           "1500-2000" = 6, 
                                                           "2000-2500" = 7, 
                                                           "2500-3000" = 8, 
                                                           "3000-3500" = 9,
                                                           "More then 3500" = 10
                                                           )),
                                           multiple = TRUE
                            ),
                                
                            
                            selectInput("info", "Choose what you want to see:", 
                                        choices = c("Participant's", "Sleep quality", "Weight and bloodpressure T1",
                                                    "Finance and DBP", "NSES", "Alcohol consumption with depression")),
                            width = 2,
                            
                            h5("Download table"),
                            downloadButton("downloadData", "Download")
                            
                        ),
                        
                        mainPanel(
                            tabsetPanel(
                                tabPanel("Static plot", plotOutput("main_plot", width = "800px")),
                                tabPanel("Interactive plot", plotlyOutput("barPlot")),
                                tabPanel("Table", dataTableOutput("Lifelines_example"))
                            ),
                            width = 8
                            
                        ),
                        
                        h4("This data has been suplied by the lifelines project"),
                        tags$a(href = "https://www.lifelines.nl", "Lifelines", target = "_blank"),
                        
               ),
               
               
               tabPanel("FAQ",
                        div(
                            h4("What area has this data been collected from?"),
                            p("These provinces have been used in the lifelines data"),
                            tmapOutput("map"),
                        ),
                        includeMarkdown("FAQ.Rmd")
               ),
                        
               

               
    ),

    
    
    
)
