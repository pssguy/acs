
#sprint("house") # conrims come her for processing

data <- eventReactive(input$button,{
  

 if (input$county!="All") {
  theCounties <-input$county

  
countyCodes <-  fips_codes %>% 
    filter(state_name==input$state&county %in% theCounties) %>% 
    select(county_code) 

tracts <- tracts(state = input$state, county = theCounties, cb=TRUE)

 } else {
   print("all called")
   countyCodes <-  fips_codes %>% 
     filter(state_name==input$state) %>% 
     select(county_code)
   
   tracts <- tracts(state = input$state, county = NULL, cb=TRUE)
  
 }
countyCodes <- as.numeric(countyCodes$county_code)
print(countyCodes)

  


geo<-geo.make(state=input$state,
              county=countyCodes, tract="*")


income<-acs.fetch(endyear = 2013, span = 5, geography = geo,
                  table.number = "B19001", col.names = "pretty")




income_df <- data.frame(income@estimate, GEOID=paste0(str_pad(income@geography$state, 2, "left", pad="0"), 
                                                      str_pad(income@geography$county, 3, "left", pad="0"), 
                                                      str_pad(income@geography$tract, 6, "left", pad="0")),
                        stringsAsFactors = FALSE) 

#write_csv(income_df,"prob.csv")
income_df$tract <-row.names(income_df) # now just 1,2 etc?
income_df$tract <- str_replace(income_df$tract,"Census ","")



income_df$high_pc <- round(100*(income_df[17]/income_df[1]),1)[,1]
income_df$low_pc <- round(100*((income_df[2]+income_df[3]+income_df[4])/income_df[1]),1)[,1]
income_df$low_count <- (income_df[2]+income_df[3]+income_df[4])[,1]
income_df$av <- 1000*round((5*income_df[2]+
                              
                              12.5*income_df[3]+
                              17.5*income_df[4]+
                              22.5*income_df[5]+
                              27.5*income_df[6]+
                              32.5*income_df[7]+
                              37.5*income_df[8]+
                              42.5*income_df[9]+
                              47.5*income_df[10]+
                              55*income_df[11]+
                              67.5*income_df[12]+
                              87.5*income_df[13]+
                              112.5*income_df[14]+
                              137.5*income_df[15]+
                              175*income_df[16]+
                              250*income_df[17])/income_df[1],0)[,1]

df <- income_df %>% 
  select(tract,high_pc,low_pc,av,GEOID,high_count=17,low_count,total=1)


income_merged<- geo_join(tracts, df, "GEOID", "GEOID")


# there are some tracts with no land that we should exclude
income_merged <- income_merged[income_merged$ALAND>0,]

info=list(income_merged=income_merged)#,county=county)
  #info=list(county=county)
return(info)

})




output$countyMap <- renderLeaflet({

  
  if (is.null(data()$income_merged)) return()
  # simplify for subsequent processing
income_merged <-data()$income_merged
df <- data()$income_merged@data

## Map options

if (input$map=="CartoDB.Positron") {
  
  map<-leaflet() %>% 
    addProviderTiles("CartoDB.Positron") 
} else if (input$map=="MapQuestOpen.Aerial") {
  map<-leaflet() %>% 
    addProviderTiles("MapQuestOpen.Aerial")
} else {
  print("default")
  map<-leaflet() %>% 
    addTiles()
}

if (input$income=="% >200k") {
popup <- paste0(df$tract, "<br>", "Percent of Households above $200k: ", df$high_pc,
                "<br>", "Total Households: ", df$total)

pal <- colorNumeric(
  palette = "YlGnBu",
  domain = df$high_pc
)



  
map %>%  addPolygons(data = income_merged, 
              fillColor = ~pal(high_pc), 
              color = "#b2aeae", # you need to use hex colors
              fillOpacity = 0.7, 
              weight = 1, 
              smoothFactor = 0.2,
              popup = popup) %>%
  addLegend(pal = pal, 
            values = df$high_pc, 
            position = "bottomright", 
            title = "Percent of Households<br>above $200k",
            labFormat = labelFormat(suffix = "%")) 
} else if (input$income=="% <20k") {
  popup <- paste0(df$tract, "<br>", "Percent of Households below $20k: ", df$low_pc,
                  "<br>", "Total Households: ", df$total)
 
  pal <- colorNumeric(
    palette = "YlGnBu",
    domain = df$low_pc
  )
  
  
  
  
  map %>%  addPolygons(data = income_merged, 
                       fillColor = ~pal(low_pc), 
                       color = "#b2aeae", # you need to use hex colors
                       fillOpacity = 0.7, 
                       weight = 1, 
                       smoothFactor = 0.2,
                       popup = popup) %>%
    addLegend(pal = pal, 
              values = df$low_pc, 
              position = "bottomright", 
              title = "Percent of Households<br>below $20k",
              labFormat = labelFormat(suffix = "%"))
} else {
  popup <- paste0(income_merged$tract, "<br>", "Estimated Av Income : $", income_merged$av,
                  "<br>", "Total Households: ", income_merged$total)
 
  pal <- colorNumeric(
    palette = "YlGnBu",
    domain = df$av
  )
  
  
  
  
  map %>%  addPolygons(data = income_merged, 
                       fillColor = ~pal(av), 
                       color = "#b2aeae", # you need to use hex colors
                       fillOpacity = 0.7, 
                       weight = 1, 
                       smoothFactor = 0.2,
                       popup = popup) %>%
    addLegend(pal = pal, 
              values = income_merged$av, 
              position = "bottomright", 
              title = "Estimated Av Income $")
     
}

})