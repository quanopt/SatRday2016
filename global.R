library(shiny)
library(ggmap)
library(zoo)
library(geosphere)
library(xlsx)

data <- NULL
if(c(file.exists("BUD flights 2007-2012 v2.csv")) == c(TRUE)) {
  # Dataset converted to csv previously.
  data <- read.csv("BUD flights 2007-2012 v2.csv", header=TRUE, stringsAsFactors=FALSE, encoding = "UTF-8",
                   colClasses = c("character", "character", "character", "character", "character", "character",
                                  "character", "character", "integer", "character", "character", "integer",
                                  "integer", "integer", "integer"))
} else {
  # Read in original dataset
  data <- read.xlsx("BUD flights 2007-2012 v2.xlsx", sheetName="Liszt_Ferenc_data")
}

data$fullLocation <- paste(data$CITY, data$REGION, data$COUNTRY, sep = " ")

locationCache <- NULL
if(c(file.exists("locationCache.csv")) == c(TRUE)) {
  locationCache <- read.csv("locationCache.csv", encoding = "UTF-8")
  locationCache$city <- as.character(locationCache$city)
} else {
  locationCache <- as.data.frame(unique(data$fullLocation), stringsAsFactors = FALSE)
  colnames(locationCache) <- c("city")
  
  locationCache <- locationCache[locationCache$city != "" && !is.na(locationCache$city)]
  
  locationCache$lat <- 0
  locationCache$lon <- 0
  for (i in seq(1, length(locationCache$city))) {
    cityAscii <- iconv(locationCache$city[i], to='ASCII//TRANSLIT')
    tmp <- ggmap::geocode(cityAscii, output = "latlon")
    locationCache$lat[i] <- tmp$lat
    locationCache$lon[i] <- tmp$lon
  }
  which(is.na(locationCache$lat))
  which(is.na(locationCache$lon))
  ## Only use if these locations are not found by google maps
  incirlik <- which(locationCache$city == "Incirlik Air Base  Turkey")
  locationCache$lat[incirlik] <- 37.000633
  locationCache$lon[incirlik] <- 35.423292
  ube <- which(locationCache$city == "Ube Japan RJ Japan")
  locationCache$lat[ube] <- 33.9330182
  locationCache$lon[ube] <- 131.2750353
  kansai <- which(locationCache$city == "Kansai Japan RJ Japan")
  locationCache$lat[kansai] <- 40.5261935
  locationCache$lon[kansai] <- 141.4492798
  which(is.na(locationCache$lat))
  which(is.na(locationCache$lon))
  
  # Location data has been supposedly loaded by this point
  budapestLat <- 47.4384587
  budapestLon <- 19.2501071
  p1 <- c(budapestLon, budapestLat)
  locationCache$distance <- 0
  
  for (i in seq(1, length(locationCache$city))) {
    if(!is.na(locationCache$lon) && !is.na(locationCache$lat)) {
      p2 <- c(locationCache$lon[i], locationCache$lat[i])
      locationCache$distance[i] <- distm(p1, p2, fun = distVincentyEllipsoid) / 1000
    }
    else {
      stor("Data missing!")
    }
  }
  
  con<-file('locationCache.csv',encoding="UTF-8")
  write.csv(locationCache, file=con)  # Cache for later usage.
}

data$SEAT.CAPACITY <- as.numeric(data$SEAT.CAPACITY)
data$distance <- 0
data$lon <- 0
data$lat <- 0
for (i in seq(1, length(data$distance))) {
  data$distance[i] <- locationCache$distance[data$fullLocation[i] == locationCache$city]
  data$lon[i] <- locationCache$lon[data$fullLocation[i] == locationCache$city]
  data$lat[i] <- locationCache$lat[data$fullLocation[i] == locationCache$city]
}
data$takenSeatKilometers <- data$NBR.OF.PASSENGERS * data$distance
data$wastedSeatKilometers <- (data$SEAT.CAPACITY - data$NBR.OF.PASSENGERS) * data$distance
data$cargoKilometers <- data$CARGO.WEIGHT * data$distance

data$DATE <- gsub("\\.", "-", data$DATE)

datesHelper <- as.data.frame(sort(unique(data$DATE)))
colnames(datesHelper) <- c("date")
datesHelper$date <- as.Date(datesHelper$date)
datesHelper$seqNo <- seq(1, length(datesHelper$date))

#TREND ANALYSIS
library(stlplus)

#Passangers
tsnop <- ts(aggregate(x=data$NBR.OF.PASSENGERS, by = list(unique.values = data$DATE.YEAR.MONTH), FUN = sum, na.rm=TRUE)$x, start=c(2007, 1), frequency=12)
tsnop_trend <- stlplus(tsnop, s.window = "periodic")

#Flights
tsnof <- ts(aggregate(x=data$NBR.OF.FLIGHTS, by = list(unique.values = data$DATE.YEAR.MONTH), FUN = sum, na.rm=TRUE)$x, start=c(2007, 1), frequency=12)
tsnof_trend <- stlplus(tsnof, s.window = "periodic")

#Served seat km
tsssk <- ts(aggregate(x=data$takenSeatKilometers, by = list(unique.values = data$DATE.YEAR.MONTH), FUN = sum, na.rm=TRUE)$x, start=c(2007, 1), frequency=12)
tsssk_trend <- stlplus(tsssk, s.window = "periodic")

