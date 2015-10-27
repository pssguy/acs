

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
      

tags$hr(),
menuItem(text="Main Dashboard",href="https://mytinyshinys.shinyapps.io/dashboard",badgeLabel = "Home"),
tags$hr(),

tags$body(
     a(class="addpad",href="https://twitter.com/pssGuy", target="_blank",img(src="images/twitterImage25pc.jpg")),
     a(class="addpad2",href="mailto:agcur@rogers.com", img(src="images/email25pc.jpg")),
     a(class="addpad2",href="https://github.com/pssguy",target="_blank",img(src="images/GitHub-Mark30px.png")),
     a(href="https://rpubs.com/pssguy",target="_blank",img(src="images/RPubs25px.png"))
)

      
    
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
  