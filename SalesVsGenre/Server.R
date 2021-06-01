
library(shiny)
library(tidyverse)

games <- read.delim("Managerial_and_Decision_Economics_2013_Video_Games_Dataset.csv", sep = ",") %>% 
  select(US.Sales..millions., Genre, Title, Console) %>% 
  arrange(Genre)

shinyServer(function(input, output) {
  
  output$overallPlot <- renderPlot({
    
    average <- games %>% group_by(Genre) %>% summarize(Sales.Mean = mean(US.Sales..millions.)) %>% arrange(Sales.Mean)
    
    ggplot(data = average) +
      geom_point(aes(x = Genre, y = Sales.Mean)) +
      labs(title = "For Every Console", x = "Genre", y = "Mean US Sales in Millions of Dollars") +
      theme(text = element_text(size=10),
            axis.text.x = element_text(angle=90, hjust=1, size=5))
  
  })
  output$distPlot <- renderPlot({
     
    games <- games %>% filter(input$select == Console)
    
    average <- games %>% group_by(Genre) %>% summarize(Sales.Mean = mean(US.Sales..millions.)) %>% arrange(Sales.Mean)
    
     ggplot(data = average) +
       geom_point(aes(x = Genre, y = Sales.Mean)) +
       labs(title = "By Console", x = "Genre", y = "Mean US Sales in Millions of Dollars") +
       theme(text = element_text(size=10),
             axis.text.x = element_text(angle=90, hjust=1, size=5)) 
    
  })
  
  output$paragraph <- renderText({
    paste("Apart from an obvious outliar of games with the '", tail(average$Genre, 1), 
          "' genre (there are only 3 in a almost 2000 piece data set), the games with the 'Action, Sports' were the next highest overall.", 
          " This page also shows the highest selling genre per console, based on the selection made. "
           )
    
    
  })
  
})

