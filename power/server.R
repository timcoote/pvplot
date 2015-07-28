library (ggvis)
library (dplyr)
library (plyr)

cnames = c ("date", "EV", "EA", "EW", "WV", "WA", "WW", "OV", "OA", "OW", "OHz", "Efficiency", "Temp1", "Temp2", "E_Day", "E_Week", "dunno", "E_month", "E_Year", "E Tot1", "E Tot2", "Response")

shinyServer(function(input, output, session) {
    vals = reactiveFileReader (1000, session, "../../logging/output", read.table, header = F, col.names = cnames, fill=TRUE)
    
# remove rows with missing values (na.omit)
    t1 = reactive ({ mutate (na.omit (vals()), ts = as.POSIXct (date, format= "%Y%m%d-%H:%M:%S"), year = as.POSIXlt (ts)$year, month = as.POSIXlt (ts)$mon, day = as.POSIXlt (ts)$yday + 1, hour = as.POSIXlt(ts)$hour) })
    thisdata = reactive ({select (t1(), ts, year, month, day, hour, EV, WV, EW, WW, OW, E_Day, E_month, E_Year, Efficiency)})

    cat ("first\n", file =stderr())    
#    cat (class(t()), file =stderr())    
    cat ("second\n", file =stderr())    
#    p = layer_points(ggvis (readingfunc(t1), ~ts, ~E_Day, stroke=~year, fill=~year), size =5 )
    p =  layer_points(ggvis (thisdata, ~ts, ~EW), size =5 )

    dom=reactive ({c (min(thisdata()$OW), max (thisdata()$OW) + 1) })

    #p  %>%  scale_numeric("y", domain=dom) %>% set_options (renderer="canvas") %>% bind_shiny("ggvis", "ggvis_ui")
    thisdata %>% ggvis (~ts, ~WW, size=1)  %>% layer_points(fill :="red") %>% layer_points (y=~Efficiency, fill:="black") %>% layer_points (x=~ts, y=~EW, fill:="blue") %>%  scale_numeric("y", domain=dom) %>% set_options (renderer="canvas") %>% bind_shiny("ggvis", "ggvis_ui")

#    output$theWords = renderText ({paste ("output today", tail (thisdata ()$E_Day, 1)) })
    output$theWords = renderDataTable ({ tail (thisdata ()[,c(8, 9, 10)], 2) }, options = list(paging=FALSE, searching=FALSE, pageLength = 2))
#    output$theWords = renderUI ({em (paste ("current output", tail (thisdata ()$OW, 1))) })
})
