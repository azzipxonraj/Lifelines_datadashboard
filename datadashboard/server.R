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


    output$barPlot <- renderPlotly({
        if (input$info == "Sleep quality") {
            
            
            p_sq <- ggplot(filtered_data(), aes(x = factor(SLEEP_QUALITY), y = DBP_T1, color = factor(SLEEP_QUALITY))) +
                geom_quasirandom() +
                xlab("Sleep quality") +
                ylab("DBP (mm hg)") +
                labs(color = "Sleep Quality") +
                theme_minimal()
            
            ggplotly(p_sq)
            
        } else if (input$info == "Participant's") {
            p_age_count <- ggplot(filtered_data(), aes(x = AGE_T1, fill = factor(GENDER))) +
                geom_bar() +
                ylab("Count of People") +
                xlab("Age") +
                labs(fill = "Gender (1 = Male, 2 = Female)") +
                theme_minimal() +
                coord_flip()
            
            ggplotly(p_age_count)
            
        } else if (input$info == "Weight and bloodpressure T1") {
            ggplot(filtered_data(), aes(x = WEIGHT_T1, y = DBP_T1)) +
                geom_hex(bins=40) +
                xlab("Weight (kg)") +
                ylab("DBP (mm hg)") +
                theme_minimal()
        }
    })
    
    
    
    
    # remove from server file and put in a markdown
    output$summary <- renderText({
        if (input$info == "Sleep quality") {
        "
        This is a quasirandom plot, it is like a violin plot but with points.
        This plot shows the correlation between good sleep quality being 1 and bloodpressure.
        Research show's that good sleep is essential to good cardiovascular health, in this plot
        the difference can be shown in a very light way. There are multiple factors not shown here
        that can also influence that cardiovascular health. Like weight and age. 
        !! MALE HAD MANY NA'S CAUSING ERROR IN THE PLOT WITH FILTERING!!
        
        "
        } else if (input$info == "Weight and bloodpressure T1") {
            
        "
        Hexbin chart is a 2d density chart, allowing to visualize the relationship between 2 numeric variables. 
        Scatterplots can get very hard to interpret when displaying large datasets, 
        as points inevitably overplot and can't be individually discerned.
        
        "
            
        } else if (input$info == "Participant area") {
        "
        A barplot (or barchart) is one of the most common types of graphic.
        It shows the relationship between a numeric and a categoric variable. 
        Each entity of the categoric variable is represented as a bar. 
        The size of the bar represents its numeric value. This barplot shows how many participants there are 
        and i what age range they are. The user can filter this data with the sidebar!
        The filtering options are: Gender, Age range and Province"
            
        }
        
    })
    
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
                lengthMenu = c(5, 10, 25, 50, 100)
            )
        )
    })
    
    
}

    

