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



# ZIP codes for every province according to wikipedia

friesland_zipcodes <- c(
    8401:8409, 8411:8417, 8421:8429, 8431:8439, 8441:8449,
    8451:8459, 8461:8469, 8471:8479, 8481:8489, 8491:8499,
    8501:8509, 8511:8519, 8521:8529, 8531:8539, 8541:8549,
    8551:8559, 8561:8569, 8571:8579, 8581:8589, 8591:8599,
    8601:8609, 8611:8619, 8621:8629, 8631:8639, 8641:8649,
    8651:8659, 8661:8669, 8671:8679, 8681:8689, 8691:8699,
    8701:8709, 8711:8719, 8721:8729, 8731:8739, 8741:8749,
    8751:8759, 8761:8769, 8771:8779, 8781:8789, 8791:8799,
    8801:8809, 8811:8819, 8821:8829, 8831:8839, 8841:8849,
    8851:8859, 8861:8869, 8871:8879, 8881:8889, 8891:8899,
    9001:9009, 9011:9019, 9021:9029, 9031:9039, 9041:9049,
    9051:9059, 9061:9069, 9071:9079, 9081:9089, 9091:9099,
    9101:9109, 9111:9119, 9121:9129, 9131:9139, 9141:9149,
    9151:9159, 9161:9169, 9171:9179, 9181:9189, 9191:9199,
    9201:9209, 9211:9219, 9221:9229, 9231:9239, 9241:9249,
    9251:9259, 9261:9269, 9271:9279, 9281:9289, 9291:9299
)

groningen_zipcodes <- c(
    2750:2752, 2760:2761, 2811, 2840:2841, 2910:2914,
    5340:5359, 5366:5368, 5370:5371, 5373, 5386, 5394:5398,
    9350:9351, 9354:9356, 9359, 9361:9367, 9479, 
    9500:9503, 9540:9541, 9545, 9550:9551, 9560:9561, 9563, 9566, 
    9580:9581, 9584:9585, 9591, 9600:9611, 9613:9629, 
    9631:9633, 9635:9636, 9640:9649, 9651, 9661, 9663, 9665, 
    9670:9675, 9677:9679, 9681:9688, 9691, 9693, 9695:9704, 
    9711:9718, 9721:9728, 9731:9738, 9741:9747, 9750:9756, 
    9771, 9773:9774, 9790:9798, 9800:9805, 9811:9812, 
    9821:9825, 9827:9828, 9831:9833, 9841:9845, 
    9860:9866, 9881:9886, 9891:9893, 9900:9915, 
    9917:9925, 9930:9934, 9936:9937, 9939, 9942:9949, 
    9951, 9953:9957, 9961:9969, 9970:9999
)

drenthe_zipcodes <- c(
    3925, 7705, 7740:7742, 7750:7751, 7753:7756, 7760:7761, 7764:7766, 
    7800:7801, 7811:7815, 7821:7828, 7830:7831, 7833, 7840:7849, 7851:7856, 
    7858:7859, 7860:7864, 7871:7877, 7880:7881, 7884:7885, 7887, 7889:7892, 
    7894:7895, 7900:7918, 7920:7929, 7931:7938, 7940:7944, 7946, 7948:7949, 
    7957:7958, 7960:7966, 7970:7975, 7980:7986, 7990:7991, 8066, 8325:8326, 
    8334:8339, 8341:8347, 8351, 8355:8356, 8361:8363, 8371:8378, 8380:8398, 
    8420:8428, 8430:8435, 8437:8439, 8470:8479, 8481:8489, 9300:9307, 
    9311:9315, 9320:9321, 9330:9337, 9341:9343, 9351, 9400:9423, 9430:9439, 
    9441:9449, 9450:9469, 9470:9475, 9480:9489, 9491:9497, 9511:9512, 9514:9515, 
    9520:9528, 9530:9537, 9564, 9571, 9573:9574, 9654:9659, 9749, 9760:9761, 
    9765:9766, 9780:9785, 9959
)

file_path <- here("lifelines_data/Dataset", "Lifelines Public Health dataset - 2024.csv")  # Constructs "data/data.csv" relative to the project root

data_lifelines <- read.csv(file_path)
data_filterd_gender <- data_lifelines$GENDER %>% factor(levels = c(1,2), labels = c("Male", "Female"))


#start the server, give it a function
server <- function(input, output, session) {  
    

    # Reactive function to filter the data
    filtered_data <- reactive({
        
        # Load and prepare data

        data_filterd <- data_lifelines

        
        # Assign province based on ZIP_CODE
        data_filterd <- data_filterd %>% 
            mutate(Province = case_when(
                ZIP_CODE %in% friesland_zipcodes ~ "Friesland",
                ZIP_CODE %in% groningen_zipcodes ~ "Groningen",
                ZIP_CODE %in% drenthe_zipcodes ~ "Drenthe",
                TRUE ~ NA_character_
            ))
        
        # Filter data based on user input
        #In this if statement it checks if there's an input with !is.null 
        # plus the length check as a double check
        if (!is.null(input$provinces) && length(input$provinces) > 0) {
            data_filterd <- data_filterd %>% 
                filter(Province %in% input$provinces)
        }
        
        # Using switch instead of if else statements to make the code more readable
        #If gender input doesnt equal "All genders" filter in data frame will 
        #look if "Male" is selected and else if "Female is selected" then
        # based of that pipe to the dataframe what needs to be shown in the gender collum
        if (input$gender != "All genders") {
            data_filterd <- data_filterd %>% 
                filter(GENDER == switch(input$gender, "Male" = 1, "Female" = 2))
        }
        
        if (input$age != "All ages") {
            data_filterd <- data_filterd %>% 
                filter(
                    switch(input$age, 
                           "65+" = AGE_T1 >= 65,
                           "26-65" = between(AGE_T1, 26, 65),
                           "under 26" = AGE_T1 < 26,
                           TRUE
                    )
                )
        }
        

        
        
        return(data_filterd)
    })
    
    
    output$main_plot <- renderPlot({
        if (input$info == "Sleep quality") {
            
            ggplot(filtered_data(), aes(x = factor(SLEEP_QUALITY), y = DBP_T1, color = factor(SLEEP_QUALITY))) +
                geom_quasirandom() +
                xlab("Sleep quality") +
                ylab("DBP (mm hg)") +
                theme_minimal()
            
        } else if (input$info == "Participant area") {
            
            ggplot(filtered_data(), aes(x = AGE_T1, fill = factor(GENDER))) +
                geom_bar() +
                ylab("Count of People") +
                xlab("Province") +
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
            
        } else if (input$info == "Participant area") {
            p_age_count <- ggplot(filtered_data(), aes(x = AGE_T1, fill = factor(GENDER))) +
                geom_bar() +
                ylab("Count of People") +
                xlab("Province") +
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

    

