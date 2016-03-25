library (ggvis)
library (dplyr)


cnames = c ("date", "EV", "EA", "EW", "WV", "WA", "WW", "OV", "OA", "OW", "OHz", "Efficiency", "Temp1", "Temp2", "E_Day", "E_Week", "dunno", "E_month", "E_Year", "E Tot1", "E Tot2", "Response")
today = Sys.Date ()

# use closure to avoid R scoping in global variables

mk.read_values = function (from, length) {
    read_values = function (from, length) {

        first_loop = TRUE
        for (d1 in seq (as.Date (from), to=as.Date (from) + length - 1, by="day")) {
            d = as.Date (d1, origin="1970-1-1")
            print (class(d))
            print (d, format (d, "%Y%m%d"))
            t0 = tryCatch ({read.table (gzfile (format (d, format="../logging/output-%Y%m%d.gz")), header = F, col.names = cnames, fill=TRUE)},
                           warning = function (warn) {},
                           error = function (err) {return (as.data.frame (rep (NA, length(cnames))))},
                           finally = {})
            if (first_loop) {
                first_loop = FALSE
                t1 = t0
            } else {t1 = rbind (t1, t0)}
        }
    return (na.omit (t1))

    }

    return (read_values)
}

mrv = mk.read_values (from, to)

#t0 = read.table (gzfile (format (today-3, format="../logging/output-%Y%m%d.gz")), header = F, col.names = cnames, fill=TRUE)
#t2 = read.table (gzfile (format (today-368, format="../logging/output-%Y%m%d.gz")), header = F, col.names = cnames, fill=TRUE)
t0 = mrv (today - (365+6+30), 7+30)
t2 = mrv (today - (6+30), 7+30)

t1 = rbind (t0, t2)
#t_test = na.omit (t0)

#t4 = mrv (today - 3, 1)

# remove rows with missing values (na.omit)
t1 = mutate (na.omit (t1), ts = as.POSIXct (date, format= "%Y%m%d-%H:%M:%S"), year = as.POSIXlt (ts)$year, month = as.POSIXlt (ts)$mon, day = as.POSIXlt (ts)$yday + 1, hour = as.POSIXlt(ts)$hour)
t = select (t1, ts, year, month, day, hour, EW, WW, OW, E_Day, E_month, E_Year, Efficiency)

ts = as.POSIXlt (t1$date, format= "%Y%m%d-%H:%M:%S")
t %>% group_by (year, month, day, hour)
vv = t %>% group_by (year, month, day, hour) %>% summarise_each (funs(max), E_Year)
names (vv) = c("year", "month", "day", "hour", "OW")
p = layer_points(ggvis (vv, ~day, ~OW, stroke=~year, fill=~year), size := input_slider (10, 100))
#layer_points(ggvis (vv, ~hour, ~OW, stroke=~year, fill=~year)) 

print (p %>%   scale_numeric("y", domain = c(0, max (vv$OW))))

