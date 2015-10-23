


shinyServer(function(input, output,session) {

  
  ## countyOptions
  
  output$a <- renderUI({
  #  print(input$state)
    countyChoice <- fips_codes %>% 
      filter(state_name == input$state) %>% 
      .$county
    countyChoice <- c("All", countyChoice)
    
    selectInput("county","Choose Countie(s)",  countyChoice,multiple = T)
  })
  
  # code for individual tabs
  source("code/householdIncome.R", local = TRUE)
  
  
  
 
  
})