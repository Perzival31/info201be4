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
    
    
    ################## Introduction ##########################
    
    output$introparagraph <- renderText({
        paste0("In this project the group took a look at a dataset about game sales. This dataset has quite a bit of information, such as the developer, 
               average review of a game, genre, et cetera. We used the data to look how genre affect sales, if sales was corrolated with review score, the differences
               between how an original game did and its sequal, and total games sold versus year. With all this information we can find what are the important aspects to
               a game to get the most sales"
               
        )
        
        
    })
    
    ################### Sales Vs Review Scores #######################S
    
    output$reviewPlot <- renderPlot({
        
        games <- games %>% 
            filter(input$select == Console)
        
        ggplot(data = games) +
            geom_point(aes(x = Review.Score, y = US.Sales..millions.)) +
            labs(x = "Review Score", y = "US Sales in Millions of Dollars")
    })
    
    output$reviewScoresParagraph <- renderText({
        paste0("This chart shows how review scores affect the overall sales of videogames and allows one to determine if there
               is a correlation between the two. You are able to change which console is being viewed at one time in order
               to compare the data between consoles."
               
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
    
    output$sequelParagraph <- renderText({
        paste0("This chart shows two separate bar charts of the total combined sales of videogames that have sequels and
               videogames that don't have sequels There is also a slider which allows you to change the size of the bars in the bar chart.")
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
        paste0("This chart shows the total sum of all sales of videogames in the US by the genre that the videogame is in.
               There is one chart which shows the sum of all videogame sales and there is another chart which you are able to
               change based on the console that you want to view. This allows you to view the separate consoles and compare it to all
               of the consoles combined sales.")
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
        paste("This page is showing how the year that a video game was released affects the sales that the video game made.
              This will also allow you to select which console you are viewing so you can compare consoles or see the data
              of multiple consoles together.")
    })
    
    
    
    
    
    ################ Conclusion ###########################
    
    output$conclusionParagraph <- renderText({
        HTML(paste("About The Graphs and Charts:", "",
                   "Apart from a possible outlier of the 'Educational, Sports' genre, the highest is the 'Action, Sports' genre. Whether ignoring the outlier or not, the 'Sports' genre is clearly the genre which sells the most games. This data piece was extremely surprising to come across because in popular culture it seems like the most popular games are typically action games, but after looking at the data it is clearly the sports games which dominate the market. This insight might encourage game developers to start development on games for sports which do not already have franchises in them. Obviously there are already the FIFA and Madden series, which is why the sales are so high, but there are countless more sports which do not have games or game series made for them.",
                   "As games tend to get higher review scores, the more that games tend to receive higher sales. There are also many more outliers included with the games with higher review scores as there are a select few games which are able to get much higher sales than the rest of the game. The game with the lowest review score was Elf Bowling 1&2. This game had a review score of 12 out of 100. The game with the highest review score was Super Mario Galaxy 2. This game had a review score of 98 out of 100.",
                   "The total amount of sales in the US starts at 9.77 $ million in 2004. The total amount of sales rose each subsequent year, until the total grows to it's maximum of 213.9 $ million in 2007. The total amount then regressed each following year, falling to a total of 33.79 $ million in the final year, 2010. For individual consoles: The Nintendo DS peaks in 2005, the Sony PSP peaks in 2006, the Nintendo Wii peaks in 2007, the Xbox 306 and Playstation both peak in 2008.",
                   "", "About the Data Set:", "",
                   "The dataset we will be working with is about different video games, characteristics to those video games, and economics to each videogame. The data was collected by Dr. Joe Cox and produced on January 1, 2013. Dr. Cox is lecturer at the Faculty of Business and Law and was given a PhD at the University of Portsmouth. This data was accessed at the Portsmouth Research Portal. This dataset gives unbiased results because there was no bias during sampling and data collection. The data includes the entire population of data about certain videogames and consoles which doesn't allow for bias because the whole population is used.",
                   "", "Future of the Project:", "",
                   "This project could be advanced in many more ways. It could include how the review scores is based on many of the certain categories that are used. This could allow for videogame companies to be able to figure out what makes some videogames more popular than others. Another part of this project that could be advanced is getting more up to date data as our data is a few years old and with technology videogames are changing rapidly and so are the sales/reviews. Finally we could advance the projects by figuring out the least used type of some columns so companies could figure out how to make their videogames different than the majority of others that are on the market.",
                   sep = "<br/>"))
    })
    
})
