

dashboardPage(title = "acs",
  skin = "blue",
  dashboardHeader(title = "American Community Survey", titleWidth=400),
  
  dashboardSidebar(
    includeCSS("custom.css"),
    inputPanel(
    selectInput("state",label = NULL,c("Choose State"="", stateChoice), multiple=FALSE),
    uiOutput("a"),
    radioButtons("income","Income Category",c("% >200k","% <20k","Approx Mean"),inline=T),
    radioButtons("map","Map",c("OpenStreetMap","CartoDB.Positron","MapQuestOpen.Aerial")),
 
  actionButton("button", "Obtain Map")
    ),
 
    
    
    
    sidebarMenu(
      id = "sbMenu",
      
      menuItem(
        "Household Income",tabName= "income"
     
      ),
      
      menuItem("Info", tabName = "info", icon = icon("info")),
      
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
            
    ),
    tabItem("info", includeMarkdown("info.md"))
    
    
    
  ) # tabItems
  ) # body
  ) # page
  