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

    # nav bar that show's the different tabs
    navbarPage("Lifelines",
   
               
               #first tab pannel data viewer that shows all the plots and the table + filtering options
               tabPanel("Dataviewer",
                        sidebarPanel(
                            checkboxGroupInput(
                                inputId = "provinces", 
                                label = "Select provinces to display:", 
                                choices = c("Groningen", "Drenthe", "Friesland"), 
                                selected = c("Groningen", "Drenthe", "Friesland")
                            ),
                            
                            # Select input for gender that has 3 options all genders, male or female
                            selectInput("gender", "Choose a Gender:", 
                                        choices = c("All genders", "Male", "Female")),
                            
                            # Slider that can change the range for what age is shown
                            sliderInput( "age_slider", "Age Slider", min = 0, max = 100, 
                                value = c(0, 100)),
                            
                            # Slider that can change the range for what BMI is shown 15 is minimum in the dataset and 55 is max
                            sliderInput( "bmi_slider", "BMI slider", min = 15, max = 55, 
                                         value = c(15, 55)),
                            
                            # Slider that can change the range for what weight is shown 40 is minimum in the dataset and 160 is max
                            sliderInput( "weight_slider", "Weight slider (kg)", min = 40, max = 160, 
                                         value = c(40, 160)),
                            
                            # Slider that can change the range for what height is shown 135 is minimum in the dataset and 210 is max
                            sliderInput( "height_slider", "Height slider (cm)", min = 135, max = 210, 
                                         value = c(135, 210)),
                            

                            # Input that can change the financial situation that is show 10 options all listed in euro
                            selectizeInput("select_finance",
                                           "Select Financial situation (€) :",
                                           list("Financial situation (€)" = list("I do not know" = 1, 
                                                           "I don't want to awnser" = 2, 
                                                           "less then 750€" = 3,
                                                           "750€-1000€" = 4, 
                                                           "1000€-1500€" = 5, 
                                                           "1500€-2000€" = 6, 
                                                           "2000€-2500€" = 7, 
                                                           "2500€-3000€" = 8, 
                                                           "3000€-3500€" = 9,
                                                           "More then 3500€" = 10
                                                           )),
                                           multiple = TRUE
                            ),
                                
                            
                            #plot selector
                            selectInput("info", "Choose what you want to see:", 
                                        choices = c("Participant's", "Sleep quality", "Weight and bloodpressure T1",
                                                    "Finance and DBP", "NSES", "Alcohol consumption with depression",
                                                    "Sports and cholesterol", "Sports and DBP")),
                            width = 2,
                            
                            # dowload button to download a table
                            h5("Download table"),
                            downloadButton("downloadData", "Download"),
                            
                            # download the current plot that has the filter's aplied
                            h5("Download current plot"),
                            downloadButton("downloadPlot", "Download Plot")
                            
                            
                        ),
                        
                        # This panels contains the static- and interactive-plot + the table
                        mainPanel(
                            tabsetPanel(
                                #each tab panel has an id that is linked to the server.r like "main_plot"
                                tabPanel("Static plot", plotOutput("main_plot", width = "800px")),
                                tabPanel("Interactive plot", plotlyOutput("barPlot")),
                                tabPanel("Table", dataTableOutput("Lifelines_example"))
                            ),
                            width = 8
                            
                        ),
                        
                        
               ),
               
               
               #Here i render the FAQ
               tabPanel("FAQ",
                        div(
                            # here the area has been rendered with tmap this filtered from the world map to the province
                            h4("What area has this data been collected from?"),
                            p("These provinces have been used in the lifelines data"),
                            tmapOutput("map"),
                        ),
                        # Here the markdown file gets rendered that is shown with all the info for the FAQ
                        includeMarkdown("FAQ.Rmd")
               ),
                        
               

               
    ),

    
    
    
)
