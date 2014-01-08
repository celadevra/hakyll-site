---
title: Open Weather Map
date: 2013-06-26
categories: geography
tags: [data]
---

In the spirit of OpenStreetMap, a UK startup(?), Extreme Electronics Ltd., bring us [Open Weather Map](http://openweathermap.org/about).  The data is collected from global meterological broadcast services and over 40,000 weather stations.

From where I live, the website shows me temperature collected from the nearest weather station, wind, humidity and other useful weather indicators.  Forecasts is given for next day.

![](https://dl.dropboxusercontent.com/u/592567/%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7%202013-06-26%20%E4%B8%8B%E5%8D%886.15.49.png)

Switch to the Daily tab, you get a chart showing the high and low temperature of the past days.  But maybe the Stations tab is the most interesting, you get to know which station provides the data you see, and historical maximum/minimum values if available.

Using OpenStreetMap as the base layer, the website also provide real time precipitation and pressure map.  Thus if you know how to read a presure map, you will be better able to predict wind and precipitation for the next few hours, and arguably this is more useful than the daily weather forecast you see on the TV.

![](https://dl.dropboxusercontent.com/u/592567/%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7%202013-06-26%20%E4%B8%8B%E5%8D%886.23.32.png)

So how is Open Weather Map open?  If you have your own weather station, you can use the website's API to connect, and [upload](http://openweathermap.org/stations) your data.  You can also mash up the weather data on other map products, including WMS, Google Maps, etc.  If this is not open enough, you can also get "raw" data in JSON and XML formats, by specifying the location in interest.

For a user, being able to look at weather data at a much finer resolution and in real time is a nice change from centralized weather information.  For a researcher, the data provision of the website grants the ability to collect weather data from a remote place.  Combine the map with Twitter data we may be able to do some analysis on the relationship between (extreme) weather and online interactions.  There are a lot possibilities.
