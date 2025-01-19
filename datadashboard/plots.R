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

# Sleep Quality Plot
plot_sleep_quality <- function(data) {
    ggplot(data, aes(x = factor(SLEEP_QUALITY), y = DBP_T1, color = factor(SLEEP_QUALITY))) +
        geom_quasirandom() +
        xlab("Sleep quality") +
        ylab("DBP (mm hg)") +
        labs(color = "Sleep Quality") +
        theme_minimal()
}

# Participant's Age and Gender Plot
plot_participants <- function(data) {
    ggplot(data, aes(x = AGE_T1, fill = factor(GENDER))) +
        geom_bar() +
        ylab("Count of People") +
        xlab("Age") +
        labs(fill = "Gender (1 = Male, 2 = Female)") +
        theme_minimal() +
        coord_flip()
}

# Weight and Blood Pressure Plot (Static Hexbin)
plot_weight_bp_static <- function(data) {
    bin_blp_t1 <- hexbin(data$WEIGHT_T1, data$DBP_T1, xbins = 40)
    my_colors <- colorRampPalette(rev(brewer.pal(11, 'Spectral')))
    plot(bin_blp_t1, 
         xlab = "Weight (kg)", 
         ylab = "DBP (mm hg)", 
         colramp = my_colors)
}

# Weight and Blood Pressure Plot (Interactive Hexbin)
plot_weight_bp_interactive <- function(data) {
    ggplot(data, aes(x = WEIGHT_T1, y = DBP_T1)) +
        geom_hex(bins = 40) +
        xlab("Weight (kg)") +
        ylab("DBP (mm hg)") +
        theme_minimal()
}
