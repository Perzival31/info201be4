#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
library(ggplot2)

gamedata <- read.csv("Managerial_and_Decision_Economics_2013_Video_Games_Dataset.csv")

onlysequel <- filter(gamedata, Sequel == 1)
notsequel <- filter(gamedata, Sequel == 0)

# Define UI for application that draws a graph
ui <- fluidPage(

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
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    
    output$notSequelsalesPlot <- renderPlot({
        # generate bins based on input$bins from ui.R

    plot <- ggplot(notsequel, aes_string(x = notsequel$sales)) + geom_histogram(binwidth = input$bins, color="darkblue", fill = "lightblue") + ggtitle("Not Sequel Sales") + xlab("Games")
    plot
    })
    output$onlySequelsalesPlot <- renderPlot({
        # generate bins based on input$bins from ui.R
        
        plot <- ggplot(onlysequel, aes_string(x = onlysequel$sales)) + geom_histogram(binwidth = input$bins, color="red", fill = "pink") + ggtitle("Sequel Sales") + xlab("Games")
        plot
    })
}


# Run the application 
shinyApp(ui = ui, server = server)
