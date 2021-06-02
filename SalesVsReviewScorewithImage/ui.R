library(shiny)
library(tidyverse)

games <- read.delim("Managerial_and_Decision_Economics_2013_Video_Games_Dataset.csv", sep = ",")
shinyUI(fluidPage(navbarPage("Video Game Sales",

                                
        
    
        tabPanel(
        # Application title
        titlePanel("Intro"),

    
            

            mainPanel(
                
                img(src = "gaming.png", height = 200, width = 300),
                textOutput("introparagraph")
                
            )
        
    ),
    
    
    
    tabPanel(
        "Sales Versus Sequal Sales",
        # Application title
        titlePanel("Sales Versus Sequal Sales"),
        
        # Sidebar with a slider input for number of bins 
        sidebarLayout(
            sidebarPanel(
                sliderInput("bins",
                            "Number of bins:",
                            min = 0.25,
                            max = 5,
                            value = 1)
            ),
            
            # Show a plot of the generated distribution
            mainPanel(
                plotOutput("notSequelsalesPlot"),
                plotOutput("onlySequelsalesPlot")
            )
        )
    ),
    
    tabPanel(
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
    )
    )
))
