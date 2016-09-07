library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  theme = "style.css",
  
  title = "BUD Flights!",
  
  tags$div(style = "display: flex; flex-direction: column; flex: 1; padding: 12px 12px 12px 12px; background: #A0A0A0",
           
           
           ################
           # Flight slider.
           tags$div(style = "display: flex; flex-direction: column; position: relative; flex: 4; background-image: url('bg_top.png'); background-size: 100% 100%; background-repeat: no-repeat;",
                    
                    
                    #################
                    # Timeline images
                    tags$div(style = "display: flex; position: absolute; top: 0; left: 0; width: 100%; height: 100%; justify-content: flex-end; flex-direction: column; flex: 1;",
                             tags$div(style = "display: flex; flex-direction: row; flex: 9;"),
                             tags$div(style = "display: flex; flex-direction: row; flex: 4; position: relative;",
                                      tags$div(style = "display: flex; flex-direction: row; flex: 2; justify-content: center;"
                                      ),
                                      tags$div(style = "display: flex; flex-direction: row; flex: 1; justify-content: center;",
                                               tags$div(title = "BUD owner change", style = "display: flex; flex: 1; background-image: url('BUD-01.png'); background-size: contain; background-repeat: no-repeat; background-position: center; ")
                                      ),
                                      tags$div(style = "display: flex; flex-direction: row; flex: 3; justify-content: flex-start;",
                                               tags$div(title = "Financial crisis", style = "display: flex; flex: 1; background-image: url('valsag-01.png'); background-size: contain; background-repeat: no-repeat; background-position: center; ")
                                      ),
                                      tags$div(style = "display: flex; flex-direction: row; flex: 4.5; justify-content: center;"
                                      ),
                                      tags$div(title = "Malev bankcruptcy", style = "display: flex; flex-direction: row; flex: 2; position: relative; justify-content: center;",
                                               tags$div(style = "display: flex; flex: 1; background-image: url('mavcsod.png'); background-size: contain; background-repeat: no-repeat; background-position: center; ")
                                      )
                             ),
                             tags$div(style = "display: flex; flex-direction: row; flex: 0.2;")
                    ),
        
                    ##################
                    # Timeline numbers
                    tags$div(style = "display: flex; position: absolute; top: 0; left: 0; width: 100%; justify-content: flex-end; flex-direction: column; flex: 1;",
                             # Year numbers container positioner.
                             tags$div(style = "display: flex; flex-direction: row; width: 100%;",
                                      # Year numbers container.
                                      tags$div(style = "display: flex; flex-direction: row; flex: 1;"),
                                      tags$div(style = "display: flex; flex-direction: row; flex: 16;",
                                               tags$div(style = "display: flex; flex-direction: row; flex: 2; justify-content: center;",
                                                        tags$html("2007")
                                               ),
                                               tags$div(style = "display: flex; flex-direction: row; flex: 2; justify-content: center;",
                                                        tags$html("2008")
                                               ),
                                               tags$div(style = "display: flex; flex-direction: row; flex: 2; justify-content: center;",
                                                        tags$html("2009")
                                               ),
                                               tags$div(style = "display: flex; flex-direction: row; flex: 2; justify-content: center;",
                                                        tags$html("2010")
                                               ),
                                               tags$div(style = "display: flex; flex-direction: row; flex: 2; justify-content: center;",
                                                        tags$html("2011")
                                               ),
                                               tags$div(style = "display: flex; flex-direction: row; flex: 1.5; justify-content: center;",
                                                        tags$html("2012")
                                               )
                                      ),
                                      tags$div(style = "display: flex; flex-direction: row; flex: 1;")
                             )
                    ),
                    
                    #################
                    # Timeline slider
                    tags$div(style = "display: flex; flex-direction: row; flex: 1;",
                             # Actual slider thingy.
                             tags$div(style = "display: flex; flex-direction: row; flex: 1;"),
                             tags$div(style = "display: flex; flex-direction: row; flex: 16;",
                                      sliderInput("slider", "Integer:",
                                                  min=1, max=66, value=0)),
                             tags$div(style = "display: flex; flex-direction: row; flex: 1;")
                    )
           ),
           
           
           ##########################
           # Map and cities container
           tags$div(style = "display: flex; flex-direction: row; flex: 11; background: #FFFFFF; border-width: 3px 0 0 0; border-color: #A0A0A0; border-style: solid;",
                    ##########
                    # Map plot
                    tags$div(style = "display: flex; flex-direction: row; flex: 1; position: relative; position: relative; border-width: 0 3px 0 0; border-color: #A0A0A0; border-style: solid;",
                             plotly::plotlyOutput("distPlot", width = "100%", height = "100%")
                    ),
                    ######################
                    # Destinations boxplot
                    tags$div(style = "display: flex; flex-direction: row; flex: 1;",
                             plotly::plotlyOutput("destinationPlot", width = "100%", height = "100%")
                    )
           ),
           
           
           
           ##################################
           # Trend and seasonality containers
           tags$div(style = "display: flex; flex-direction: row; flex: 14; background: #FFFFFF; border-width: 3px 0 0 0; border-color: #A0A0A0; border-style: solid;",
                    
                    #############
                    # Trend chart
                    tags$div(style = "display: flex; flex-direction: row; flex: 7;",
                             plotly::plotlyOutput("trendPlot", width = "100%", height = "100%")
                    ),
                    
                    ################################################
                    # Minimum and maximum values for trend variables
                    tags$div(style = "display: flex; flex-direction: column; width: 95px;",
                             tags$div(style = "display: flex; flex: 1; flex-direction: column; justify-content: center; align-items: flex-end;",
                                      tags$p(paste("Max: ", as.character(round(max(tsnof_trend$data$trend)))), style = "margin-top: 4px; margin-bottom: 0;"),
                                      tags$p(paste("Min: ", as.character(round(min(tsnof_trend$data$trend)))), style = "margin: 0;")
                             ),
                             tags$div(style = "display: flex; flex: 1;  flex-direction: column; justify-content: center; align-items: flex-end;",
                                      tags$p(paste("Max: ", as.character(round(max(tsscpf_trend$data$trend)))), style = "margin-top: 4px; margin-bottom: 0;"),
                                      tags$p(paste("Min: ", as.character(round(min(tsscpf_trend$data$trend)))), style = "margin: 0;")
                             ),
                             tags$div(style = "display: flex; flex: 1; flex-direction: column; justify-content: center; align-items: flex-end;",
                                      tags$p(paste("Max: ", as.character(round(max(tsssk_trend$data$trend)/1000000)), " Mkm"), style = "margin-top: 4px; margin-bottom: 0;"),
                                      tags$p(paste("Min: ", as.character(round(min(tsssk_trend$data$trend)/1000000)), " Mkm"), style = "margin: 0;")
                             ),
                             tags$div(style = "display: flex; flex: 1; flex-direction: column; justify-content: center; align-items: flex-end;",
                                      tags$p(paste("Max: ", as.character(round(max(tswsk_trend$data$trend)/1000000)), " Mkm"), style = "margin-top: 4px; margin-bottom: 0;"),
                                      tags$p(paste("Min: ", as.character(round(min(tswsk_trend$data$trend)/1000000)), " Mkm"), style = "margin: 0;")
                             )
                    ),
                    
                    #########################
                    # Pictograms of variables
                    tags$div(style = "display: flex; flex-direction: column; width: 95px;",
                             # Column for pictograms of variables.
                             tags$div(title = "Flights\nMalev bankruptcy is a clearly distinguishable, unpredictable event.\nBefore the bankruptcy: very clear seasonality,\ntrend correlates with the global economy.", style = "display: flex; flex: 1; background-image: url('sum_flight.png'); background-size: contain; background-repeat: no-repeat; background-position: center; "),
                             tags$div(title="Seat capacity per flight\nMalev bankruptcy correlates with a sudden surge\nin the increase of the average seat capacity. There is\nalso strong seasonality.", style = "display: flex; flex: 1; background-image: url('average_size.png'); background-size: contain; background-repeat: no-repeat; background-position: center; "),
                             tags$div(title="Seat km served\nThe average seat kilometers shows very strong seasonality.\nThe trend is insignificant in absolute terms.\nThe Malev bankruptcy seems to have no apparent effect\nas it happened in the usually weakest period of the business year.", style = "display: flex; flex: 1; background-image: url('seatkm.png'); background-size: contain; background-repeat: no-repeat; background-position: center; "),
                             tags$div(title="Wasted seat km\nStrong seasonality - people not flying a lot in January?\nThe effect of malev bankruptcy is debatable, but the\nindustry is clearly getting ever more efficient, shown by less wasted kms.", style = "display: flex; flex: 1; background-image: url('wastedkm.png'); background-size: contain; background-repeat: no-repeat; background-position: center; ")
                    ),
                    
                    ###################
                    # Seasonality chart
                    tags$div(style = "display: flex; flex-direction: row; flex: 7;",
                             # Seasonality chart.
                             plotly::plotlyOutput("seasonalityPlot", width = "100%", height = "100%")
                    )
           ),
           
           
           ##################
           # Footer component
           tags$div(style = "display: flex; flex-direction: row; flex: 2; background: #FFFFFF;",
                    tags$div(style = "display: flex; flex: 8; flex-direction: row; align-items: stretch; margin: 1px 4px;",
                             tags$div(style = "display: flex; flex: 1; background-image: url('satrday.png'); background-size: contain; background-repeat: no-repeat; background-position: center; ",
                                      tags$a(href="http://satrdays.org/", style = "width: 100%; height: 100%;")
                             ),
                             tags$div(style = "display: flex; flex: 0.1;"),
                             tags$div(style = "display: flex; flex: 3; background-image: url('quanopt_logo.png'); background-size: contain; background-repeat: no-repeat; background-position: center; ",
                                        tags$a(href="http://www.quanopt.com", style = "width: 100%; height: 100%;")
                                        
                             ),
                             tags$div(style = "display: flex; flex: 8.9;"),
                             # tags$div(style = "display: flex; flex: 2; background-image: url('mavcsod.png'); background-size: contain; background-repeat: no-repeat; background-position: center; "),
                             tags$div(style = "display: flex; flex: 3;")
                    ),
                    tags$div(style = "display: flex; flex: 4; flex-direction: column; align-items: center; justify-content: flex-end; text-align: center; font-weight: bold;",
                             tags$p("Hover over the icons", style = "margin-top: 4px; margin-bottom: 0;", tags$br(), "to see our findings!")
                    ),
                    tags$div(style = "display: flex; flex: 8;",
                             tags$div(style = "display: flex; flex: 3; background-image: url('spring.png'); background-size: contain; background-repeat: no-repeat; background-position: flex-start; "),
                             tags$div(style = "display: flex; flex: 3; background-image: url('summer.gif'); background-size: contain; background-repeat: no-repeat; background-position: flex-start; "),
                             tags$div(style = "display: flex; flex: 3; background-image: url('autumn.png'); background-size: contain; background-repeat: no-repeat; background-position: flex-start; "),
                             tags$div(style = "display: flex; flex: 0.25;"),
                             tags$div(style = "display: flex; flex: 1; background-image: url('christmas.gif'); background-size: contain; background-repeat: no-repeat; background-position: flex-start; "),
                             tags$div(style = "display: flex; flex: 1; background-image: url('winter.png'); background-size: contain; background-repeat: no-repeat; background-position: flex-start; "),
                             tags$div(style = "display: flex; flex: 0.25;")
                    )
           )
  ),
  
  tags$head(tags$script(src="script.js"))
))