#Wasted seat km
tswsk <- ts(aggregate(x=data$wastedSeatKilometers, by = list(unique.values = data$DATE.YEAR.MONTH), FUN = sum, na.rm=TRUE)$x, start=c(2007, 1), frequency=12)
tswsk_trend <- stlplus(tswsk, s.window = "periodic")

#Capacity
agg_capacity <- aggregate(x=data$SEAT.CAPACITY, by = list(unique.values = data$DATE.YEAR.MONTH), FUN = sum, na.rm=TRUE)$x
tscap <- ts(agg_capacity, start=c(2007, 1), frequency=12)
tscap_trend <- stlplus(tscap, s.window = "periodic")

#Seat capacity per flight
agg_flight <- aggregate(x=data$NBR.OF.FLIGHTS, by = list(unique.values = data$DATE.YEAR.MONTH), FUN = sum, na.rm=TRUE)$x
tsscpf <- ts(agg_capacity/agg_flight, start=c(2007, 1), frequency=12)
tsscpf_trend <- stlplus(tsscpf, s.window = "periodic")

#Airport profile
agg_distance <- aggregate(x=(data$distance*data$NBR.OF.FLIGHTS), by = list(unique.values = data$DATE.YEAR.MONTH), FUN = sum, na.rm=TRUE)$x
tsap <- ts((agg_distance/agg_flight), start=c(2007, 1), frequency=12)
tsap_trend <- stlplus(tsap, s.window = "periodic")

#Plot trend
library(plotly)
range_standardization <- function(x){(x-min(x))/(max(x)-min(x))}

flights_trend <- range_standardization(tsnof_trend$data$trend)
seat_capacity_per_flight_trend <- range_standardization(tsscpf_trend$data$trend)
served_seat_km_trend <- range_standardization(tsssk_trend$data$trend)
wasted_seat_km_trend <- range_standardization(tswsk_trend$data$trend)

trend_plot <- plot_ly(x = as.POSIXct(as.Date(as.yearmon(tsnof_trend$time))), y = flights_trend*100, name = "Flights", fill = "tozeroy", line = list(color = "rgb(82,195,206)", width = 3)) %>%
  add_trace(x = as.POSIXct(as.Date(as.yearmon(tsscpf_trend$time))), y = seat_capacity_per_flight_trend*100, name = "Seat capacity per flight", fill = "tozeroy", line = list(color = "rgb(60,119,154)", width = 3)) %>%
  add_trace(x = as.POSIXct(as.Date(as.yearmon(tsssk_trend$time))), y = served_seat_km_trend*100, name = "Served seat km", fill = "tozeroy", line = list(color = "rgb(255,194,14)", width = 3)) %>%
  add_trace(x = as.POSIXct(as.Date(as.yearmon(tswsk_trend$time))), y = wasted_seat_km_trend*100, name = "Wasted seat km", fill = "tozeroy", line = list(color = "rgb(201,201,201)", width = 3))

trend_plot <- layout(trend_plot, showlegend = FALSE, xaxis = list(title = "", showgrid = F, type = "date"),  yaxis = list(title = "", showgrid = F, showticklabels = F))

#Plot seasonality
months <- c("Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec", "Jan", "Feb")

flights_seasonality <- range_standardization(tsnof_trend$data$seasonal)[3:14]
seat_capacity_per_flight_seasonality <- range_standardization(tsscpf_trend$data$seasonal)[3:14]
served_seat_km_seasonality <- range_standardization(tsssk_trend$data$seasonal)[3:14]
wasted_seat_km_seasonality <- range_standardization(tswsk_trend$data$seasonal)[3:14]

seasonality_plot <- plot_ly(x = months, y = flights_seasonality*100, name = "Flights", fill = "tozeroy", line = list(color = "rgb(82,195,206)", width = 3)) %>%
  add_trace(x = months, y = seat_capacity_per_flight_seasonality*100, name = "Seat capacity per flight", fill = "tozeroy", line = list(color = "rgb(60,119,154)", width = 3)) %>%
  add_trace(x = months, y = served_seat_km_seasonality*100, name = "Served seat km", fill = "tozeroy", line = list(color = "rgb(255,194,14)", width = 3)) %>%
  add_trace(x = months, y = wasted_seat_km_seasonality*100, name = "Wasted seat km", fill = "tozeroy", line = list(color = "rgb(201,201,201)", width = 3))

seasonality_plot <- layout(seasonality_plot, showlegend = FALSE, xaxis = list(title = "", showgrid = F),  yaxis = list(title = "", showgrid = F, showticklabels = F))

#DESTINATIONS
agg_country_list <- list()
splitted_by_month <- split(data, data$DATE.YEAR.MONTH)
for(i in 1:length(splitted_by_month)) {
  tmp <- aggregate(x=splitted_by_month[[i]]$NBR.OF.PASSENGERS, by = list(unique.values = splitted_by_month[[i]]$COUNTRY), FUN = sum)
  tmp <- tmp[order(-tmp$x),]
  
  countries <- c(tmp[[1]][1:19], "Rest")
  passangers <- c(tmp[[2]][1:19], sum(tmp[20:nrow(tmp),]$x))
  
  agg_country_list[[i]] <- list(countries,passangers)
}
