#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)
library(ggplot2)


# Define server logic required to draw a histogram

data_lifelines <- read.csv("/Users/jarnoduiker/github_bioinf/Lifelines_datadashboard/lifelines_data/Dataset/Lifelines Public Health dataset - 2024.csv")

function(input, output, session) {
    
    output$Lifelines_example <- renderDataTable(data_lifelines, options =  list(pageLength = 5))
   
    output$Age_finance <- renderPlot(ggplot(data_lifelines, mapping = aes(x=AGE_T1, fill = factor(FINANCE_T1))) + 
                                         geom_bar())
    
    
    #BINSIZE INTERACTIEF MAKEN
    
}
