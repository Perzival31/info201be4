library(shiny)
library(tidyverse)

games <- read.csv("data.csv")

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Year vs Total Video Game Sales"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
        ),

        # Show a plot of the generated distribution
        mainPanel(
            plotOutput("playerPlot"),
            textOutput("playerParagraph")
        )
    )
))
