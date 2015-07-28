library (DT)
library (ggvis)
library (dplyr)
library (plyr)


shinyServer(function(input, output, session) {
    vals = reactiveFileReader (1000, session, "hearts2", read.table, header = F, col.names = c("date", "heartrate", "speed"), fill=TRUE)
    
# remove rows with missing values (na.omit)
    t1 = reactive ({ mutate (na.omit (vals()), ts = as.POSIXct (date, origin= "1970-1-1")) })

    thisdata = reactive ({select (t1(), ts, heartrate, speed)})

    domE=reactive ({c (0, max (thisdata()$heartrate) + 1) })

    heartplot =  layer_points(ggvis (thisdata, x = ~ts), y = ~heartrate, size =0.1 ) %>% add_axis ("y", orient="left", title="Heart rate") %>%
      scale_numeric ("y", domain=domE) #%>%
#      add_axis ("y", 'spd', orient="right", title= "Speed ()", grid=F) %>%
#      layer_points (prop ('y', ~speed, scale='spd'), stroke :="red", size=0.1) # %>% scale_numeric ("x", domain = c(min(ts()), max(ts())))

    heartplot  %>%  set_options (renderer="canvas") %>% bind_shiny("cumsum", "cumsum_ui")

    output$theWords = DT::renderDataTable ({ tail (thisdata ()[,c(9, 6,7,8)], 2) }, options = list(paging=FALSE, searching=FALSE, pageLength = 2), rownames=FALSE)
})
