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
library(dplyr)
library(DT)


# Define server logic required to draw a histogram


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



server <- function(input, output, session) {  
    filtered_data <- reactive({
        
        # Load the data
        data_lifelines <- read.csv("/Users/jarnoduiker/github_bioinf/Lifelines_datadashboard/lifelines_data/Dataset/Lifelines Public Health dataset - 2024.csv")

        data_lifelines <- data_lifelines %>%
            mutate(Province = case_when(ZIP_CODE %in% friesland_zipcodes ~ "Friesland", 
                                        ZIP_CODE %in% groningen_zipcodes ~ "Groningen",
                                        ZIP_CODE %in% drenthe_zipcodes ~ "Drenthe"))
        
        
        
        if (input$area != "The entire North") {
            if (input$area == "Groningen") {
                data_lifelines <- data_lifelines %>% filter(Province == "Groningen")
            } else if (input$area == "Friesland") {
                data_lifelines <- data_lifelines %>% filter(Province == "Friesland")
            } else if (input$area == "Drenthe") {
                data_lifelines <- data_lifelines %>% filter(Province == "Drenthe")
            }
        
        }
        

        
        if (input$gender != "All genders") {
            if (input$gender == "Male") {
                data_lifelines <- data_lifelines %>% filter(GENDER == 1)
            } else if (input$gender == "Female") {
                data_lifelines <- data_lifelines %>% filter(GENDER == 2) 
            }
        }
        
        if (input$age != "All ages") {
            if (input$age == "65+") {
                data_lifelines <- data_lifelines %>% filter(AGE_T1 >= 65)
            } else if (input$age == "30-50") {
                data_lifelines <- data_lifelines %>% filter(between(AGE_T1, 30,50))
            } else if (input$age == "under 26") {
                data_lifelines <- data_lifelines %>% filter(AGE_T1 < 26)
            }
            
        }
        return(data_lifelines)
    })

    output$Age_finance <- renderPlot({
        ggplot(filtered_data(), mapping = aes(x=Province, fill = factor(GENDER))) +
            ylab("Count in people") +
            labs(fill = "Gender
                 1 = Male
                 2 = Female") +
            xlab("Province's") +
            theme_minimal() +
            geom_bar()
        
    })

    output$Lifelines_example <- renderDataTable({
        DT::datatable(filtered_data(), 
                      options = list(pageLength = 10,  # Number of rows per page
                                     autoWidth = TRUE, 
                                     searching = TRUE, 
                                     lengthMenu = c(5, 10, 25, 50, 100)))  # Control how many entries can be displayed
    })
}

    

    
    #BINSIZE INTERACTIEF MAKEN
    

