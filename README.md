# The sky over Budapest
### satRday #1, 2016.09.03. - [Data Visualization Challenge](http://budapest.satrdays.org/#datavizcompo)
##### János Oláh, Flórián Deé, Nóra Lengyel, Imre Kocsis, László Gönczy
##### [Quanopt Ltd.](http://quanopt.com/)

## Dashboard main concept
Our submission consist of a Shiny dashboard showing the main trends of the flight traffic of the Budapest Airport. The dashboard shows the main connections on a world map, a barchart of the most frequently flewn countries (measured in number of passengers), and two charts concentrating on trend and seasonality of four time series of metrics calculated from the base data. These latter charts show how the volume and efficiency of air traffic changed. We were checking IATA and other pages to see what are the most relevant metrics in this field. 
The dashboard presents some stories and observations identified by exploratory/descriptive methods. We use a timeline where we included some external events which might have influenced air traffic: the sale of Budapest airport in 2007, the financial crash in 2008, the eruption of volcano Eyjafjallajökull in 2010 and the bankruptcy of the Hungarian airline (Malév) in 2012.

Besides the dataset itself, we used city coordinates retrieved from Google Maps as a basis for distance calculation. We used the following calculated metrics:
 - Distance
 - Served seat kilometres
 - Wasted seat kilometres
 - Seat capacity per flight
 
The submission will be available from https://quanopt.shinyapps.io/satRday

## "Data stories" of Budapest air traffic
Our main observations of the dataset are the following (based on "common sense" assumptions):
 - Number of flights: Malev bankruptcy is a clearly distinguishable, unpredictable event. Before the bankruptcy: very clear seasonality, trend correlates with the global economy.
 - Seat capacity per flight: Malev bankruptcy correlates with a sudden surge in the increase of the average seat capacity. There is also strong seasonality.
 - Seat km served: The average seat kilometers shows very strong seasonality. The trend is insignificant in absolute terms. The Malev bankruptcy seems to have no apparent effect as it happened in the usually weakest period of the business year.
 - Wasted seat km: Strong seasonality - people not flying a lot in January? The effect of Malev bankruptcy is debatable, but the industry is clearly getting ever more efficient, shown by less wasted kms.

## Packages used
The dashboard uses the following packages for data manipulation, calculation and visualization:
 - Shiny
 - plotly
 - ggmap
 - zoo
 - geosphere
 - stlplus
 - xlsx
