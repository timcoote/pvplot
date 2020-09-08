library (DT)
library (ggvis)
library (dplyr)
#library (plyr)

cnames = c ("date", "EV", "EA", "EW", "WV", "WA", "WW", "OV", "OA", "OW", "OHz", "Efficiency", "Temp1", "Temp2", "E_Day", "E_Week", "dunno", "E_month", "E_Year", "E Tot1", "E Tot2", "Response")

shinyServer(function(input, output, session) {
    vals = reactiveFileReader (10000, session, "/var/run/aurora/output", read.table, header = F, col.names = cnames, fill=TRUE)
    
# remove rows with missing values (na.omit)
    t1 = reactive ({ mutate (na.omit (vals()), ts = as.POSIXct (date, format= "%Y%m%d-%H:%M:%S"), year = as.POSIXlt (ts)$year, month = as.POSIXlt (ts)$mon, day = as.POSIXlt (ts)$yday + 1, hour = as.POSIXlt(ts)$hour) })

    thisdata = reactive ({select (t1(), ts, year, month, day, hour, EW, WW, OW, E_Day, E_month, E_Year, Efficiency)})

#    p = layer_points(ggvis (readingfunc(t1), ~ts, ~E_Day, stroke=~year, fill=~year), size =5 )
    cumE =  layer_lines(ggvis (thisdata, ~ts, ~E_Day) )
    power =  layer_lines(ggvis (thisdata, ~ts, ~EW) )

    domE=reactive ({c (0, max (thisdata()$E_Day) + 1) })
    domP=reactive ({c (min(thisdata()$OW), max (thisdata()$OW) + 1) })
    cumE  %>%  scale_numeric("y", domain=domE) %>% set_options (renderer="canvas") %>% bind_shiny("cumsum", "cumsum_ui")

    thisdata %>% ggvis (~ts, ~WW)  %>% layer_lines(stroke :="red") %>% 
       layer_lines (y=~Efficiency, stroke:="black") %>% layer_lines (x=~ts, y=~EW, stroke:="blue") %>%
       scale_numeric("y", domain=domP) %>% set_options (renderer="canvas") %>% bind_shiny("powervis", "powervis_ui")
    output$theWords = DT::renderDataTable ({ tail (thisdata ()[,c(9, 6,7,8)], 2) }, options = list(paging=FALSE, searching=FALSE, pageLength = 2), rownames=FALSE)
#    output$theWords = renderUI ({em (paste ("current output", tail (thisdata ()$OW, 1))) })
})
