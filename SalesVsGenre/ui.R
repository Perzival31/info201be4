library(shiny)
library(tidyverse)

games <- read.delim("Managerial_and_Decision_Economics_2013_Video_Games_Dataset.csv", sep = ",")
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Sales Vs. Genre"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("select", label = h3("Select the Console of Choice"), 
                  choices = unique(games$Console), 
                  selected = 1),
    ),
    
    mainPanel(
      plotOutput("distPlot"),
      plotOutput("overallPlot"), 
      textOutput("paragraph")
    )
  )
))
