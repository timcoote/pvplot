# cut from x.R. Should just be the definition of the plot, I suppose
# cannot get subset to work with select for column names containting space

# I am now highly sceptical about the d = zoo () as I'm not convinced that t and ts are the same size....
library (chron)
library (zoo)
library (ggplot2)
library (reshape2)

label_names = list (
   "Mon 14th Oct 2013",
   "Tue 15th Oct 2013",
   "Tue 16th Oct 2013",
   "Tue 17th Oct 2013",
   "Tue 18th Oct 2013")



day_labeller = function (var, val) {
#    return ("hello")
    print (val)
    return (label_names [val-13])
}


cnames = c ("date", "EV", "EA", "EW", "WV", "WA", "WW", "OV", "OA", "OW", "OHz", "Efficiency", "Temp1", "Temp2", "E Day", "E Week", "dunno", "E_month", "E Year", "E Tot1", "E Tot2", "Response")
t1 = read.table (gzfile ("../logging/georgesdata.gz"), header = F, col.names = cnames, fill=TRUE)

t = subset (t1, select = c(EW, WW, OW, E_month, Efficiency))

ts = as.POSIXlt (t1$date, format= "%Y%m%d-%H:%M:%S")

tod=as.POSIXlt (paste ("2013-01-01", ts$hour, ts$min, ts$sec, sep=":"), format="%Y-%m-%d:%H:%M:%S")

mday=ts$mday

d = as.data.frame (cbind (ts, t, tod, mday), order.by = ts)
#d = zoo (as.matrix (t), order.by = ts)


print (summary (t))

print (summary (ts))

print (summary (d))

#byMin = aggregate(d, time(d) - as.numeric(time(d)) %% 60, mean)
byMin = na.omit (aggregate(d, list (as.numeric (d$ts) - as.numeric(d$ts) %% 300), mean, na.action=na.rm))
pdf ()

print (summary (byMin))


readings = melt (byMin, id.vars = c("tod", "mday"), measure.vars = c("OW"))
print (summary (readings))

#p = ggplot (readings) + geom_line ( aes (x=tod, y=value, colour=factor (mday))) + facet_wrap (~ mday, nrow=1, labeller = day_labeller) + labs (y="Mean Power in 5 Minutes (KW)", title="Plot of mean power in 5 minute intervals", x= "Time of Day")
p = ggplot (readings) + geom_line ( aes (x=tod, y=value, colour=factor (mday))) + facet_grid (~ mday, labeller = day_labeller) + labs (y="Mean Power in 5 Minutes (KW)", title="Plot of mean power in 5 minute intervals", x= "Time of Day")
p = p + theme (legend.position="none", axis.text.x = element_text (size = rel (0.5)))
p
#ggplot (byMin) + geom_point ( aes (x=log(OW), y=Efficiency, colour=factor (mday)))


dev.off()
