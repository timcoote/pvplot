library (DT)
library (ggvis)
library (dplyr)
library (plyr)

cnames = c ("date", "EV", "EA", "EW", "WV", "WA", "WW", "OV", "OA", "OW", "OHz", "Efficiency", "Temp1", "Temp2", "E_Day", "E_Week", "dunno", "E_month", "E_Year", "E Tot1", "E Tot2", "Response")

shinyServer(function(input, output, session) {
    vals = reactiveFileReader (1000, session, "hearts", read.table, header = F, col.names = c("date", "rate"), fill=TRUE)
    
# remove rows with missing values (na.omit)
    t1 = reactive ({ mutate (na.omit (vals()), ts = as.POSIXct (date, origin= "1970-1-1"), year = as.POSIXlt (ts)$year, month = as.POSIXlt (ts)$mon, day = as.POSIXlt (ts)$yday + 1, hour = as.POSIXlt(ts)$hour) })

    thisdata = reactive ({select (t1(), ts, year, month, day, hour, rate)})

    cat ("first\n", file =stderr())    
#    cat (class(t()), file =stderr())    
    cat ("second\n", file =stderr())    
    cumE =  layer_points(ggvis (thisdata, ~ts, ~rate), size =0.1 )

    domE=reactive ({c (0, max (thisdata()$rate) + 1) })
    cumE  %>%  scale_numeric("y", domain=domE) %>% set_options (renderer="canvas") %>% bind_shiny("cumsum", "cumsum_ui")

    output$theWords = DT::renderDataTable ({ tail (thisdata ()[,c(9, 6,7,8)], 2) }, options = list(paging=FALSE, searching=FALSE, pageLength = 2), rownames=FALSE)
})
