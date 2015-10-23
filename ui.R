

dashboardPage(title = "acs",
  skin = "blue",
  dashboardHeader(title = "American Community Survey", titleWidth=400),
  
  dashboardSidebar(
    includeCSS("custom.css"),
    inputPanel(
    selectInput("state","Choose State",c("Choose State"="", stateChoice), multiple=FALSE),
    uiOutput("a"),
    radioButtons("map","Choose Map",c("CartoDB.Positron","MapQuestOpen.Aerial"),inline=T),
 
  actionButton("button", "Obtain Map")
    ),
 
    
    
    
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
                  width = 12, collapsible = TRUE,collapsed=FALSE,
                  status = "success", solidHeader = TRUE,
                  title = "County Map (Response time depends on Number of Counties chosen)",
               #   textOutput("test"),
                  leafletOutput("countyMap") 
                )
            
    )
    
    
    
  ) # tabItems
  ) # body
  ) # page
  