#IMPORT
list.of.packages <- c("shiny", "plotly", "ggmap", "zoo", "geosphere", "xlsx")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages))install.packages(new.packages, repos = "http://cran.us.r-project.org")

lapply(list.of.packages, library, character.only = TRUE)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  dataCache <- data
  dataCache$DATE <- as.numeric(dataCache$DATE)
  
  output$trendPlot <- renderPlotly({
    add_trace(trend_plot, x=c(as.POSIXct(as.Date(as.yearmon(tsnof_trend$time)))[input$slider],as.POSIXct(as.Date(as.yearmon(tsnof_trend$time)))[input$slider]), y=c(0,100), line = list(color = "rgb(255,255,255)", width = 2))
  })
  output$seasonalityPlot <- renderPlotly({
    dzs <- (input$slider-2) %% 12
    if(dzs == 0) dzs <- 12
    add_trace(seasonality_plot, x=c(months[dzs],months[dzs]), y=c(0,100), line = list(color = "rgb(255,255,255)", width = 2))
  })
  output$destinationPlot <- renderPlotly({
    x <- input$slider
    destinations_tmp <- plot_ly(x = agg_country_list[[input$slider]][[1]], y = agg_country_list[[input$slider]][[2]], type = "bar", marker = list(color = "rgb(255,194,14)"))
    destinations_tmp <- layout(destinations_tmp, showlegend = FALSE, xaxis = list(title = "", showgrid = F),  yaxis = list(title = "", showgrid = F))
  })
  
  output$distPlot <- renderPlotly({
    # marker styling
    m <- list(
      colorbar = list(title = "Flights"),
      size = 4, opacity = 0.8, symbol = 'circle'
    )
    
    # geo styling
    g <- list(
      scope = 'world',
      showland = TRUE,
      showlakes = TRUE,
      landcolor = toRGB("gray95"),
      countrycolor = toRGB("white"),
      lakecolor = toRGB("white"),
      countrywidth = 0.75,
      showcountries = TRUE
    )
    p <- plot_ly(data,
                 lat   = lat[data$DATE      == datesHelper$date[datesHelper$seqNo == input$slider]],
                 lon   = lon[data$DATE      == datesHelper$date[datesHelper$seqNo == input$slider]],
                 text  = DESTINATION[data$DATE     == datesHelper$date[datesHelper$seqNo == input$slider]],
                 color = NBR.OF.FLIGHTS[data$DATE == datesHelper$date[datesHelper$seqNo == input$slider]],
                 type = 'scattergeo', locationmode = 'USA-states', mode = 'markers',
                 marker = m ) %>%
      layout(geo = g)
    
  })
})

p <- layout(p, list(type = "line", 
                    fillcolor = "rgb(255,194,14)", line = list(color = "rgb(255,194,14)"),
                    opacity = 0.3, x0 = 2, x1 = 2,
                    xref = "x", y0 = 0, y1 = 5, yref = "y"))

p <- plot_ly(x = c(1, 2, 3, 4), y = c(0, 2, 3, 5), fill = "tozeroy")
p <- add_trace(p, x = c(1, 2, 3, 4), y = c(3, 5, 1, 7), fill = "tonexty")
p <- add_trace(x=c(2,2), y=c(0,7), mode = "lines")
