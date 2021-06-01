library(shiny)
library(tidyverse)

games <- read.csv("data.csv")
playerData <- games %>%
    select(Console, Title, sales, YearReleased) %>%
    group_by(YearReleased) %>%
    summarise( totalSales = sum(sales) )

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    output$playerPlot <- renderPlot({

        
        
        ggplot(data = playerData) +
            geom_line(aes(x = YearReleased, y = totalSales)) +
            labs(x = "Year", y = "US Sales in Millions of Dollars")

    })
    output$playerParagraph <- renderText({
        paste("The total amount of sales in the US starts at", playerData$totalSales[playerData$YearReleased==2004],
                  "$ million in 2004. The total amount of sales rose each subsequent year, until the total grows to 
              it's maximum of",playerData$totalSales[playerData$YearReleased==2007],
                  "$ million in 2007. The total amount then regressed each following year, falling to a total of",
              playerData$totalSales[playerData$YearReleased==2010],
                  "$ million in the final year, 2010.")
    })
})
