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
            finance = input$select_finance,
            bmi_slider = input$bmi_slider,
            weight_slider = input$weight_slider,
            height_slider = input$height_slider
        )
        
        return(data_filtered)
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
        } else if (input$info == "NSES") {
            plot_NSES(filtered_data())
        } else if (input$info == "Alcohol consumption with depression") {
            plot_alc_depression(filtered_data())
        } else if (input$info == "Sports and cholesterol") {
            plot_sports_glu(filtered_data())
        } else if (input$info == "Sports and DBP") {
            plot_sports_dbp(filtered_data())
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
        } else if (input$info == "NSES") {
            ggplotly(plot_NSES(filtered_data()))
        } else if (input$info == "Alcohol consumption with depression") {
            ggplotly(plot_alc_depression(filtered_data()))
        } else if (input$info == "Sports and cholesterol") {
            ggplotly(plot_sports_glu(filtered_data()))
        } else if (input$info == "Sports and DBP") {
            ggplotly(plot_sports_dbp(filtered_data()))
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
    
    output$downloadPlot <- downloadHandler(
        filename = function() {
            paste(input$info, "-plot-", Sys.Date(), ".png", sep = "")
        },
        content = function(file) {
            plot_to_save <- NULL
            
            # Match the current plot
            if (input$info == "Sleep quality") {
                plot_to_save <- plot_sleep_quality(filtered_data())
            } else if (input$info == "Participant's") {
                plot_to_save <- plot_participants(filtered_data())
            } else if (input$info == "Weight and bloodpressure T1") {
                plot_to_save <- plot_weight_bp_interactive(filtered_data())
            } else if (input$info == "Finance and DBP") {
                plot_to_save <- plot_finance_bp(filtered_data())
            } else if (input$info == "NSES") {
                plot_to_save <- plot_NSES(filtered_data())
            } else if (input$info == "Alcohol consumption with depression") {
                plot_to_save <- plot_alc_depression(filtered_data())
            }
            
            # Save the plot using ggsave
            if (!is.null(plot_to_save)) {
                ggsave(file, plot = plot_to_save, device = "png", width = 8, height = 6)
            }
        }
    )


    
    output$map <- renderTmap({
        netherlands <- rnaturalearth::ne_states(country = "Netherlands", returnclass = "sf")
        
        selected_provinces <- netherlands %>%
            filter(name %in% c("Groningen", "Friesland", "Drenthe"))
        
        tm_shape(selected_provinces) +
            tm_polygons(col = "name", title = "Province", border.col = "black") +
            tm_borders()
    })
    
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

    

