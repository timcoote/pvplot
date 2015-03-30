library (ggvis)
library (dplyr)


cnames = c ("date", "EV", "EA", "EW", "WV", "WA", "WW", "OV", "OA", "OW", "OHz", "Efficiency", "Temp1", "Temp2", "E_Day", "E_Week", "dunno", "E_month", "E_Year", "E Tot1", "E Tot2", "Response")
vals = read.table ("../logging/output", header = F, col.names = cnames, fill=TRUE)


#t4 = mrv (today - 3, 1)

# remove rows with missing values (na.omit)
t1 = mutate (na.omit (vals), ts = as.POSIXct (date, format= "%Y%m%d-%H:%M:%S"), year = as.POSIXlt (ts)$year, month = as.POSIXlt (ts)$mon, day = as.POSIXlt (ts)$yday + 1, hour = as.POSIXlt(ts)$hour)
t = select (t1, ts, year, month, day, hour, EW, WW, OW, E_Day, E_month, E_Year, Efficiency)

ts = as.POSIXlt (t1$date, format= "%Y%m%d-%H:%M:%S")

p = layer_points(ggvis (t, ~ts, ~E_Day, stroke=~year, fill=~year), size=5)
#layer_points(ggvis (vv, ~hour, ~OW, stroke=~year, fill=~year)) 

print (p %>%   scale_numeric("y", domain = c(0, max (t$E_Day))))

