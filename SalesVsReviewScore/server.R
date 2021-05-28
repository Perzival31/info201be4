library(shiny)
library(tidyverse)

games <- read.delim("Managerial_and_Decision_Economics_2013_Video_Games_Dataset.csv", sep = ",") %>% 
    select(sales, review.score, Title) %>% 
    arrange(review.score)

print(head(games, 3))
print(tail(games, 3))

shinyServer(function(input, output) {
    
    output$distPlot <- renderPlot({

        ggplot(data = games) +
            geom_point(aes(x = review.score, y = sales)) +
            labs(x = "Review Score", y = "US Sales in Millions of Dollars")
    })
    
    output$paragraph <- renderText({
        paste0("As games tend to get higher review scores, the more that games tend to receive higher sales.
               There are also many more outliers included with the games with higher review scores as there
               are a select few games which are able to get much higher sales than the rest of the game.",
               " The game with the lowest review score was ", head(games$Title, 1),
               ". This game had a review score of ", head(games$review.score, 1), " out of 100.
               The game with the highest review score was ", tail(games$Title, 1),
               ". This game had a review score of ", tail(games$review.score, 1), " out of 100."
               
        )

                        
    })

})
