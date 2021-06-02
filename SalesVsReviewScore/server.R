library(shiny)
library(tidyverse)
library(ggplot2)

allGames <- read.delim("Managerial_and_Decision_Economics_2013_Video_Games_Dataset.csv", sep = ",")

games <- allGames%>% 
    select(US.Sales..millions., Review.Score, Title, Console) %>% 
    arrange(Review.Score)

onlysequel <- filter(allGames, Sequel == 1)
notsequel <- filter(allGames, Sequel == 0)

gameGenres <- allGames %>% 
    select(US.Sales..millions., Genre, Title, Console) %>% 
    arrange(Genre)

shinyServer(function(input, output) {
    
    
################### Sales Vs Review Scores #######################
    
    output$reviewPlot <- renderPlot({

        games <- games %>% 
            filter(input$select == Console)
        
        ggplot(data = games) +
            geom_point(aes(x = Review.Score, y = US.Sales..millions.)) +
            labs(x = "Review Score", y = "US Sales in Millions of Dollars")
    })
    
    output$reviewScoresParagraph <- renderText({
        paste0("As games tend to get higher review scores, the more that games tend to receive higher sales.
               There are also many more outliers included with the games with higher review scores as there
               are a select few games which are able to get much higher sales than the rest of the game.",
               " The game with the lowest review score was ", head(games$Title, 1),
               ". This game had a review score of ", head(games$Review.Score, 1), " out of 100.
               The game with the highest review score was ", tail(games$Title, 1),
               ". This game had a review score of ", tail(games$Review.Score, 1), " out of 100."
               
        )

                        
    })
    
    
    ################### Sales Vs Sequels #######################
    
    output$notSequelsalesPlot <- renderPlot({
        # generate bins based on input$bins from ui.R
        
        plot <- ggplot(notsequel, aes_string(x = notsequel$US.Sales..millions.)) + 
            geom_histogram(binwidth = input$bins, color="darkblue", fill = "lightblue") +
            ggtitle("Not Sequel Sales") + 
            xlab("Games")
        plot
    })
    
    output$onlySequelsalesPlot <- renderPlot({
        # generate bins based on input$bins from ui.R
        
        plot <- ggplot(onlysequel, aes_string(x = onlysequel$US.Sales..millions.)) + 
            geom_histogram(binwidth = input$bins, color="red", fill = "pink") + 
            ggtitle("Sequel Sales") + 
            xlab("Games")
        plot
    })
    
    
    ################### Genre and Mean Sales #######################
    
    output$overallPlot <- renderPlot({
        
        average <- gameGenres %>% group_by(Genre) %>% 
            summarize(Sales.Mean = mean(US.Sales..millions.)) %>% 
            arrange(Sales.Mean)
        
        ggplot(data = average) +
            geom_point(aes(x = Genre, y = Sales.Mean)) +
            labs(title = "For Every Console", x = "Genre", y = "Mean US Sales in Millions of Dollars") +
            theme(text = element_text(size=10),
                  axis.text.x = element_text(angle=90, hjust=1, size=5))
        
    })
    
    output$distPlot <- renderPlot({
        
        gameGenres <- gameGenres %>% filter(input$select == Console)
        
        average <- gameGenres %>% group_by(Genre) %>% 
            summarize(Sales.Mean = mean(US.Sales..millions.)) %>% 
            arrange(Sales.Mean)
        
        ggplot(data = average) +
            geom_point(aes(x = Genre, y = Sales.Mean)) +
            labs(title = "By Console", x = "Genre", y = "Mean US Sales in Millions of Dollars") +
            theme(text = element_text(size=10),
                  axis.text.x = element_text(angle=90, hjust=1, size=5)) 
        
    })
    
    output$paragraph <- renderText({
        paste0("paragraph")
    })
    
    
############### Sales Vs Year Released ##################
    
    output$playerPlot <- renderPlot({
        
        consoleData <- allGames %>%
            select(Console, Title, US.Sales..millions., YearReleased) %>%
            filter(Console %in% input$selectedConsole) %>%
            group_by(YearReleased) %>%
            summarise(Console, totalSales = sum(US.Sales..millions.) )
        
        
        ggplot(data = consoleData) +
            geom_line(aes(x = YearReleased, y = totalSales)) +
            labs(x = "Year", y = "US Sales in Millions of Dollars")
        
    })
    
    output$playerParagraph <- renderText({
        playerData <- allGames %>%
            select(Console, Title, US.Sales..millions., YearReleased) %>%
            group_by(YearReleased) %>%
            summarise( totalSales = sum(US.Sales..millions.) )
        paste("The total amount of sales in the US starts at", playerData$totalSales[playerData$YearReleased==2004],
              "$ million in 2004. The total amount of sales rose each subsequent year, until the total grows to 
              it's maximum of",playerData$totalSales[playerData$YearReleased==2007],
              "$ million in 2007. The total amount then regressed each following year, falling to a total of",
              playerData$totalSales[playerData$YearReleased==2010],
              "$ million in the final year, 2010. For individual consoles: The Nintendo DS peaks in 2005,
              the Sony PSP peaks in 2006, the Nintendo Wii peaks in 2007, the Xbox 306 and Playstation both peak in 2008.")
    })

})
