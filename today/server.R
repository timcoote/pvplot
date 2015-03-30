library (ggvis)
library (dplyr)


cnames = c ("date", "EV", "EA", "EW", "WV", "WA", "WW", "OV", "OA", "OW", "OHz", "Efficiency", "Temp1", "Temp2", "E_Day", "E_Week", "dunno", "E_month", "E_Year", "E Tot1", "E Tot2", "Response")

shinyServer(function(input, output, session) {
#    vals = read.table ("../../logging/output", header = F, col.names = cnames, fill=TRUE)
    vals = reactiveFileReader (1000, session, "../../logging/output", read.table, header = F, col.names = cnames, fill=TRUE)
    
    
    #t4 = mrv (today - 3, 1)
    
    # remove rows with missing values (na.omit)
    t1 = mutate (na.omit (vals), ts = as.POSIXct (date, format= "%Y%m%d-%H:%M:%S"), year = as.POSIXlt (ts)$year, month = as.POSIXlt (ts)$mon, day = as.POSIXlt (ts)$yday + 1, hour = as.POSIXlt(ts)$hour)
    readingfunc = function (tvals) {select (tvals, ts, year, month, day, hour, EW, WW, OW, E_Day, E_month, E_Year, Efficiency)}
#    t = select (t1, ts, year, month, day, hour, EW, WW, OW, E_Day, E_month, E_Year, Efficiency)
    thisdata = readingfunc (t1)
#    thisdata = function () { return (t)}
#    thisdata = reactive ({ return (t)})
    cat ("first\n", file =stderr())    
    cat (class(thisdata), file =stderr())    
    cat ("second\n", file =stderr())    
#    ts = as.POSIXlt (t1$date, format= "%Y%m%d-%H:%M:%S")
    #p = layer_points(ggvis (readingfunc(t1), ~ts, ~E_Day, stroke=~year, fill=~year), size =5 )
    p = layer_points(ggvis (thisdata, ~ts, ~E_Day), size =5 )

    mymax = function (x) {return (max (x))}
    f = function (j) {return (j[1,])}
#    f1 = f (readingfunc(t1))
#    cat (f (thisdata), file = stderr ())

    p %>%  scale_numeric("y", domain = c(0, 4)) %>% set_options (renderer="canvas") %>% bind_shiny("ggvis", "ggvis_ui")

})
