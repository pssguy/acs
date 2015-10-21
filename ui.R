

dashboardPage(title = "acs",
  skin = "blue",
  dashboardHeader(title = "American Community Survey", titleWidth=400),
  
  dashboardSidebar(
    includeCSS("custom.css"),
#     inputPanel(
#     sliderInput("time",label="Minutes to Repeat",min=1,max=60, value=1),
#     radioButtons("new",NULL,c("New","All"),inline=TRUE)
#     ),
    
    
    
    sidebarMenu(
      id = "sbMenu",
      
      menuItem(
        "Household Income",tabName= "income"
     
      ),
      
      
      menuItem(
        "Other Dashboards",
        
        
        menuSubItem("Climate",href = "https://mytinyshinys.shinyapps.io/climate"),
        menuSubItem("Cricket",href = "https://mytinyshinys.shinyapps.io/cricket"),
        menuSubItem("Mainly Maps",href = "https://mytinyshinys.shinyapps.io/mainlyMaps"),
        menuSubItem("MLB",href = "https://mytinyshinys.shinyapps.io/mlbCharts"),
        
        menuSubItem("World Soccer",href = "https://mytinyshinys.shinyapps.io/worldSoccer")
        
      ),
      menuItem("", icon = icon("twitter-square"),
               href = "https://twitter.com/pssGuy"),
      menuItem("", icon = icon("envelope"),
               href = "mailto:agcur@rogers.com")
      
    
  )),
  dashboardBody(tabItems(
    tabItem("income",
           
                box(
                  width = 4, collapsible = TRUE,collapsed=TRUE,
                  status = "success", solidHeader = TRUE,
                  title = "County Map",
                  DT::dataTableOutput("countyMap") 
                )
            
    )
    
    
    
  ) # tabItems
  ) # body
  ) # page
  