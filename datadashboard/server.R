#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#
library(shiny)
library(dplyr)
library(psych)
library(ggplot2)
library(hexbin)
library(RColorBrewer)
library(ggiraph)
library(DT)
library(plotly)
library(tmap)
library(sf)
library(ggbeeswarm)
library(here)

source("plots.R")  # Load the plot file
source("utils.R")  # Load the utils file
file_path <- here("lifelines_data/Dataset", "Lifelines Public Health dataset - 2024.csv")  # Constructs "data/data.csv" relative to the project root

data_lifelines <- read.csv(file_path)
data_filterd_gender <- data_lifelines$GENDER %>% factor(levels = c(1,2), labels = c("Male", "Female"))


#start the server, give it a function
server <- function(input, output, session) {  
    

    # Reactive function to filter the data
    filtered_data <- reactive({
        
        # Load and prepare data
        data_filtered <- data_lifelines
        
        # Assign provinces
        data_filtered <- assign_province(data_filtered, friesland_zipcodes, groningen_zipcodes, drenthe_zipcodes)
        
        # Apply user filters
        data_filtered <- filter_data(
            data = data_filtered,
            provinces = input$provinces,
            gender = input$gender,
            age_range = input$age_slider,
            finance = input$select_finance
        )
        
        return(data_filtered)
    })
    
    output$main_plot <- renderPlot({
        if (input$info == "Sleep quality") {
            
            ggplot(filtered_data(), aes(x = factor(SLEEP_QUALITY), y = DBP_T1, color = factor(SLEEP_QUALITY))) +
                geom_quasirandom() +
                xlab("Sleep quality") +
                ylab("DBP (mm hg)") +
                theme_minimal()
            
        } else if (input$info == "Participant's") {
            
            ggplot(filtered_data(), aes(x = AGE_T1, fill = factor(GENDER))) +
                geom_bar() +
                ylab("Count of People") +
                xlab("Age") +
                labs(fill = "Gender (1 = Male, 2 = Female)") +
                theme_minimal() +
                coord_flip()
                
        } else if (input$info == "Weight and bloodpressure T1") {
            
            bin_blp_t1<-hexbin(filtered_data()$WEIGHT_T1, filtered_data()$DBP_T1, xbins=40)
            my_colors=colorRampPalette(rev(brewer.pal(11,'Spectral')))
            plot(bin_blp_t1, 
                 xlab = "Weight (kg)",
                 ylab = "DBP (mm hg)",
                 colramp = my_colors)
        }
    })


    output$main_plot <- renderPlot({
        if (input$info == "Sleep quality") {
            plot_sleep_quality(filtered_data())
        } else if (input$info == "Participant's") {
            plot_participants(filtered_data())
        } else if (input$info == "Weight and bloodpressure T1") {
            plot_weight_bp_static(filtered_data())
        } else if (input$info == "Finance and DBP") {
            plot_finance_bp(filtered_data())
        }
    })
    
    output$barPlot <- renderPlotly({
        if (input$info == "Sleep quality") {
            ggplotly(plot_sleep_quality(filtered_data()))
        } else if (input$info == "Participant's") {
            ggplotly(plot_participants(filtered_data()))
        } else if (input$info == "Weight and bloodpressure T1") {
            ggplotly(plot_weight_bp_interactive(filtered_data()))
        } else if (input$info == "Finance and DBP") {
            ggplotly(plot_finance_bp(filtered_data()))
        }
    })
    
    #here the filtered_data() gets put in a downloadable file with all added filters by user
    output$downloadData <- downloadHandler(
        #here the filename and file type gets made (a csv is easiest)
        filename = function() {
            paste("Lifelines_example", ".csv", sep = "")
        },
        #here gets specified what should be in the file and its the filtered_data()
        content = function(file) {
            write.csv(filtered_data(), file, row.names = FALSE) 
        }
    )
    
    
    # Render DataTable
    output$Lifelines_example <- renderDataTable({
        DT::datatable(
            filtered_data(), 
            options = list(
                pageLength = 10,
                autoWidth = TRUE,
                searching = TRUE,
                lengthMenu = c(5, 10, 25, 50, 100),
                scrollX = TRUE  # Enable horizontal scrolling
            )
        )
    })
    
    
}

    

