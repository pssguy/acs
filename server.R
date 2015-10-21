


shinyServer(function(input, output,session) {

  
  ## countyOptions
  
  output$a <- renderUI({
  #  print(input$state)
    countyChoice <- fips_codes %>% 
      filter(state_name == input$state) %>% 
      .$county
    
   # print(countyChoice)
    
    selectInput("county","Choice(s)", c("Choose Counties"="", countyChoice), selected=c("Dale County"),multiple = T) 
  })
  
  # code for individual tabs
  source("code/householdIncome.R", local = TRUE)
  
  
  
 
  
})