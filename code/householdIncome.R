
#sprint("house") # conrims come her for processing

data <- eventReactive(input$button,{
  

 if (input$county!="All") {
  theCounties <-input$county

  
countyCodes <-  fips_codes %>% 
    filter(state_name==input$state&county %in% theCounties) %>% 
    select(county_code) 

tracts <- tracts(state = input$state, county = theCounties, cb=TRUE)

 } else {
   countyCodes <-  fips_codes %>% 
     filter(state_name==input$state) %>% 
     select(county_code)
   
   tracts <- tracts(state = input$state, county = NULL, cb=TRUE)
   #tracts <- tracts(state = "Arizona", county = NULL, cb=TRUE) appears to work
 }
countyCodes <- as.numeric(countyCodes$county_code)
print(countyCodes)

  


geo<-geo.make(state=input$state,
              county=countyCodes, tract="*")


income<-acs.fetch(endyear = 2012, span = 5, geography = geo,
                  table.number = "B19001", col.names = "pretty")

# cols <- attr(income, "acs.colnames") # user could choose one or all could be displayed ( thogu would make large table) # first is prob total
# 
# # combine stae/county/tract into one id - prob not best approach
# if (input$income=="% >200k") {
# income_df <- data.frame(paste0(str_pad(income@geography$state, 2, "left", pad="0"), 
#                                str_pad(income@geography$county, 3, "left", pad="0"), 
#                                str_pad(income@geography$tract, 6, "left", pad="0")), 
#                         income@estimate[,c("Household Income: Total:",
#                                            "Household Income: $200,000 or more")], 
#                         stringsAsFactors = FALSE)
# 
# 
# income_df <- select(income_df, 1:3)
# rownames(income_df)<-1:nrow(income_df)
# names(income_df)<-c("GEOID", "total", "over_200")
# income_df$percent <- 100*(income_df$over_200/income_df$total)
# #NB some tracts have no households
# }
# print(glimpse(income_df))
# 
# # merge spatial and tabular data in tigris
# income_merged<- geo_join(tracts, income_df, "GEOID", "GEOID")
# class(income_merged)
# 
# 
# # there are some tracts with no land that we should exclude
# income_merged <- income_merged[income_merged$ALAND>0,]
# # 
# # print(names(income_merged))
# # county <- theCounties
# # print(county)
# # print("here we are")


income_df <- data.frame(income@estimate, GEOID=paste0(str_pad(income@geography$state, 2, "left", pad="0"), 
                                                      str_pad(income@geography$county, 3, "left", pad="0"), 
                                                      str_pad(income@geography$tract, 6, "left", pad="0")),
                        stringsAsFactors = FALSE) 
print("1")
print(glimpse(income_df))
print(names(income_df))
print(str(income_df))
write_csv(income_df,"prob.csv")
income_df$tract <-row.names(income_df) # now just 1,2 etc?
income_df$tract <- str_replace(income_df$tract,"Census ","")

# names(income_df)
# income_df_high <- 100*(income_df$over_200/income_df$total)

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
names(income_df)
#glimpse(income_df)
df <- income_df %>% 
  select(tract,high_pc,low_pc,av,GEOID,high_count=17,low_count,total=1)
# glimpse(df)
# df <income_df
# 
# colnames(df) <- c("tract","high_pc","low_pc","av","GEOID","high_count","low_count","total")

tracts <- tracts(state = input$state, county = input$county, cb=TRUE)

income_merged<- geo_join(tracts, df, "GEOID", "GEOID")
#class(income_merged)
print("OK")

# there are some tracts with no land that we should exclude
income_merged <- income_merged[income_merged$ALAND>0,]
print("income_merged@data")
print(glimpse(income_merged@data))
print("ok")
info=list(income_merged=income_merged)#,county=county)
  #info=list(county=county)
return(info)

})

# output$test <- renderText({
#   if (is.null(input$county)) return()
#   data()$county
# })

# create map (I replaced income_merged$id (non-existent)with income_merged$GEOID but does not mwean much unless they have names )

output$countyMap <- renderLeaflet({

  
  if (is.null(data()$income_merged)) return()
income_merged <-data()$income_merged
df <- data()$income_merged@data
print(str(df))
print(class(income_merged))


print("income_mergeddata in map")
print(glimpse(income_merged@data))

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
print(popup)
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
  print(popup)
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
  print(popup)
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