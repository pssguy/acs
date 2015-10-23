
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

cols <- attr(income, "acs.colnames") # user could choose one or all could be displayed ( thogu would make large table) # first is prob total

# combine stae/county/tract into one id
income_df <- data.frame(paste0(str_pad(income@geography$state, 2, "left", pad="0"), 
                               str_pad(income@geography$county, 3, "left", pad="0"), 
                               str_pad(income@geography$tract, 6, "left", pad="0")), 
                        income@estimate[,c("Household Income: Total:",
                                           "Household Income: $200,000 or more")], 
                        stringsAsFactors = FALSE)


income_df <- select(income_df, 1:3)
rownames(income_df)<-1:nrow(income_df)
names(income_df)<-c("GEOID", "total", "over_200")
income_df$percent <- 100*(income_df$over_200/income_df$total)
#NB some tracts have no households

print(glimpse(income_df))

# merge spatial and tabular data in tigris
income_merged<- geo_join(tracts, income_df, "GEOID", "GEOID")
class(income_merged)


# there are some tracts with no land that we should exclude
income_merged <- income_merged[income_merged$ALAND>0,]
# 
# print(names(income_merged))
# county <- theCounties
# print(county)
# print("here we are")
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
  
print("enter map")
 # print(data()$income_merged)
  
  if (is.null(data()$income_merged)) return()
spdf <-data()$income_merged

popup <- paste0("GEOID: ", spdf$GEOID, "<br>", "Percent of Households above $200k: ", round(spdf$percent,2),
                "<br>", "Total Households: ", spdf$total)
pal <- colorNumeric(
  palette = "YlGnBu",
  domain = spdf$percent
)

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
  
map %>%  addPolygons(data = spdf, 
              fillColor = ~pal(percent), 
              color = "#b2aeae", # you need to use hex colors
              fillOpacity = 0.7, 
              weight = 1, 
              smoothFactor = 0.2,
              popup = popup) %>%
  addLegend(pal = pal, 
            values = spdf$percent, 
            position = "bottomright", 
            title = "Percent of Households<br>above $200k",
            labFormat = labelFormat(suffix = "%")) 

})