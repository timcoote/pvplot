library (DT)
library (ggvis)
library (dplyr)
library (plyr)
library (zoo)

shinyServer(function(input, output, session) {
    vals = reactiveFileReader (1000, session, "hearts3", read.table, header = F, col.names = c("date", "heartrate", "speed", "height"), fill=TRUE)
#    vals$speed = c (0,0, rollmean(vals$speed,3)) 
# remove rows with missing values (na.omit)
    t1 = reactive ({ mutate (na.omit (vals()), ts = as.POSIXct (date/1000, origin= "1970-1-1"), rm = c(0,0,0,0,0,rollmean(speed,6)), acc=c(0, diff(speed)/4)) })

    thisdata = reactive ({select (t1(), ts, heartrate, speed, height, rm, acc)})

    domE=reactive ({c (0, max (thisdata()$heartrate) + 1) })

#    heartplot =  layer_points(ggvis (thisdata, x = ~ts), y = ~heartrate, size =0.1 ) %>% add_axis ("y", orient="left", title="Heart rate") %>%
    heartplot =  layer_lines(ggvis (thisdata, x = ~ts), y = ~heartrate ) %>% add_axis ("y", orient="left", title="Heart rate") %>%
      scale_numeric ("y", domain=domE) %>%
      add_axis ("y", 'spd', orient="right", title= "Speed (m/s)", grid=F, properties = axis_props (axis = list(stroke= "red"))) %>%
      add_axis ("y", 'hgt', orient="right", offset=50, title= "Altitude (m)", grid=F, properties = axis_props (axis = list(stroke= "blue"))) %>%
      add_axis ("y", 'acc', orient="right", offset=100, title= "Acceleration (m/s^2)", grid=F, properties = axis_props (axis = list(stroke= "orange"))) %>%
#      layer_points (prop ('y', ~height, scale='hgt'), stroke:= "blue", fill :="blue", size=0.1) %>%
      layer_lines (prop ('y', ~height, scale='hgt'), stroke:= "blue") %>%
#      layer_points (prop ('y', ~rm, scale='spd'), stroke :="red", fill := "red", size=0.1) # %>% scale_numeric ("x", domain = c(min(ts()), max(ts())))
      layer_lines (prop ('y', ~speed, scale='spd'), stroke :="green")  %>%
      layer_lines (prop ('y', ~acc, scale='acc'), stroke :="orange")  %>%
      layer_lines (prop ('y', ~rm, scale='spd'), stroke :="red") # %>% scale_numeric ("x", domain = c(min(ts()), max(ts())))

    heartplot  %>%  set_options (renderer="canvas") %>% bind_shiny("cumsum", "cumsum_ui")

    output$theWords = DT::renderDataTable ({ tail (thisdata ()[,c(9, 6,7,8)], 2) }, options = list(paging=FALSE, searching=FALSE, pageLength = 2), rownames=FALSE)
})
