
library(shiny)
library(tidyverse)

games <- read.delim("Managerial_and_Decision_Economics_2013_Video_Games_Dataset.csv", sep = ",") %>% 
  select(US.Sales..millions., Genre, Title, Console) %>% 
  arrange(Genre)

print(head(average, 3))
print(tail(average, 4))

shinyServer(function(input, output) {
  
  output$overallPlot <- renderPlot({
    
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
    paste0("paragraph")
    
    
  })
  
})

