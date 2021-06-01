library(shiny)
library(tidyverse)

games <- read.csv("data.csv")


# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    output$playerPlot <- renderPlot({

        consoleData <- games %>%
            select(Console, Title, sales, YearReleased) %>%
            filter(Console %in% input$selectedConsole) %>%
            group_by(YearReleased) %>%
            summarise(Console, totalSales = sum(sales) )

        
        ggplot(data = consoleData) +
            geom_line(aes(x = YearReleased, y = totalSales)) +
            labs(x = "Year", y = "US Sales in Millions of Dollars")

    })
    output$playerParagraph <- renderText({
        playerData <- games %>%
            select(Console, Title, sales, YearReleased) %>%
            group_by(YearReleased) %>%
            summarise( totalSales = sum(sales) )
        paste("The total amount of sales in the US starts at", playerData$totalSales[playerData$YearReleased==2004],
                  "$ million in 2004. The total amount of sales rose each subsequent year, until the total grows to 
              it's maximum of",playerData$totalSales[playerData$YearReleased==2007],
                  "$ million in 2007. The total amount then regressed each following year, falling to a total of",
              playerData$totalSales[playerData$YearReleased==2010],
                  "$ million in the final year, 2010. For individual consoles: The Nintendo DS peaks in 2005,
              the Sony PSP peaks in 2006, the Nintendo Wii peaks in 2007, the Xbox 306 and Playstation both peak in 2008.")
    })
})
