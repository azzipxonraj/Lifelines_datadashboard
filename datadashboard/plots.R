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
library(ggridges)


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

# Finance and DBP plot 
plot_finance_bp <- function(data) {
    ggplot(data, aes(x=factor(FINANCE_T1), y=WEIGHT_T1)) + 
        geom_boxplot() +
        xlab("Financial situation") +
        ylab("DBP (mm hg)") +
        theme_minimal()
}

# Sports and DBP plot
plot_sports_dbp <- function(data){
    ggplot(data, aes(x=!is.na(SPORTS_T1), y=DBP_T1)) + 
        geom_boxplot() +
        xlab("Participates in sports") +
        ylab("DBP (mm hg)") +
        theme_minimal()
}

#Sports and cholesterol plot
plot_sports_cho <- function(data){
    ggplot(data, aes(x=!is.na(SPORTS_T1), y=CHO_T1)) + 
        geom_boxplot() +
        xlab("Participates in sports") +
        ylab("Cholesterol (mmol/L)") +
        theme_minimal()
}

plot_NSES <- function(data){
    ggplot(data, aes(x=factor(FINANCE_T1), y=NSES)) + 
        geom_boxplot() +
        xlab("Financial situation") +
        ylab("NSES score") +
        theme_minimal()
}

plot_alc_depression <- function(data){
    ggplot(data=data, aes(x=SUMOFALCOHOL, group=factor(DEPRESSION_T1), fill=DEPRESSION_T1)) +
        geom_density(adjust=1.5) +
        xlab("Sum of alcohol per day in gram") +
        facet_wrap(~DEPRESSION_T1) +
        theme(legend.position = "none")
}


