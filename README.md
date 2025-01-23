# Datadashboard Lifelines Lifestyles

This project presents an interactive data dashboard based on exploratory data analysis using data from [LifeLines](https://www.lifelines.nl). The dashboard explores correlations between lifestyle factors such as sleep quality and weight, and diastolic blood pressure (DBP). These factors were chosen because they are often manageable through personal lifestyle changes or medical intervention. High blood pressure is a critical health concern due to its role in conditions like atherosclerosis, strokes, and heart attacks.

The dashboard includes three main visualizations: participant distribution, sleep quality, and weight in relation to blood pressure. Users can explore both interactive and non-interactive plots, apply filters for province, gender, and age group, and access additional tabs for explanations, FAQs, and contact information. This functionality enables users to discover insights that could benefit public health understanding.

This project is a datadashboard based on data given by the Hanze UAS in collabiration with the [LifeLines](https://www.lifelines.nl) project. After a exploratory data analysis some ineresting data has came forward that have been made into some plots. DBP - diastolic blood pressure was one of the main point's of focus in this project. Some lifestyle factors have been chosen that could have influence on the DBP these factors are sleep quality, weight, height, NSES (Neighborhood socio-economic status score) and cholesterol. This datadashboard has 2 types of plots to show this, a static-plot and a interactive version of the static-plot. This datadashboard also has a reactive filter that can change the graphs live, this filter is explained fully in

## Table of contents

1.  [Background](#background)
2.  [How to use this app](#how-to-use-this-app)
3.  [Libraries](#libraries)
4.  [What do you see?](#what-do-you-see)
5.  [Filter options](#filter-options)
6.  [What plot's are in this dashboard?](#what-plots-are-in-this-dashboard)
7.  [Authors](#authors)
8.  [License](#license)
9.  [Version History](#version-history)

## Background {#background}

This project is a datadashboard made using data provided by <https://www.lifelines.nl> this data has been through a Exploratory Data Analysis. The findings that we're found interesting from this analysis have been visualized in a normal plot and an interactive plot that show different lifestyle factors. The lifestyle factors that have been chosen are the sleep quality and weight in correlation to DBP (Diastolic Blood presure). These factors have been chosen because they are two things that can be fixed by people themselfs. A high weight can be fixed for 90% of people with a healthy diet and regular excercise, this meaning that if their bloodpressure is high due to their weight it should be able to be lowered by the previously mentioned solutions. For sleep quality it could be harder to fix but still managable, this could be fixed by going to a doctor (allot of people have undiagnosed sleep apnea) that could give a diagnose of different scala. Or the quality of where someone sleeps need's improvement, this could be the sounds that happen when a person is supossed to sleep, the ammount of blue light a person gets before bed that could mess with their melatonin or other hormones, the quality of the bed and the room could contribute to bad sleep and ofcourse the length of someone's sleep has influence on the sleep cycles that contributes most to quality of sleep. Getting enough rem sleep is essential for optimal function of the body and mind.

So why Diastolic Blood presure? a high blood presure is very dangerous for a multitude of factors. High bloodpresure damages the bloodvessel wall, these damages are microtears in the bloodvessel wall this in turn causes Atherosclerosis (the buildup of fats, cholesterol and other substances in and on the artery walls) due to this the veins will narrow and cause more stress on that spot in the bloodvessel.

![Figure 1: Complications of atherosclerosis - <https://upload.wikimedia.org/wikipedia/commons/5/5b/Late_complications_of_atherosclerosis.PNG>](https://upload.wikimedia.org/wikipedia/commons/5/5b/Late_complications_of_atherosclerosis.PNG "Complications of atherosclerosis")

Seen in this figure is the progression of atherosclerosis, it will start slow and build up allot of plaque and fats, then there are three options that will occur. critical stenosis can cause a variety of symptoms ranging from lower back pain to weakness in the legs and many other's depending on where the vein is located. Superimposed thrombus is also a possibilty of late stage atherosclerosis, this means a blood cloth will be stuck in the vein causing a blockade that could lead to a stroke when this happens in the brain or a heart attack when in the heart and a variaety of different other complications depending on what area the vein is located. Aneurism/Rupture of the veinwall happens when the cellwall becomes too weak due to excess stress from high blood pressure causing it to rip and blood leaking into your body. This will cause different complications again varying on the location of the vein. some complications could include internal bleeding and a stroke.

### How to use this app {#how-to-use-this-app}

-   R version 4.4.1 (2024-06-14)

#### Libraries {#libraries}

Here's how to install the required packages

```{r}
install.packages("package")
```

Or it can be done with Biocmanager

```{r}
BiocManager::install("package")
```

| Package      | Version   | Link                                                            |
|------------------|------------------|------------------------------------|
| shiny        | 1.9.1     | [shiny](https://cran.r-project.org/package=shiny)               |
| dplyr        | 1.1.4     | [dplyr](https://cran.r-project.org/package=dplyr)               |
| psych        | 2.4.6.26  | [psych](https://cran.r-project.org/package=psych)               |
| ggplot2      | 3.5.1     | [ggplot2](https://cran.r-project.org/package=ggplot2)           |
| hexbin       | 1.28.5    | [hexbin](https://cran.r-project.org/package=hexbin)             |
| RColorBrewer | 1.1.3     | [RColorBrewer](https://cran.r-project.org/package=RColorBrewer) |
| ggiraph      | 0.8.12    | [ggiraph](https://cran.r-project.org/package=ggiraph)           |
| DT           | 0.33      | [DT](https://cran.r-project.org/package=DT)                     |
| plotly       | 4.10.4    | [plotly](https://cran.r-project.org/package=plotly)             |
| tmap         | 3.99.9003 | [tmap](https://cran.r-project.org/package=tmap)                 |
| sf           | 1.0.19    | [sf](https://cran.r-project.org/package=sf)                     |
| shinythemes  | 1.2.0     | [shinythemes](https://cran.r-project.org/package=shinythemes)   |
| bslib        | 0.5.1     | [bslib](https://cran.r-project.org/package=bslib)               |
| ggbeeswarm   | 0.7.2     | [ggbeeswarm](https://cran.r-project.org/package=ggbeeswarm)     |
| markdown     | 1.8       | [markdown](https://cran.r-project.org/package=markdown)         |
| here         | 1.0.1     | [here](https://cran.r-project.org/package=here)                 |
| ggridges     | 0.5.4     | [ggridges](https://cran.r-project.org/package=ggridges)         |

All these versions have been checked on my personal system on 22-01-2025

To run the program the user will have to run the server.R and or ui.R (after installing the required packages) this should be done through an IDE that can run R code, this could be an IDE like Rstudio. Then the program will launch in another window this being a local server on your personal machine that will host the datadashboard. After that the user should be able to interact with the datadashboard without any issues.

#### What do you see? {#what-do-you-see}

3 tabs, the static-plot, interactive lpot and the datatable.

each of these plots have an interactive and non-interactive version. The user can also apply different filters, What province should be shown, What gender should be shown, what financial situation and what age group.

This allows the user to look at different variety's of these plots causing them to make their own findings that might be interesting to the public.

There is also a page that explains Frequently Asked Questions

![Figure 2: opening screen](images/First_look.png)

Here is the first thing shown when you run the app. This shows the filtering options, the different tabs with the non-interactive and interactive plot, the summary (text explenation) and the table.

### Filter options {#filter-options}

![Figure 3: Filter options](images/Filter_options.png){alt="Figure 7: Filter options" width="200"}

-   Province selection

    -   Due to the data being collected from 3 different provinces, comparing the plots between these would be very interesting. For this reason the filter option for each province have been added. This has been done with filtering for zip-codes. The way of selecting what provinces should be shown is done with checkboxes. All provinces start being checked and can be unchecked and are then filtered out the plot.

-   Gender selection

    -   The gender of a person can have influence on the outcome of different plots. For example the average weight will be very different for females then for males so by filtering out males the plot could show a very different result. Selecting what gender should be shown is done by selecting the wanted gender from a drop down. This being, All genders, Male or Female.

-   Age slider

    -   The age can have influence on allot of variables like weight, financial situation , sleep quality and much more. Due to this an age slider has been implemented so the user can choose themselfs what age group should be shown. As standard all ages from a min of 0 to a max of 100 years old will be shown this includes all ages from the dataset from lifelines.

-   BMI slider

    -   A person's BMI can have allot of inluence on the general health. Altough someones BMI doesn't say everything, this is because it doesn't make a difrence between muscle and fat. This means a person could have a high BMI but could be in amazing shape. Even though this problem is known BMI is still an important filter (it doesn't have to be used).

-   Height slider

    -   Height can be an important factor to someone's lifestyle, at old age height could be something that can prevent someone from doing sports because of the brittleness in the bones. The height also has influence on someones weight and how much kcal someone should consume each day making it easier to have higher cholesterol.

-   Weight slider

    -   Weight is a very important factor to someone's health, being overweight can cause a multitude of problems from bad joints making someone inable to do sports to cardiovascular problems. combining this slider with the height slider could show some interesting graphs.

-   Financial situation

    -   For the financial situation there are 10 choices, 2 contain people who either didn't know or people who didn't want to say. for the other 8 there is a scale from less then 750 euro a month to more then 3500 a month. All these different salary ranges will be displayed in full with a format like "750-1000". The financial situation that you're in will have allot of impact on what resources you have available. Due to that changing your health or ways of living will be easier most likely when u have more money. It can however also have negative influence on your mental health with stress and burnouts. This is why it is important to have this as a seperate filter.

### Other options

![Figure 4: other options and buttons](datadashboard/images/Other_options.png){alt="Figure 10: other options and buttons"}

-   Choose what you want to see

    -   This is the dropdown menu that shows what plots are available, for explenation what each plot contains see figures above.

-   Download table

    -   This button let's the user dowload the data with how they've modified it. it will pop up a save window for the user to give it a name and the file will be saved as a .csv

-   Download plot

    -   This button gives the user the option to download the current plot that is shown with it's filters. This can give the user the option to compare his made plot to someone of another user or the plot's in the readme/FAQ

### What plot's are in this dashboard? {#what-plots-are-in-this-dashboard}

**The graphs**

![Figure 5: Participants where X = counts and Y = Age](images/barplot.png)

A barplot (or barchart) is one of the most common types of graphic. It shows the relationship between a numeric and a categoric variable. Each entity of the categoric variable is represented as a bar. The size of the bar represents its numeric value. This barplot shows how many participants there are and i what age range they are. The user can filter this data with the sidebar! The filtering options are: Gender, Age range and Province"

![Figure 6: Hexbin plot for Weight (kg) and DBP (mm hg)](images/Hexbin_plot.png)

Hexbin chart is a 2d density chart, allowing to visualize the relationship between 2 numeric variables. Scatterplots can get very hard to interpret when displaying large datasets, as points inevitably overplot and can't be individually discerned.

![Figure 7: Violin / quasirandom that has the DBP (mm hg) and sleep quality](images/Violin_plot.png)

Figure 7 is a quasirandom plot, it is like a violin plot but with points. This plot shows the correlation between good sleep quality being 1 and bloodpressure. Research show's that good sleep is essential to good cardiovascular health, in this plot the difference can be shown in a very light way. There are multiple factors not shown here that can also influence that cardiovascular health. Like weight and age. !! MALE HAD MANY NA'S CAUSING ERROR IN THE PLOT WITH FILTERING!!

![Figure 8: NSES boxplot](images/NSES_plot.png){width="800"}

A boxplot effectively summarizes one or more numeric variables by highlighting key statistical features. The box represents the interquartile range (IQR), which spans the middle 50% of the data between the lower (Q1) and upper (Q3) quartiles, with the line inside indicating the median. Whiskers extend from the box to represent the range of values within 1.5 times the IQR beyond Q1 and Q3, excluding outliers. Any values outside this range are marked as outliers, providing a clear visual of the data's spread and central tendency. This plot show's NSES - Neighborhood socio-economic status score according to CBS Statistics Netherlands, based on inhabitants’ educational level, income and job prospective. This means a higher score = a better Neighborhood.

The x-axis is financial situation and the y-axis shows the NSES score.

![Figure 9: Alcohol - Financial situation density plot](images/plot_alc.png){width="800"}

Figure 9 shows the distribution of daily alcohol consumption (in grams) for two groups, "0" and "1," using density curves. Both distributions are left-skewed, indicating that most individuals in both groups consume little to no alcohol. Group "0" has a broader distribution with more extreme values, while group "1" shows a sharper peak at low consumption levels and fewer outliers, reflecting differences in alcohol consumption patterns.

People with depression can have destructive behavior that could lead to more alcohol use, therefore this plot can be interesting with the filtering.

![Figure 10: DBP for every financial situation](images/bar_plot_DBP.png){width="800"}

A boxplot effectively summarizes one or more numeric variables by highlighting key statistical features. The box represents the interquartile range (IQR), which spans the middle 50% of the data between the lower (Q1) and upper (Q3) quartiles, with the line inside indicating the median. Whiskers extend from the box to represent the range of values within 1.5 times the IQR beyond Q1 and Q3, excluding outliers. Any values outside this range are marked as outliers, providing a clear visual of the data's spread and central tendency. This plot show's DBP for each financial situation. The DBP is influenced not only by physical health but also mental health, problems like stress and financial hardship can have a big influence too. This is why this plot is very important.

![Figure 11: boxplot sports and DBP](images/sports_dbp.png){alt="Figure 7: boxplot sports and DBP" width="800"}

Figure 11 is a boxplot, A boxplot effectively summarizes one or more numeric variables by highlighting key statistical features. The box represents the interquartile range (IQR), which spans the middle 50% of the data between the lower (Q1) and upper (Q3) quartiles, with the line inside indicating the median. Whiskers extend from the box to represent the range of values within 1.5 times the IQR beyond Q1 and Q3, excluding outliers. Any values outside this range are marked as outliers, providing a clear visual of the data's spread and central tendency.

The x-axis shows TRUE and FALSE, this tells if the participant does sports or not. The y-axis show's diastolic blood pressure in mm hg. Regular physical activity like sports can result in a lower bloodpressure. This will prevent problems and lower the participant chance of getting hypertension.

![Figure 12: Sports and cholesterol](images/sports_chol.png){alt="Figure 8: Sports and cholesterol" width="800"}

Figure 12 is a boxplot, a boxplot effectively summarizes one or more numeric variables by highlighting key statistical features. The box represents the interquartile range (IQR), which spans the middle 50% of the data between the lower (Q1) and upper (Q3) quartiles, with the line inside indicating the median. Whiskers extend from the box to represent the range of values within 1.5 times the IQR beyond Q1 and Q3, excluding outliers. Any values outside this range are marked as outliers, providing a clear visual of the data's spread and central tendency.

Participating in sports is benificial for a person's general health. Keeping your cholesterol in a healthy range will make sure that optimal hormones are made whilest there aren't any negative side effects like problems with the cardiovascular system. Acording to the NHS the total cholesterol should be below 5 mmol/L, and if you've had a heartattack bellow 4 mmol/L would be optimal.

## Authors {#authors}

-   J.J. Duiker - Github: azzipxonraj

## Version History {#version-history}

-   **0.1**
    -   Initial Release: Interactive plots, filter functionality, and FAQs included.

## License {#license}

This project is licensed under the [MIT License](LICENSE).\
Feel free to use, modify, and distribute this project under the terms of the license.

## Acknowledgments
